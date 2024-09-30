{ config, pkgs, host, username, options, ... }:
let inherit (import ./variables.nix) keyboardLayout;
in {
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
  ];

  boot = {
    # Kernel
    # kernelPackages = pkgs.linuxPackages_6_6_42;
    # Needed For Some Steam Games
    kernel.sysctl = { "vm.max_map_count" = 2147483642; };
    # Bootloader.
    loader = {
      timeout = 0;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/EFI/";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
      magicOrExtension = "\\x7fELF....AI\\x02";
    };
    plymouth = {
      enable = true;
      theme = "matrix";
      themePackages = [ pkgs.plymouth-matrix-theme ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  # Styling Options
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./../../config/wallpapers/wallpaper.jpg;
    polarity = "dark";
    targets = {
      fish.enable = false;
      plymouth.enable = false;
      #grub.useImage = ./../../config/wallpapers/grub.png;
      grub.useImage = true;
      nixos-icons.enable = false;
    };
    base16Scheme = {
      base00 = "11121d";
      base01 = "1A092D";
      base02 = "331354";
      base03 = "593380";
      base04 = "7b43bf";
      base05 = "b08ae6";
      base06 = "555661";
      base07 = "f8c0ff";
      base08 = "00d9e9";
      base09 = "aa00a3";
      base0A = "f29df2";
      base0B = "c965bf";
      base0C = "F80059";
      base0D = "550068";
      base0E = "82034c";
      base0F = "470546";
    };
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-dark";
      size = 24;
    };

    opacity = {
      terminal = 0.9;
      desktop = 0.95;
      popups = 0.95;
    };

    fonts = {
      monospace = {
        package = pkgs.hack-font;
        name = "Hack-Regular";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Extra Module Options
  drivers.nvidia.enable = true;
  drivers.nvidia-prime = {
    enable = true;
    intelBusID = "PCI:0:2:0";
    nvidiaBusID = "PCI:9:0:0";
  };
  drivers.intel.enable = true;
  vm.guest-services.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default
    ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages =
    [ "openssl-1.1.1w" "python-2.7.18.8" ];
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.overlays = [
    (final: prev: {
      nginxStable = prev.nginxStable.override { openssl = pkgs.openssl_3_3; };
    })
  ];

  users = { mutableUsers = true; };

  environment.systemPackages = with pkgs; [
    # # Sys-things for ricing
    polybarFull
    # rofi
    picom-pijulius
    vim

    # # Firmware
    sof-firmware
    openssl_3_3

    # # Nix utils
    nix-prefetch-scripts
    nh
    nixfmt-rfc-style

    # # Audio and graphical things
    vlc
    pulseaudioFull
    pavucontrol
    alsa-lib
    alsa-oss
    alsa-utils
    alsa-tools
    lsof
    mpd
    ncmpcpp
    imagemagick
    feh
    ffmpeg

    # # Theming
    # sddm-sugar-dark
    qt5.full
    qt6.qt5compat
    qtcreator
    kdePackages.full
    libsForQt5.full
    kdePackages.sddm
    kdePackages.sddm-kcm
    kdePackages.qt5compat
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qtsvg
    libsForQt5.sddm
    libsForQt5.sddm-kcm
    libsForQt5.qt5ct
    libsForQt5.qtgraphicaleffects
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.quickflux
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qtsvg

    # # Xorg
    xcbuild
    xcbuildHook
    xorg.xcbutilerrors
    xorg.xinit
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.libxcb.dev
    xorg.libxcb
    xorg.xcbproto
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilimage
    xorg.xcbutilcursor

    # # Needed utils
    mount
    util-linux
    mount-zip
    squashfuse
    fuse
    jmtpfs
    wget
    killall
    cairo
    eza
    cmatrix
    htop
    btop
    libvirt
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    ydotool
    duf
    ncdu
    pciutils
    socat
    ripgrep
    lshw
    brightnessctl
    virt-viewer
    appimage-run
    networkmanagerapplet
    yad
    inxi
    playerctl
    libvirt
    gnome.file-roller
    imv
    mpv
    gimp
    pavucontrol
    tree

    # # Fonts
    fontconfig

    fira-code-nerdfont
    fira-code
    roboto-mono
    noto-fonts
    noto-fonts-monochrome-emoji
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-cjk-sans
    font-awesome
    symbola
    material-icons

    # # Nice things to have from other distroes
    rpm
    dpkg
    libselinux
    libsepol

    # # Other libraries
    yajl
    pcre
    pcre2

    # # Apps
    brave
    firefox
  ];

  fonts = {
    packages = with pkgs; [
      fira-code-nerdfont
      fira-code
      roboto-mono
      noto-fonts
      noto-fonts-monochrome-emoji
      noto-fonts-emoji
      noto-fonts-cjk
      noto-fonts-cjk-sans
      font-awesome
      symbola
      material-icons
    ];
  };

  # Services to start
  services = {
    xserver = {
      enable = true;
      xkb = { layout = "${keyboardLayout}"; };
      displayManager = {
        sddm.enable = true;
        defaultSession = "none+dwm";
      };
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs (oldAttrs: {
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.yajl ];
          src = ./dwm;
        });
      };
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    rpcbind.enable = false;
    nfs.server.enable = false;
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # Security  
  security.rtkit.enable = true;

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  console.keyMap = "${keyboardLayout}";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
