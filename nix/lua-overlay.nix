{ pkgs }:
final: prev: {

  rikai-nvim =
    (final.callPackage (
      {
        alogger,
        buildLuarocksPackage,
        fetchurl,
        fetchzip,
        lua,
        mega-cmdparse,
        sqlite,
        utf8,
      }:
      buildLuarocksPackage {
        pname = "rikai.nvim";
        version = "0.0.2-1";
        knownRockspec =
          (fetchurl {
            url = "mirror://luarocks/rikai.nvim-0.0.2-1.rockspec";
            sha256 = "1nraiwafqhxpfkqqd568kdi2ps1j825sxzy22ixnlpyqbin5988b";
          }).outPath;
        src = fetchzip {
          url = "https://github.com/teto/rikai.nvim/archive/0.0.2.zip";
          sha256 = "1rb4fsnxsrq3cl441san88s6mq6xjg006jc1ilqbgxdjpra6vaw8";
        };

        disabled = lua.luaversion != "5.1";
        propagatedBuildInputs = [
          alogger
          mega-cmdparse
          sqlite
          utf8
        ];

        meta = {
          homepage = "https://github.com/teto/rikai.nvim";
          description = "rikaitan for neovim, i.e., japanese translation integrated ";
          license.fullName = "LGPL-3.0";
        };
      }
    ))
      { };

  alogger = final.callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitLab,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "alogger";
      version = "0.6.0-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/alogger-0.6.0-1.rockspec";
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
    }
  ) { };

  utf8 = final.callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "utf8";
      version = "1.3-0";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/utf8-1.3-0.rockspec";
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
    }
  ) { };

  lual = final.callPackage (
    {
      buildLuarocksPackage,
      fetchFromGitHub,
      fetchurl,
      luaOlder,
    }:
    buildLuarocksPackage {
      pname = "lual";
      version = "1.0.15-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/lual-1.0.15-1.rockspec";
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
    }
  ) { };

  lsqlite3 = final.callPackage (
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

  mega-cmdparse = final.callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
      mega-logging,
    }:
    buildLuarocksPackage {
      pname = "mega.cmdparse";
      version = "1.2.1-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/mega.cmdparse-1.2.1-1.rockspec";
          sha256 = "1766pqazkr3zfwaaj541m53y90n5zr0r7068hd67d9hgvd7za6sb";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/ColinKennedy/mega.cmdparse/archive/v1.2.1.zip";
        sha256 = "1bf3rf80m65jc51dlv3vcs2jhzk5ni2kr7v5rsmb31k7wk3002qb";
      };

      propagatedBuildInputs = [ mega-logging ];

      meta = {
        homepage = "https://github.com/ColinKennedy/mega.cmdparse";
        description = "A Neovim command-mode parser. Similar to Python's argparse module";
        license.fullName = "MIT";
      };
    }
  ) { };

  mega-logging = final.callPackage (
    {
      buildLuarocksPackage,
      fetchurl,
      fetchzip,
    }:
    buildLuarocksPackage {
      pname = "mega.logging";
      version = "1.1.6-1";
      knownRockspec =
        (fetchurl {
          url = "mirror://luarocks/mega.logging-1.1.6-1.rockspec";
          sha256 = "1va6vl4iqnc3ip2ws1ff65xavw1m6wgdrsal1gvqnjn0gh20vxbg";
        }).outPath;
      src = fetchzip {
        url = "https://github.com/ColinKennedy/mega.logging/archive/v1.1.6.zip";
        sha256 = "0sy7f42rbdanz9bi0kq6vzllykqcrp04bp7b5k3cqpml5ckywpl5";
      };

      meta = {
        homepage = "https://github.com/ColinKennedy/mega.logging";
        description = "A Neovim plugin for logging to Neovim or to disk";
        license.fullName = "MIT";
      };
    }
  ) { };

}
