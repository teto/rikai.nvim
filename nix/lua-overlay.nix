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

        runtimeDeps = [
          pkgs.librsvg
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

}
