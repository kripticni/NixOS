{
  pkgs,
}:
pkgs.stdenv.mkDerivation {
  pname = "sddm-astronaut";
  version = "1.0";

  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "48ea0a792711ac0c58cc74f7a03e2e7ba3dc2ac0";
    hash = "sha256-kXovz813BS+Mtbk6+nNNdnluwp/7V2e3KJLuIfiWRD0=";
  };

  dontWrapQtApps = true;
  propagatedBuildInputs = with pkgs.kdePackages; [
    qt5compat
    qtsvg
  ];

  installPhase =
    let
      basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
      image = "/home/aleksic/NixOS/assets/backgrounds/nixstorm.png";
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
      rm ${basePath}/background.png
      cp ${image} ${basePath}/background.png
    '';
}
