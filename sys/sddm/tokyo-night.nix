# credits to https://www.reddit.com/r/NixOS/comments/14dlvbr/sddm_theme/
{ pkgs }:

let
  imgLink = "https://wallpapers.com/images/hd/gnu-linux-dark-tux-hd-modibhlh5jzhoux6.jpg";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "15ml1wgpvqyic3n22f6mqcd3qfr26h176xk7i5hcl69yccvkkkr5";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "siddrs";
    repo = "tokyo-night-sddm";
    rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    hash = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Backgrounds/win11.png
    cp -r ${image} Backgrounds/win11.png
  '';

}
