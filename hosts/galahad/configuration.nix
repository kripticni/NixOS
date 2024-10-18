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
    ./stylix.nix # TODO: best to migrate my specific settings to the home manager, but keep plymouth in the nixosModule
    ./hardware-configuration.nix
    ../../users/aleksic/galahad.nix
    ../common/core/nixvim.nix
    ../common/core/fonts.nix
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  #boot.loader.systemd-boot.enable = true;
  boot.plymouth.enable = true;
  boot = {
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
      #efiInstallAsRemovable = true;
      #extraEntries = ''
      #	menuentry "Windows" {
      #		insmod part_gpt
      #		insmod fat
      #		insmod search_fs_uuid
      #		insmod chain
      #		search --fs-uuid --set=root bc541d20-5209-46e7-ae9f-015d2e4878a4
      #		chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      #	}
      #	'';
    };
  };

  hardware.graphics = {
    # opengl
    enable = true;
    enable32Bit = true;
  };

  hardware.bluetooth.enable = true;

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enable = true;
    };
  };

  #for some reason, this is awfully buggy and slow
  #nixpkgs.config.nvidia.acceptLicense = true;
  #services.xserver.videoDrivers = [ "nvidia" ];
  #hardware.nvidia = {
  #  modesetting.enable = true;
  #  powerManagement.enable = false;
  #  powerManagement.finegrained = false;
  #  open = false;
  #  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  #};
  #hardware.nvidia.prime = {
  #  sync.enable = true;
  #  intelBusId = "PCI:0:2:0";
  #  nvidiaBusId = "PCI:9:0:0";
  #};

  networking.hostName = "galahad";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Belgrade";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  fonts.fontDir.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.yajl ];
        src = ../../sys/dwm;
      });
    };
  };

  services.xserver.displayManager.sessionCommands = ''
    num_monitors=$(xrandr | grep -c ' connected')
    intern=$(xrandr | grep connected | awk '{print $1}' | tr '\n' ' ' | awk '{print $1}')
    extern=$(xrandr | grep connected | awk '{print $1}' | tr '\n' ' ' | awk '{print $2}')
    if [ "$num_monitors" -gt 1 ]; then
       xrandr --output $intern --off && xrandr --output $extern --mode 1920x1080
    fi
  '';

  services.displayManager = {
    sddm.enable = true;
    sddm.theme = "${import ../../sys/sddm/tokyo-night.nix { inherit pkgs; }}";
    defaultSession = "none+dwm";
  };

  services.libinput.enable = true;

  # Enable CUPS to print documents, not right now due to the CVE
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.allowed-users = [
    "aleksic"
    "@wheel"
  ];
  nix.settings.trusted-users = [
    "aleksic"
    "@wheel"
  ];

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

  services.openssh.enable = false;
  services.gvfs.enable = true;

  programs.zsh.enable = true;
  programs.mtr.enable = true;
  programs.dconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  programs.ssh.enableAskPassword = false;

  system.copySystemConfiguration = false;
  system.stateVersion = "24.05";
}
