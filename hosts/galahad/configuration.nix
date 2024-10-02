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
    ./hardware-configuration.nix
    ../common/core/fonts.nix
    ../../users/aleksic/aleksic.nix
    ../common/core/nixvim.nix
    inputs.home-manager.nixosModules.default
  ];

  # bootloader, grub, since refind cant be managed declaratively

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
      version = 2;
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

    displayManager = {
      sddm.enable = true;
      sddm.theme = "${import ../../sys/sddm/tokyo-night.nix { inherit pkgs; }}";
      defaultSession = "none+dwm";
    };

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.yajl ];
        src = ../../sys/dwm;
      });
    };
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

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  stylix.image = ../../assets/backgrounds/Minimal-Nord.png;

  stylix.cursor.package = pkgs.phinger-cursors;
  stylix.cursor.name = "phinger-cursors-dark";

  stylix.fonts = {
    monospace = {
      package = pkgs.hack-font;
      name = "Hack Regular";
    };

    sansSerif = {
      package = pkgs.fira;
      name = "FiraSans Regular";
    };

    serif = {
      package = pkgs.fira;
      name = "FiraSans Regular";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  stylix.targets.grub.enable = false;
  stylix.targets.nixvim.enable = false;
  stylix.targets.plymouth.enable = true;

  stylix.fonts.sizes = {
    applications = 11;
    terminal = 12;
    desktop = 12;
    popups = 10;
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users."aleksic" = import ../../users/aleksic/home.nix;
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
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects
  ];

  programs.zsh.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  services.openssh.enable = false;

  system.copySystemConfiguration = false;
  system.stateVersion = "24.05"; # Did you read the comment?

}
