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
        version = "nightly";
        knownRockspec = ../rikai.nvim-scm-1.rockspec;
        src = pkgs.lib.cleanSource ../.;

        propagatedBuildInputs = [
          mega-cmdparse
          mega-logging
          lsqlite3
          luautf8
        ];

        runtimeDeps = [
          pkgs.librsvg
        ];

        # runtime dependencies of the standalone `rikai` executable
        postFixup = ''
          wrapProgram $out/bin/rikai \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.sudachi-rs pkgs.curl pkgs.unzip pkgs.librsvg ]}
        '';

        meta = {
          broken = lua.luaversion != "5.1";
          homepage = "https://github.com/teto/rikai.nvim";
          description = "rikaitan for neovim, i.e., japanese translation integrated ";
          license = pkgs.lib.licenses.gpl3Only;

        };
      }
    ))
      { };

}
