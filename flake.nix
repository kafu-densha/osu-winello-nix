{
  description = "run osu-winello on nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    osu-winello-source = {
      url = "github:NelloKudo/osu-winello";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      osu-winello-source,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      osu-winello-unwrapped = pkgs.stdenv.mkDerivation {
        pname = "osu-winello";
        version = "latest";
        src = osu-winello-source;

        patches = [
          # use steam-run in the .desktop file for osu
          (pkgs.fetchpatch2 {
            url = "https://github.com/kafu-densha/osu-winello/commit/046a5470e8a5214a13f5b3bb6b6e1fb6e322cb4b.patch";
            hash = "sha256-10HSAlvP23moBR4sNP2wkeXQ++4qzsf4C/TZ+rQDsk4=";
          })
        ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          mkdir -p $out/bin $out/share/osu-winello

          cp -r * $out/share/osu-winello/
          chmod +x $out/share/osu-winello/osu-winello.sh

          makeWrapper $out/share/osu-winello/osu-winello.sh $out/bin/osu-winello \
            --prefix PATH : ${
              pkgs.lib.makeBinPath (
                with pkgs;
                [
                  git
                  wget
                  zenity
                  xdg-desktop-portal
                  unzip
                ]
              )
            }
        '';
      };

      osu-winello = pkgs.writeShellScriptBin "osu-winello" ''
        exec ${lib.getExe pkgs.steam.run} ${osu-winello-unwrapped}/bin/osu-winello "$@"
      '';
    in
    {
      packages.${system}.default = osu-winello;

      apps.${system}.default = {
        type = "app";
        program = "${osu-winello}/bin/osu-winello";
      };
    };
}
