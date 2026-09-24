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
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          wget
          zenity
          xdg-desktop-portal
          unzip
          steam-run
        ];

        shellHook = ''
          steam-run ${osu-winello}/osu-winello.sh
	  steam-run osu-wine
        '';
      };
    };
}
