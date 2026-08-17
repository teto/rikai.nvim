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

}
