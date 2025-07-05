{
  description = "A very basic flake";

  inputs = {
    nixpkgs = {
      # use my fork where jmdict is packaged
      url = "github:nixos/nixpkgs/nixos-unstable";
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
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      lua = pkgs.luajit;
      lual = lua.pkgs.callPackage ({ buildLuarocksPackage, fetchFromGitHub, fetchurl, luaOlder }:
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


    lsqlite3 = lua.pkgs.callPackage (
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

    in
    {

      devShells.x86_64-linux.default =
          pkgs.mkShell {
            name = "jap.nvim";

            # dict = jmdict ;
            buildInputs = [ 
              lua.pkgs.busted 
              lua.pkgs.nlua
              pkgs.sudachi-rs
            ];

            #               ln -s ${jitindex} ./yomitan.jitindex
            shellHook = ''

              echo "${self.inputs.kanji-db}"
              echo "${self.inputs.expression-db}"
              echo "${lual}"
              echo "${lsqlite3}"

              export LUA_PATH="$LUA_PATH;lua/?.lua"
              '';

        };
    };
}
