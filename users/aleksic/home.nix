{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "aleksic";
  home.homeDirectory = "/home/aleksic";
  home.stateVersion = "24.05";

  imports = [
    ../common/terminal/zsh.nix
    ./theme.nix
  ];
  home.packages = with pkgs; [
    phinger-cursors
    fastfetch
    nautilus
    eog
    gthumb
    kdePackages.dolphin
    nordic
    nordzy-icon-theme
    utterly-nord-plasma
    libreoffice

    polybarFull
    picom-pijulius
    alacritty
    git
  ];

  home.file = {
    ".dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;
  };

  xdg.configFile = {
    "dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;

    "Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid".source = "${pkgs.utterly-nord-plasma}/share/Kvantum/Utterly-Nord-Solid/";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Utterly-Nord-Solid";
  };

  home.sessionVariables = {
    GTK_THEME = "Nordic";
    EDITOR = "nvim";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  programs.home-manager.enable = true;
}
