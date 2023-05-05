{
  description = "A very basic flake";

  inputs = {
    nixpkgs = {
      # use my fork where jmdict is packaged
      url = "github:teto/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {

      devShells.x86_64-linux.default =
        let
          jmdict = pkgs.fetchurl {
            url = "http://ftp.edrdg.org/pub/Nihongo/JMdict.gz";
            sha256 = "sha256-QK9z57i7MnzO7PUeqTadKAELODp3GEa57Xgv4peYnXk=";
          };
        in
          pkgs.mkShell {
            name = "jap.nvim";

            dict = jmdict ;
            buildInputs = [ ];

        };
    };
}
