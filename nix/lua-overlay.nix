{ pkgs }:
final: prev: {

  rikai-nvim =
    (final.callPackage (
      {
        buildLuarocksPackage,
        lua,
        mega-cmdparse,
        mega-logging,
        sqlite,
        utf8,
      }:
      buildLuarocksPackage {
        pname = "rikai.nvim";
        version = "0.1.0-1";
        knownRockspec = pkgs.runCommand "rikai.nvim-0.1.0-1.rockspec" { } ''
          substitute ${../rikai.nvim-0.1.0-1.rockspec} $out \
            --replace-fail '"lsqlite3",' '"sqlite",'
        '';
        # clean
        src = pkgs.lib.cleanSource ../.;

        disabled = lua.luaversion != "5.1";
        propagatedBuildInputs = [
          mega-cmdparse
          mega-logging
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

  # mega-logging = final.callPackage (
  #   {
  #     buildLuarocksPackage,
  #     fetchzip,
  #     fetchurl,
  #     luaOlder,
  #   }:
  #   buildLuarocksPackage {
  #     pname = "mega.logging";
  #     version = "1.1.6-1";
  #     knownRockspec =
  #       (fetchurl {
  #         url = "mirror://luarocks/mega.logging-1.1.6-1.rockspec";
  #         hash = "sha256-b/UNBHzASov3C1Tp3B43NfCtejHOBc3FjYNZHAndRu0=";
  #       }).outPath;
  #     src = fetchzip {
  #       url = "https://github.com/ColinKennedy/mega.logging/archive/v1.1.6.zip";
  #       hash = "sha256-hV7uJyu0XszGLOvcRcDNDE9P6d8GTxBX+la1lQVxx2s=";
  #     };
  #
  #     disabled = luaOlder "5.1";
  #
  #     meta = {
  #       homepage = "https://github.com/ColinKennedy/mega.logging";
  #       description = "A Neovim plugin for logging to Neovim or to disk";
  #       license.fullName = "MIT";
  #     };
  #   }
  # ) { };

  # lual = final.callPackage (
  #   {
  #     buildLuarocksPackage,
  #     fetchFromGitHub,
  #     fetchurl,
  #     luaOlder,
  #   }:
  #   buildLuarocksPackage {
  #     pname = "lual";
  #     version = "1.0.15-1";
  #     knownRockspec =
  #       (fetchurl {
  #         url = "mirror://luarocks/lual-1.0.15-1.rockspec";
  #         sha256 = "0dnnvw6rvdh3i8qhqknanwwppbcjqd0d43g28v6i8dc34hkgjw54";
  #       }).outPath;
  #     src = fetchFromGitHub {
  #       owner = "arthur-debert";
  #       repo = "lual";
  #       rev = "a7641c252c4c604b63572a24cdcf2490029a6414";
  #       hash = "sha256-JkIYz+h56MTHyFws9h/CbhmDrgGSmLZGTXsbM748Wkg=";
  #     };
  #
  #     disabled = luaOlder "5.1";
  #
  #     meta = {
  #       homepage = "https://github.com/arthur-debert/lual";
  #       description = "A focused but powerful and flexible logging library for Lua.";
  #       license.fullName = "MIT";
  #     };
  #   }
  # ) { };

}
