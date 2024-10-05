{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    image = ../../assets/backgrounds/Minimal-Nord.png;

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.hack-font;
        name = "Hack Regular";
      };

      sansSerif = {
        package = pkgs.fira;
        name = "FiraSans Regular";
      };

      serif = {
        package = pkgs.fira;
        name = "FiraSans Regular";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      grub.enable = false;
      nixvim.enable = false;
      gtk.enable = false;
      #kde.enable = true; apperantly only with home manager
      plymouth.enable = true;
    };

    fonts.sizes = {
      applications = 11;
      terminal = 12;
      desktop = 12;
      popups = 10;
    };
  };
}