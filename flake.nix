{
  description = "Development shell for rikai.nvim";

  inputs = {
    nixpkgs = {
      # use my fork where jmdict is packaged
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    lux = {
      url = "github:nvim-neorocks/lux";
    };

    kanji-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.2/kanji.zip";
      flake = false;
    };

    expression-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.2/expression.zip";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, ... }:
    let
      platform = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # python3.pkgs.python.pkgs exists and 
      # p is probably python3.pkgs
      mojimoji = p:  pkgs.callPackage ./default.nix {
        python = builtins.trace p.pkgs.python.version p.pkgs.python3;
      };

      # TODO I should be able to remove those as they get provided via lux
      luaEnv = lua.withPackages(lp: [ 
        # lp.alogger
        # lp.lual # unused logging library
        lp.sqlite # lux can't build it
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
              lua.pkgs.busted 
              lua.pkgs.nlua

              luaEnv
              pyEnv
              pkgs.cmake   # needed for luv install ?
              pkgs.sudachi-rs
              self.inputs.lux.packages.${platform}.lux-cli
              self.inputs.lux.packages.${platform}.lux-lua51
              pkgs.pkg-config # required by lux ?
              pkgs.vimcats
            ];

            shellHook = ''
              export LUA_PATH="$LUA_PATH;lua/?.lua"
              # this is used by `lx shell` but for some reason SHELL still points to the older one
              export SHELL=${pkgs.bashInteractive}/bin/bash
              echo "export LUA_PATH='$(lx path lua)'" > .lua.env
              echo "export LUA_CPATH='$(lx path c)'" >> .lua.env
              source .lua.env
              '';
        };

        overlays = {
          luaOverlay = pkgs.callPackage ./nix/lua-overlay.nix {};
        };
    };
}
