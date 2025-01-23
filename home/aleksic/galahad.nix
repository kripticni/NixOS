{
  self,
  home-manager,
  inputs,
  pkgs,
  ...
}:

{
  home.username = "aleksic";
  home.homeDirectory = "/home/aleksic";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  stylix.targets = {
    alacritty.enable = false;
    zathura.enable = true;
    kde.enable = true;
  };

  imports = [
    ./common/core
    ./common/opts/alacritty
    ./common/opts/zsh
    ./common/opts/brave
    ./common/opts/syncthing
    ./common/opts/zathura
    ./common/opts/flameshot
    ./common/opts/ncmpcpp
  ];

  home.packages = with pkgs; [
    flatpak

    viber
    discord
    discordo
    telegram-desktop

    vlc
    eog
    gthumb

    nautilus
    kdePackages.dolphin

    obsidian
    libreoffice

    spotdl

    polybarFull # TODO:Convert to common/opts/polybar
    picom # TODO:Convert to common/opts/picom

    fastfetch # TODO:Convert to common/opts/fastfetch
    btop
    # ranger
  ];

  home.file = {
    ".dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;
    ".dwm/bar.sh".source = ../../assets/scripts/bar.sh;
    ".config/clangd/config.yaml".source = ../../assets/config/clangd/config.yaml;
  };

  xdg.configFile = {
    "dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;

    "Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid".source =
      "${pkgs.utterly-nord-plasma}/share/Kvantum/Utterly-Nord-Solid/";
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=Utterly-Nord-Solid";

    "polybar/nord".source = ../../sys/polybar/nord;
    "polybar/system.ini".source = ../../sys/polybar/system.ini;

    "picom/".source = ../../sys/picom;
  };

  xdg.dataFile = {
    "backgrounds".source = ../../assets/backgrounds;
  };

  home.sessionVariables = {
    GTK_THEME = "Nordic";
    EDITOR = "nvim";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  programs.home-manager.enable = true;
}
