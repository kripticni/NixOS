{
  pkgs,
  lib,
  themeConfig ? null,
}:
pkgs.stdenvNoCC.mkDerivation rec {
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
      iniFormat = pkgs.formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };

      basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
      image = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/kripticni/NixOS/refs/heads/main/assets/backgrounds/nixstorm.png";
        sha256 = "b4c5993e6063b014686d870ea5a5df523c507f4445756e829b38d9be88abe092";
        curlOptsList = [ "-HUser-Agent: Wget/1.21.4" ];
      };
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
      rm ${basePath}/background.png
      cp ${image} ${basePath}/background.png
    ''
    + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';

  meta = {
    description = "Modern looking qt6 sddm theme";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danid3v ];
  };
}
