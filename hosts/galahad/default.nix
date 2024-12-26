{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./stylix.nix # since this is single user for now, no need to migrate to hm
    ./hardware-configuration.nix
    ../common/core
    ../common/users/aleksic.nix
    ../common/opts/dwm
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
      theme = ../../sys/grub;
    };
  };

  hardware.bluetooth.enable = false; # no use for it rn
  hardware.graphics = {
    # opengl
    enable = true;
    enable32Bit = true;
  };

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enable = true;
    };
  };

  networking.hostName = "galahad";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Belgrade";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
    "sr_RS/UTF-8"
    "sr_RS@latin/UTF-8"
    "sr_ME/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_CTYPE = "C.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  fonts.fontDir.enable = true;

  services.xserver.displayManager.sessionCommands = ''
    num_monitors=$(xrandr | grep -c ' connected')
    intern=$(xrandr | grep connected | awk '{print $1}' | tr '\n' ' ' | awk '{print $1}')
    extern=$(xrandr | grep connected | awk '{print $1}' | tr '\n' ' ' | awk '{print $2}')
    if [ "$num_monitors" -gt 1 ]; then
       xrandr --output $intern --off && xrandr --output $extern --mode 1920x1080
    fi
    setxkbmap -layout "us,rs" -option "grp:alt_shift_toggle"
  '';

  services.displayManager = {
    sddm.enable = true;
    sddm.theme = "${import ../../sys/sddm/astronaut.nix { inherit pkgs; }}";
    defaultSession = "none+dwm";
  };

  services.libinput.enable = true;
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nix.settings.allowed-users = [
    "aleksic"
    "@wheel"
  ];
  nix.settings.trusted-users = [
    "aleksic"
    "@wheel"
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    pavucontrol
    cairo
    feh
    mpd

    kdePackages.qtstyleplugin-kvantum
    kdePackages.breeze-icons
    kdePackages.qtsvg
    kdePackages.libplasma
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    libsForQt5.qt5.qtsvg
    libsForQt5.dolphin
    qt5.full

    gtk4
    gtk3
    gtk2

    nix-prefetch-scripts
    nix-prefetch
    nix-output-monitor
    nix-search-cli
    nvd
    cachix

    xcolor
    xclip
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  environment.pathsToLink = [ "/share/zsh" ];

  services.gvfs.enable = true;
  programs.zsh.enable = true;
  programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  services.openssh.enable = false;
  programs.ssh.enableAskPassword = false;

  system.copySystemConfiguration = false;
  system.stateVersion = "24.05";
}
