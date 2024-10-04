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
  ];

  home.file = {
    ".dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.configFile = {
    "dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;
  };

  home.sessionVariables = {
    GTK_THEME = "Nordic";
    # QT_STYLE_OVERRIDE = "Nordic"; # dolphin complains
    # EDITOR = "emacs";
  };

  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };

  #qt = {
  #  enable = true;
  #  platformTheme.name = "gtk";
  #  style.package = pkgs.nordic;
  #  style.name = "Nordic";
  #};

  #export GTK_THEME=Nordic
  gtk = {
    enable = true;
    theme.package = lib.mkForce pkgs.nordic;
    theme.name = lib.mkDefault "Nordic";
    iconTheme.package = pkgs.nordzy-icon-theme;
    iconTheme.name = "Nordzy";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
