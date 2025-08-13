{
  description = "A very basic flake";

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

    # jitindex = {
    #   flake = false; 
    #   url = "https://github.com/stephenmk/stephenmk.github.io/releases/latest/download/jitendex-yomitan.zip";
    # };
    # jmdict = pkgs.fetchurl {
    #   url = "http://ftp.edrdg.org/pub/Nihongo/JMdict.gz";
    #   sha256 = "sha256-QK9z57i7MnzO7PUeqTadKAELODp3GEa57Xgv4peYnXk=";
    # };

  };

  outputs = { self, nixpkgs, ... }:
    let
      platform = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # TODO install those via lux
      luaEnv = lua.withPackages(lp: [ 
        lp.alogger
        lp.lual
        lp.sqlite
        lp.utf8
      ]);

      # lua = pkgs.luajit.override ;
      lua = pkgs.lua5_1.override {
        packageOverrides = self.overlays.luaOverlay;
      };

    in
    {

      devShells.${platform}.default =
          pkgs.mkShell {
            name = "rikai.nvim";

            # dict = jmdict ;
            buildInputs = [ 
              lua.pkgs.busted 
              lua.pkgs.nlua
              luaEnv
              pkgs.sudachi-rs
              self.inputs.lux.packages.${platform}.lux-cli
              self.inputs.lux.packages.${platform}.lux-lua51
              pkgs.pkg-config # required by lux ?
            ];

            #               ln -s ${jitindex} ./yomitan.jitindex
            shellHook = ''

              echo "${self.inputs.kanji-db}"
              echo "${self.inputs.expression-db}"

              export LUA_PATH="$LUA_PATH;lua/?.lua"
              '';

        };

        #
        overlays = {
          luaOverlay = luafinal: luaprev: {

          alogger = luafinal.luaPackages.callPackage ({ buildLuarocksPackage, fetchFromGitLab, fetchurl, luaOlder }:
          buildLuarocksPackage {
            pname = "alogger";
            version = "0.6.0-1";
            knownRockspec = (fetchurl {
              url    = "mirror://luarocks/alogger-0.6.0-1.rockspec";
              sha256 = "02hwrx2pxj1vbrv3hsd7bri6hyvajkfs4wvfb70z36h4awn3y2w7";
            }).outPath;
            src = fetchFromGitLab {
              owner = "lua_rocks";
              repo = "alogger";
              rev = "v0.6.0";
              hash = "sha256-/OVwQvm+ViK0rpIbQOzKWYAeLSLBHEPLqlz+r+LmCbA=";
            };

            disabled = luaOlder "5.1";

            meta = {
              homepage = "https://gitlab.com/lua_rocks/alogger";
              description = "simple logger";
              license.fullName = "MIT";
            };
          }) {};

          utf8 = luafinal.luaPackages.callPackage ({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
            buildLuarocksPackage {
              pname = "utf8";
              version = "1.3-0";
              knownRockspec = (fetchurl {
                url    = "mirror://luarocks/utf8-1.3-0.rockspec";
                sha256 = "1szsrwb15yyvrqwyqrr7g5ivihc0kl4pc7qq439q235f3x8jv2jp";
              }).outPath;
              src = fetchFromGitHub {
                # use starwing instead
                owner = "dannote";
                repo = "luautf8";
                rev = "f36cc914ae9015cd3045987abadd83bbcfae98f0";
                hash = "sha256-xLWqglAzqcxY+R8GOC+D3uzL2+9ZriEx8Kj41LkI5vU=";
              };

              disabled = luaOlder "5.1";

              meta = {
                homepage = "http://github.com/starwing/luautf8";
                description = "A UTF-8 support module for Lua";
                license.fullName = "MIT";
              };
            }) {};


          lual = luafinal.luaPackages.callPackage ({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
            buildLuarocksPackage {
              pname = "lual";
              version = "1.0.15-1";
              knownRockspec = (fetchurl {
                url    = "mirror://luarocks/lual-1.0.15-1.rockspec";
                sha256 = "0dnnvw6rvdh3i8qhqknanwwppbcjqd0d43g28v6i8dc34hkgjw54";
              }).outPath;
              src = fetchFromGitHub {
                owner = "arthur-debert";
                repo = "lual";
                rev = "a7641c252c4c604b63572a24cdcf2490029a6414";
                hash = "sha256-JkIYz+h56MTHyFws9h/CbhmDrgGSmLZGTXsbM748Wkg=";
              };

              disabled = luaOlder "5.1";

              meta = {
                homepage = "https://github.com/arthur-debert/lual";
                description = "A focused but powerful and flexible logging library for Lua.";
                license.fullName = "MIT";
              };
            }) {};

        lsqlite3 = luafinal.callPackage (
          {
            buildLuarocksPackage,
            fetchurl,
            fetchzip,
            luaAtLeast,
            luaOlder,
          }:
          buildLuarocksPackage {
            pname = "lsqlite3";
            version = "0.9.6-1";
            knownRockspec =
              (fetchurl {
                url = "mirror://luarocks/lsqlite3-0.9.6-1.rockspec";
                sha256 = "1wb51lsfllmbzrjfl0dzxpg597nd54nn06c9plpvqwwjz4l9lrjf";
              }).outPath;
            src = fetchzip {
              url = "https://lua.sqlite.org/home/zip/lsqlite3_v096.zip?uuid=v0.9.6";
              sha256 = "060qmdngzmigk4zsjq573a59j7idajlzrj43xj9g7xyp1ps39bij";
            };

            disabled = luaOlder "5.1" || luaAtLeast "5.5";

            externalDeps = [
              {
                name = "SQLITE";
                dep = pkgs.sqlite;
              }
            ];

            meta = {
              homepage = "http://lua.sqlite.org/";
              description = "A binding for Lua to the SQLite3 database library";
              maintainers = with pkgs.lib.maintainers; [ teto ];
              license.fullName = "MIT";
            };
          }
        ) { };

        };
        };
    };
}
