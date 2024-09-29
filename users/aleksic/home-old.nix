{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "aleksic";
  home.homeDirectory = "/home/aleksic";

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enableProfileFonts = true;

  home.packages = with pkgs; [
    # # Standard sys utilities
    btop
    htop
    fastfetch
    ranger
    git
    gitui

    # # Screen apps
    xflux-gui
    flameshot

    # # Gnome
    gnome.nautilus
    gnome.eog
    gthumb
    # # # Gnome Theming
    gtk4
    gtk3

    # # Plasma
    qt5.full
    qtcreator
  
    # # Terminal
    alacritty
    zsh
    tmux
    oh-my-posh

    # # VIMs
    vim
    neovim
    neovide
    zathura
    
    # # Themes
    orchis-theme
    kdePackages.oxygen
    whitesur-kde
    whitesur-gtk-theme
    whitesur-icon-theme
    nordzy-icon-theme
    phinger-cursors

    # # Fonts
    material-icons
    material-symbols
    nerdfonts
    unifont
    unifont_upper
    fira-code-nerdfont
    fira-code
    roboto-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans

    # # Tried minecraft launchers, might try to port tlauncher here
    atlauncher
    prismlauncher

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  fonts.fontconfig.enable = true;

  # Theming
  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  }; 

  # GTK theming
  gtk = {
    enable = true;

    cursorTheme.package = pkgs.phinger-cursors;
    cursorTheme.name = "phinger-cursors-dark";

    theme.package = pkgs.whitesur-gtk-theme;
    theme.name = "Dark";

    iconTheme.package =pkgs.whitesur-icon-theme;
    iconTheme.name = "Dark";
  };

  # QT theming
  qt = {
    platformTheme = "gtk";

    style.name = "whitesur-kde";
    style.package = pkgs.whitesur-kde;
  };
  
  xdg.mimeApps.defaultApplications = {
    "text/plain" = [ "neovide.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "image/*" = [ "gnome.eog.desktop" ];
    "video/*" = [ "vlc.desktop" ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    autocd = true;

    defaultKeymap = "viins";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      ls="ls --color=auto";
      dir="dir --color=auto";
      vdir="vdir --color=auto";
      grep="grep --color=auto";
      fgrep="fgrep --color=auto";
      egrep="egrep --color=auto";
      diff="diff --color=auto";
      ip="ip --color=auto";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "night-owl";
  };

  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "kripticni";
    userEmail = "kripticno@gmail.com";
  };

# Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };


## TODO ADD MIMETYPES AND ADD GTK CONFIG


}
