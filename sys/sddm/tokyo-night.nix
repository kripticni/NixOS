# credits to https://www.reddit.com/r/NixOS/comments/14dlvbr/sddm_theme/
{ pkgs }:

let
  #imgLink = "https://wallpapercave.com/uwp/uwp4516635.png";
  imgLink = "https://i.ibb.co/Jn5nqcS/gnu-linux-1.png";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "1iaj2yfmqjmxap1553nnkm40mfd0kahqdgp16n6k5zl0lvz6w46f";
    curlOptsList = [ "-HUser-Agent: Wget/1.21.4" ];
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
