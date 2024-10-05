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

  imports = [ ../common/terminal/zsh.nix ];
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

  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.package = pkgs.utterly-nord-plasma;
    style.name = "kvantum";
  };

  gtk = {
    enable = true;
    theme.package = lib.mkForce pkgs.nordic;
    theme.name = lib.mkDefault "Nordic";
    iconTheme.package = pkgs.nordzy-icon-theme;
    iconTheme.name = "Nordzy";
  };

  programs.home-manager.enable = true;
}
