{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./stylix.nix # since this is single user for now, no need to migrate to hm
    ./hardware-configuration.nix
    ../common/core
    ../common/users/aleksic.nix
    ../common/opts/dwm
    ../common/opts/nvf
    ../common/opts/tor
    ../common/opts/xmrig
    ../common/opts/virt
    inputs.home-manager.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_6_12;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.supportedFilesystems = ["ntfs"];
  boot.kernelParams = [ "mds=nosmt" ]; # default mitigation for MDS leaks
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;
      theme = ../../sys/grub;
    };
  };

  hardware.bluetooth.enable = false; # continues to be not needed as of now
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = false; 

  hardware.graphics = {
    # opengl
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = ["nvidia"];
  boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11_legacy470];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:9:0:0";
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
    setxkbmap -layout "us,rs,rs" -variant ",latin," -option "grp:alt_shift_toggle"
  '';

  services.displayManager = {
    sddm.enable = true;
    sddm.theme = "${import ../../sys/sddm/tokyo-night.nix {
      inherit pkgs;
    }}";
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
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.8"
  ];
  environment.systemPackages = with pkgs; [
    pavucontrol
    cairo
    feh
    mpd

    sddm-astronaut
    kdePackages.qtstyleplugin-kvantum
    kdePackages.breeze-icons
    kdePackages.qtsvg
    # kdePackages.libplasma # pulls kwallet 
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    libsForQt5.qt5.qtsvg
    qt5.full
    qtcreator

    gtk4
    gtk3
    gtk2

    sysstat
    nix-prefetch-scripts
    nix-prefetch
    nix-output-monitor
    nix-search-cli
    nix-index
    nvd
    cachix

    xcolor
    xclip

    gnome-remote-desktop
    openssh
    openssl

    librsvg
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

  environment.pathsToLink = ["/share/zsh"];

  programs.slock.enable = true;
  services.gvfs.enable = true;
  programs.zsh.enable = true;
  programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  services.gnome.gnome-remote-desktop.enable = true;
  services.openssh.enable = true;
  programs.ssh.enableAskPassword = false;

  system.copySystemConfiguration = false;
  system.stateVersion = "24.05";
}
