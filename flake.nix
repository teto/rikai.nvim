{
  description = "Development shell for rikai.nvim";

  inputs = {
    nixpkgs = {
      # use my fork where jmdict is packaged
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    lux = {
      url = "github:nvim-neorocks/lux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    edict-kanji-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.5/kanji.zip";
      flake = false;
    };

    edict-expression-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.5/expression.zip";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }:
    let
      platform = "x86_64-linux";
      inherit (pkgs) lib;
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # python3.pkgs.python.pkgs exists and 
      # p is probably python3.pkgs
      mojimoji = p:  pkgs.callPackage ./default.nix {
        # builtins.trace p.pkgs.python.version 
        python = p.pkgs.python3;
      };

      # TODO I should be able to remove those as they get provided via lux
      luaEnv = lua.withPackages(lp: [ 

        # lp.alogger
        # lp.lual # unused logging library
        # lp.sqlite # lux can't build it

        # lux can't build lsqlite3 'cos the website's antibot detection throws it off
        lp.lsqlite3  # official bindings

        # lp.utf8 installed by nx
      ]);

      # lua = pkgs.luajit.override ;
      lua = pkgs.lua5_1.override {
        packageOverrides = self.overlays.luaOverlay;
      };
      
      # for text-to-speech, e.g., to read japanese out loud
      fugashi-unidic = p:
          p.fugashi
        #   p.toPythonModule (p.fugashi.overridePythonAttrs(oa: {
        #
        #   # tests succeed with unidic-lite but fail with unidic :/
        #   nativeBuildInputs = oa.optional-dependencies.unidic ++ oa.nativeBuildInputs;
        #   dependencies = (oa.dependencies or []) ++ oa.optional-dependencies.unidic;
        # }))
      ;

      # lacks mojimoji for now
      pyEnv = let 
        # TODO use toPythonModule
        # the default uses unidic-lite

        # TODO override fugashi to use a fugashi with optional-dependencies.unidic ?
        misaki-jp = p: (p.misaki.override({
          fugashi = fugashi-unidic p;
        })).overridePythonAttrs(oa: {
          dependencies = oa.dependencies 
          ++ oa.passthru.optional-dependencies.ja 
          ++ [
              # needs mojimoji and pyopenjtalk, both marked as not packaged
              # but pyopenjtalk is available from voicevox-engine
              pkgs.voicevox-engine.passthru.pyopenjtalk
              (p.toPythonModule (mojimoji p))
            ];
          });

        kokoro_jp = p: p.toPythonModule ((p.kokoro.override({
          misaki = misaki-jp p;
        })).overridePythonAttrs({

          #  'pyopenjtalk' is apparently the newest version
          patchPhase = ''
            substituteInPlace kokoro/pipeline.py \
              --replace-fail "ja.JAG2P()" "ja.JAG2P(version= 'pyopenjtalk')"
            '';

        }));

      in 
      pkgs.python3.withPackages(p: [ 
        (kokoro_jp p)
        p.soundfile
        p.pip
        p.spacy-models.en_core_web_sm
      ]);

    in
    {
      packages.${platform} = {
        default = pyEnv;
        pyEnv = pyEnv;
        fugashi = fugashi-unidic pkgs.python3.pkgs;
        mojimoji = mojimoji pkgs.python3.pkgs;
      };

      devShells.${platform}.default =
          pkgs.mkShell {
            name = "rikai.nvim";

            # dict = jmdict ;
            buildInputs = [ 
              luaEnv
              # lx can autoinstall busted
              # lua.pkgs.busted  # careful with order as this puts a different lua in PATH
              # lua.pkgs.nlua

              # pyEnv
              pkgs.sqlite.dev # to install lsqlite3 via luarocks
              pkgs.cmake   # needed for luv install ?
              pkgs.sqlite.dev # for sqlite3.h
              pkgs.sudachi-rs
              self.inputs.lux.packages.${platform}.lux-cli
              self.inputs.lux.packages.${platform}.lux-lua51
              pkgs.pkg-config # required by lux ?
              pkgs.vimcats
            ];

            # not packaged in nixpkgs yet
            # ${pkgs.lib.toShellVars pkgs.lua5_1.lsqlite3.variables}
            shellHook = let 
              luarocksConfContent = pkgs.lib.generators.toLua { asBindings = true; } luarocksConfig;
              luarocksConfig = pkgs.lua.pkgs.luaLib.generateLuarocksConfig { 

                externalDeps = [
                    {
                      name = "SQLITE";
                      dep = pkgs.sqlite;
                    }
                ];
              }; 
              configFile = pkgs.writeTextFile {
                name = "rikai-dev-luarocks-config.lua";
                text = luarocksConfContent;
              };

            exposeLib = { name, dep }:
            [
              ''${name}_INCDIR="${lib.getDev dep}/include"''
              ''${name}_LIBDIR="${lib.getLib dep}/lib"''
              ''${name}_BINDIR="${lib.getBin dep}/bin"''
            ];

            in 
              ''
                mkdir -p .luarocks
                ln -s "${self.inputs.edict-kanji-db}/kanji.db" .
                ln -s "${self.inputs.edict-expression-db}/expression.db" .

                cat ${configFile} >> .luarocks/config-5.1.lua
                ${lib.concatMapStringsSep "\n" (val: "export ${val}") (exposeLib { name = "SQLITE"; dep = pkgs.sqlite; }) }
                export LUA_PATH="$LUA_PATH;lua/?.lua"
                # this is used by `lx shell` but for some reason SHELL still points to the older one
                export SHELL=${pkgs.bashInteractive}/bin/bash
                echo "export LUA_PATH='$(lx path lua)'" > .lua.env
                echo "export LUA_CPATH='$(lx path c)'" >> .lua.env
                source .lua.env
                '';
        };

        overlays = {
          luaOverlay = import ./nix/lua-overlay.nix { inherit pkgs; };
        };
    };
}
