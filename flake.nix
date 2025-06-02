{
  description = "A very basic flake";

  inputs = {
    nixpkgs = {
      # use my fork where jmdict is packaged
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    jitindex = {
      flake = false; 
      url = "https://github.com/stephenmk/stephenmk.github.io/releases/latest/download/jitendex-yomitan.zip";
    };
          # jmdict = pkgs.fetchurl {
          #   url = "http://ftp.edrdg.org/pub/Nihongo/JMdict.gz";
          #   sha256 = "sha256-QK9z57i7MnzO7PUeqTadKAELODp3GEa57Xgv4peYnXk=";
          # };

  };

  outputs = { self, nixpkgs, jitindex }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {

      devShells.x86_64-linux.default =
          pkgs.mkShell {
            name = "jap.nvim";

            # dict = jmdict ;
            buildInputs = [ ];

            shellHook = ''

              ln -s ${jitindex} ./yomitan.jitindex
              '';

        };
    };
}
