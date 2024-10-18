{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  users.users.aleksic = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "pulseaudio"
      "audio"
      "alsa"
      "networkmanager"
      "video"
      "home-manager"
      "nix-users"
    ];
    packages = with pkgs; [
      vim
      neovide
      tree
      ripgrep
      tmux

      ffmpeg
      imagemagick

      util-linux
      rpm
      dpkg

      aria2
      curl
      wget
      zip
      unzip
      gnutar

      mount
      mount-zip
      squashfuse
      fuse
      jmtpfs

      exiftools
      mdbtools

      efibootmgr
      pciutils
      cryptsetup
      luksmeta

      distrobox
      podman
      lilipod
      docker
      dive
      docker-compose
      podman-compose

      gcc
      gdb
      pipx
      gnumake
      pkg-config
    ];
    shell = pkgs.zsh;
    initialPassword = "pw123";
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
    };
    users."aleksic" = {
      home.username = "aleksic";
      home.homeDirectory = "/home/aleksic";
      home.stateVersion = "24.05";

      stylix.targets = {
        alacritty.enable = false;
      };

      imports = [
        ./common/core
        ./common/opts/alacritty/alacritty.nix
        ./common/opts/zsh.nix
      ];
      home.packages = with pkgs; [
        phinger-cursors
        nordzy-icon-theme
        utterly-nord-plasma
        nordic

        brave
        viber
        telegram-desktop
        discord
        discordo
        nautilus
        eog
        gthumb
        vlc
        kdePackages.dolphin
        obsidian
        syncthing
        libreoffice
        zathura

        ncmpcpp

        polybarFull
        picom-pijulius

        fastfetch
        btop
        ranger
      ];

      home.file = {
        ".dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;
      };

      xdg.configFile = {
        "dwm/autostart.sh".source = ../../assets/scripts/autostart.sh;

        "Kvantum/Utterly-Nord-Solid-Plasma/Utterly-Nord-Solid".source = "${pkgs.utterly-nord-plasma}/share/Kvantum/Utterly-Nord-Solid/";
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
    };
  };
}
