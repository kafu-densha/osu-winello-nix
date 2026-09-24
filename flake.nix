{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    osu-winello = {
      url = "github:NelloKudo/osu-winello";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      osu-winello,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          osu = pkgs.callPackage ./osu.nix {
            inherit osu-winello;
          };
          default = self.packages.${system}.osu;
        }
      );
    };
}
