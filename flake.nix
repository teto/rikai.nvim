{
  description = "Development shell for rikai.nvim";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    edict-kanji-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.5/kanji.zip";
      flake = false;
    };

    edict-expression-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.5/expression.zip";
      flake = false;
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        inherit (vanilla_pkgs) lib;
        vanilla_pkgs = nixpkgs.legacyPackages.${system};
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.luaOverlay
          ];

        };

        # python3.pkgs.python.pkgs exists and
        # p is probably python3.pkgs
        mojimoji =
          p:
          pkgs.callPackage ./default.nix {
            # builtins.trace p.pkgs.python.version
            python = p.pkgs.python3;
          };

        # make sure the luaPkgOverlay was applied to the interpreter
        lua = pkgs.lua5_1;

        # TODO I should be able to remove those as they get provided via lux
        luaEnv = lua.withPackages (lp: [
          lp.alogger
          lp.sqlite # lux can't build it
          lp.busted
          lp.nlua
          # lp.lsqlite3 # official bindings
          lp.utf8 # installed by nx
        ]);

        # for text-to-speech, e.g., to read japanese out loud
        fugashi-unidic =
          p: p.fugashi
        #   p.toPythonModule (p.fugashi.overridePythonAttrs(oa: {
        #
        #   # tests succeed with unidic-lite but fail with unidic :/
        #   nativeBuildInputs = oa.optional-dependencies.unidic ++ oa.nativeBuildInputs;
        #   dependencies = (oa.dependencies or []) ++ oa.optional-dependencies.unidic;
        # }))
        ;

        # lacks mojimoji for now
        pyEnv =
          let
            # TODO use toPythonModule
            # the default uses unidic-lite

            # TODO override fugashi to use a fugashi with optional-dependencies.unidic ?
            misaki-jp =
              p:
              (p.misaki.override ({
                fugashi = fugashi-unidic p;
              })).overridePythonAttrs
                (oa: {
                  dependencies =
                    oa.dependencies
                    ++ oa.passthru.optional-dependencies.ja
                    ++ [
                      # needs mojimoji and pyopenjtalk, both marked as not packaged
                      # but pyopenjtalk is available from voicevox-engine
                      pkgs.voicevox-engine.passthru.pyopenjtalk
                      (p.toPythonModule (mojimoji p))
                    ];
                });

            kokoro_jp =
              p:
              p.toPythonModule (
                (p.kokoro.override ({
                  misaki = misaki-jp p;
                })).overridePythonAttrs
                  ({

                    #  'pyopenjtalk' is apparently the newest version
                    patchPhase = ''
                      substituteInPlace kokoro/pipeline.py \
                        --replace-fail "ja.JAG2P()" "ja.JAG2P(version= 'pyopenjtalk')"
                    '';

                  })
              );

          in
          pkgs.python3.withPackages (p: [
            (kokoro_jp p)
            p.soundfile
            p.pip
            p.spacy-models.en_core_web_sm
          ]);

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./nix/treefmt.nix;
      in

      {

        packages = {
          default = lua.pkgs.rikai-nvim;
          # TODO call pkgs.vimUtils.toVimPlugin  on it ?
          inherit (lua.pkgs) rikai-nvim;

          pyEnv = pyEnv;
          fugashi = fugashi-unidic pkgs.python3.pkgs;
          mojimoji = mojimoji pkgs.python3.pkgs;

          sudachi-rs-full = pkgs.sudachi-rs.override {
            sudachidict = pkgs.python3Packages.sudachidict-full;
          };

        };

        devShells = {
          ci = self.devShells.${system}.default.overrideAttrs (oa: {
            buildInputs = oa.buildInputs ++ [
              pkgs.neovim-unwrapped
            ];
          });

          default = pkgs.mkShell {
            name = "rikai.nvim";

            buildInputs = [
              treefmtEval.config.build.wrapper
              luaEnv
              pkgs.just # for 'just'
              # lx can autoinstall busted
              pkgs.lux-cli # lux

              pkgs.librsvg # for rsvg-convert executable
              pkgs.sudachi-rs

              # pyEnv
              pkgs.sqlite.dev # to install lsqlite3 via luarocks
              pkgs.cmake # needed for luv install ?
              pkgs.sqlite.dev # for sqlite3.h

              pkgs.emmylua-check
              pkgs.pkg-config # required by lux ?
              pkgs.vimcats
            ];

            shellHook =
              let
                # soon not needed anymore once we get
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

                # this should be bone automatically wtf
                exposeLib =
                  { name, dep }:
                  [
                    ''${name}_INCDIR="${lib.getDev dep}/include"''
                    ''${name}_LIBDIR="${lib.getLib dep}/lib"''
                    ''${name}_BINDIR="${lib.getBin dep}/bin"''
                  ];

                # passed to the tests
                dictionariesFolder = pkgs.symlinkJoin {
                  name = "rikai-data";
                  paths = [
                    self.inputs.edict-kanji-db
                    self.inputs.edict-expression-db
                    # ln -sf "${self.inputs.edict-expression-db}/expression.db" .lux/5.1/test_dependencies/5.1/home/xdg/local/share/nvim/rikai/
                  ];

                };
              in

              ''
                mkdir -p .luarocks
                # todo change the lux test folder instead
                #  /home/runner/work/rikai.nvim/rikai.nvim/
                export RIKAI_DICTIONARIES_FOLDER="${dictionariesFolder}"

                cat ${configFile} >> .luarocks/config-5.1.lua
                ${lib.concatMapStringsSep "\n" (val: "export ${val}") (exposeLib {
                  name = "SQLITE";
                  dep = pkgs.sqlite;
                })}
                export LUA_PATH="$LUA_PATH;lua/?.lua"
                # this is used by `lx shell` but for some reason SHELL still points to the older one
                export SHELL=${pkgs.bashInteractive}/bin/bash
                echo "export LUA_PATH='$(lx path lua)'" > .lua.env
                echo "export LUA_CPATH='$(lx path c)'" >> .lua.env
                source .lua.env
              '';
          };
        };
      }
    )
    // {
      # formatter = treefmtEval.config.build.wrapper;

      overlays = {
        luaOverlay = final: prev: {
          lua5_1 = prev.lua5_1.override {
            packageOverrides = import ./nix/lua-overlay.nix { pkgs = final; };
          };
        };
      };
    };
}
