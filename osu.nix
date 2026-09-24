{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  wget,
  zenity,
  xdg-desktop-portal-gtk,
  unzip,
  ...
}:

stdenv.mkDerivation {
  name = "osu-winello";

  src = fetchFromGitHub {
    owner = "NelloKudo";
    repo = "osu-winello";
    rev = "2914ed7687e99d43dde7821c3fd04f3723725723";
    hash = "sha256-4i9bN3SFNGz0+rW6/JU3epxZpoLsB2cNi7M+Uy/lYD4=";
  };

  buildInputs = [
    git
    wget
    zenity
    xdg-desktop-portal-gtk
    unzip
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    patchShebangs ./osu-winello.sh
    chmod +x ./osu-winello.sh
    ./osu-winello.sh

    runHook postInstall
  '';
}

# let
#   fhsEnv = pkgs.buildFHSEnv {
#     name = "my-fhs-runner";
#     targetPkgs = pkgs: with pkgs; [ zlib glib ];
#     runScript = "my-binary"; # The executable name inside your source
#   };
# in
# # 2. Package your source code/binary and link it to the FHS runner
# pkgs.stdenv.mkDerivation rec {
#   pname = "my-fhs-package";
#   version = "1.0.0";
#
#   # Specify your source here (can be local path, fetchurl, fetchFromGitHub, etc.)
#   src = ./my-source-code-dir;
#
#   dontBuild = true;
#
#   installPhase = ''
#     mkdir -p $out/bin
#
#     # Copy your source/binary into the Nix store output
#     cp -r $src/* $out/bin/
#
#     # Wrap your binary inside the FHS environment so it always executes with FHS paths
#     mv $out/bin/my-binary $out/bin/.my-binary-unwrapped
#     ln -s ${fhsEnv}/bin/my-fhs-runner $out/bin/my-binary
#   '';
# }
