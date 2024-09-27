{ pkgs, username, host, ...}:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";
  nixpkgs.config.allowUnfree = true;

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    ../../config/fastfetch
    ../../config/neovim.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    ../../config/fastfetch
  ];

  # Place Files Inside Home Directory
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/face.jpg".source = ../../config/face.jpg;

  # Install & Configure Git
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
  };

  # Create XDG Dirs
  xdg = {
    mimeApps.defaultApplications = {
      "text/plain" = [ "neovide.desktop" ];
      "application/pdf" = [ "zathura.desktop" ];
      "image/*" = [ "gnome.eog.desktop" ];
      "video/*" = [ "vlc.desktop" ];
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options

  stylix.targets.rofi.enable = false;
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
  };


  # Scripts
  home.packages = [
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/squirtle.nix { inherit pkgs; })
    (import ../../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
    # # Standard sys utilities
    pkgs.btop
    pkgs.htop
    pkgs.fastfetch
    pkgs.ranger
    pkgs.git
    pkgs.gitui

    # # Screen apps
    pkgs.xflux-gui
    pkgs.flameshot

    # # Gnome
    pkgs.gnome.nautilus
    pkgs.gnome.eog
    pkgs.gthumb
    # # # Gnome Theming
    pkgs.gtk4
    pkgs.gtk3

    # # Plasma
    pkgs.qt5.full
    pkgs.qtcreator
  
    # # Terminal
    pkgs.alacritty
    pkgs.zsh
    pkgs.tmux
    pkgs.oh-my-posh

    # # VIMs
    pkgs.vim
    pkgs.neovide
    pkgs.zathura
    
    # # Themes
    pkgs.orchis-theme
    pkgs.kdePackages.oxygen
    pkgs.whitesur-kde
    pkgs.whitesur-gtk-theme
    pkgs.whitesur-icon-theme
    pkgs.nordzy-icon-theme
    pkgs.phinger-cursors

    # # Fonts
    pkgs.material-icons
    pkgs.material-symbols
    pkgs.nerdfonts
    pkgs.unifont
    pkgs.unifont_upper
    pkgs.fira-code-nerdfont
    pkgs.fira-code
    pkgs.roboto-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
    pkgs.noto-fonts-monochrome-emoji
    pkgs.noto-fonts-cjk-sans
  ];

 #home.pointerCursor = {
 #  name = "phinger-cursors-dark";
 #  package = pkgs.phinger-cursors;
 #  size = 32;
 #  gtk.enable = true;
 #  x11.enable = true;
 #}; 

  programs = {
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
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
      path = "/home/aleksic/.zsh/history";
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "night-owl";
  };


# Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };



}
