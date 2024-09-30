# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.
  nix.settings.stalled-download-timeout = 99999999;

  # Set your time zone.
  time.timeZone = "Europe/Belgrade";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #  useXkbConfig = true; # use xkb.options in tty.
  };
  fonts.fontDir.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    displayManager = {
      sddm.enable = true;
      #sddm.theme = "${import ./sddm-ed-theme.nix { inherit pkgs; }}";
      #sddm.theme = pkgs.sddm-sugar-dark;
      #sddm.theme = "${import ./sugar-cd-theme.nix { inherit pkgs; }}";
      #sddm.theme = "${(pkgs.fetchFromGitHub {
      #	owner = "Kangie";
      #	repo = "sddm-sugar-candy";
      #	rev = "d31dbf58286ecdcd3a490cd0c9d9ba2f15c26920";
      #	hash = "sha256-HMlzUyRvXvzjaeq4FDxsHZga1zsn1w2Ln7SpctqjWk8=";
      #})}";
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

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Hardware
  hardware.bluetooth.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Support for other fs-es
  services.gvfs.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aleksic = {
    isNormalUser = true;
    extraGroups = [
      "pulseaudio"
      "audio"
      "alsa"
      "networkmanager"
      "wheel"
      "sudo"
      "video"
      "audio"
      "home-manager"
      "nix-users"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # # Firmware
      sof-firmware

      # # You can get this on any distro and it doesnt need configuring
      libreoffice

      # # Virtual envs
      distrobox
      podman
      lilipod
      docker

      dive
      podman-tui
      docker-compose
      podman-compose

      # # Comms
      discord
      discordo
      spotify
      spotifyd
      telegram-desktop
      viber

      # # Build things that dont need configs, and also compilers
      meson
      ninja
      gdb
      clang
      libgcc
      gcc
      rustup
      cmake
      pkg-config

      # # Everyday utils that dont need configs
      cryptsetup
      luksmeta
      gnumake
      unzip
      zip
      gnutar
      wget
      aria2
      ripgrep
      ripgrep-all

      # # Python, altho im not sure if this is how its configured
      (python312Full.withPackages (ps: [ ps.pkgconfig ps.requests ps.pip ]))
      jdk
      jre8
      pipx

      # # Everyday apps that I use and dont config
      brave
      firefox
      vlc
      # gnome.eog, moved to home-manager
      # gthumb, moved to home-manager
      obsidian
      syncthing
      virtualbox
      scrcpy
      gimp
      drawing

      # # Nice utils I'll start using
      bat
      delta
      lsd

      spotdl
      lazygit

      # # Games, and wine, but doubt ill actually use any of this, its nice to have just in case tho
      protonplus
      lutris
      steam
      heroic
      gogdl
      wine

      # # A LIST OF RUST THINGS I'D LIKE, for when i start learning rust
      # # cargo
      # # clippy
      # # rustfmt
      # # rustup
      # # evcxr
      # # bacon
      # # sccache
      # # uutils-coreutils
      # # gitui
      # # cargo-info
      # # speedtest-rs
      # # wiki-tui
    ];
    initialPassword = "pw123";
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.permittedInsecurePackages =
    [ "openssl-1.1.1w" "python-2.7.18.8" ];
  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.overlays = [
    (final: prev: {
      nginxStable = prev.nginxStable.override { openssl = pkgs.openssl_3_3; };
    })
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.allowed-users = [ "aleksic" "@wheel" ];
  nix.settings.trusted-users = [ "aleksic" "@wheel" ];

  environment.systemPackages = with pkgs; [
    # # Just sys utils for ricing
    polybarFull
    rofi
    picom-pijulius

    # # Audio and graphical things
    vlc
    pulseaudioFull
    pavucontrol
    alsa-lib
    alsa-oss
    alsa-utils
    alsa-tools
    lsof
    openssl_3_3
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

    # # Needed utilities
    nix-prefetch-scripts
    cairo
    mount
    util-linux
    mount-zip
    squashfuse
    fuse
    jmtpfs
    fontconfig

    # # Fonts
    material-icons
    material-symbols
    nerdfonts
    fira-code-nerdfont
    fira-code
    roboto-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans

    # # Nice things to have from other distroes
    rpm
    dpkg
    libselinux
    libsepol

    # # Other libraries
    yajl
    pcre
    pcre2

    # # Apps, that seem to need system access
    brave
    firefox
  ];

  environment.shells = with pkgs; [ zsh bash ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}
