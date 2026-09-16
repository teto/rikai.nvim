{ pkgs }:
final: prev: {

  rikai-nvim =
    (final.callPackage (
      {
        buildLuarocksPackage,
        lua,
        mega-cmdparse,
        mega-logging,
        lsqlite3,
        luautf8,
      }:
      buildLuarocksPackage {
        pname = "rikai.nvim";
        version = "0.1.0-1";
        knownRockspec = ../rikai.nvim-0.1.0-1.rockspec;
        src = pkgs.lib.cleanSource ../.;

        disabled = lua.luaversion != "5.1";
        propagatedBuildInputs = [
          mega-cmdparse
          mega-logging
          lsqlite3
          luautf8
        ];

        runtimeDeps = [
          pkgs.librsvg
        ];

        meta = {
          homepage = "https://github.com/teto/rikai.nvim";
          description = "rikaitan for neovim, i.e., japanese translation integrated ";
          license = pkgs.lib.licenses.gpl3Only;

        };
      }
    ))
      { };

}
