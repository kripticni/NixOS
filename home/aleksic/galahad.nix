{
  self,
  home-manager,
  inputs,
  pkgs,
  ...
}: {
  home.username = "aleksic";
  home.homeDirectory = "/home/aleksic";
  home.stateVersion = "24.05";

  nixpkgs.config.allowUnfree = true;

  stylix.targets = {
    neovim.enable = false;
    vim.enable = false;
    alacritty.enable = false;
    zathura.enable = true;
    kde.enable = true;
  };

  imports = [
    ./common/core
    ./common/opts/alacritty
    ./common/opts/zsh
    ./common/opts/brave
    #./common/opts/syncthing weird idle network behavior
    ./common/opts/zathura
    ./common/opts/flameshot
    ./common/opts/ncmpcpp
  ];

  home.packages = with pkgs; [
    flatpak

    viber
    discord
    discordo
    telegram-desktop

    vlc
    eog
    gthumb

    nautilus
    kdePackages.dolphin

    obsidian
    libreoffice

    spotdl

    polybarFull # TODO:Convert to common/opts/polybar
    picom # TODO:Convert to common/opts/picom

    fastfetch # TODO:Convert to common/opts/fastfetch
    btop
    tty-clock
    cbonsai
    #ranger

    netcat
    nmap
    wireshark
    dig
    #busybox
    arp-scan
    fcrackzip
    john
    hashcat
    volatility3
    autopsy
    sleuthkit
    binwalk
    ghex
    bvi
    #ftk imager
    inetutils
    upx
    #pwntools installing the python module in user also gets us these
    #checksec
  ];

  home.file = {
    ".dwm/autostart.sh".source = ../../assets/scripts/autostart.sh; # TODO: consider moving this to .config if possible, relies on patch
    ".dwm/bar.sh".source = ../../assets/scripts/bar.sh;
  };

  xdg.configFile = {
    "clangd/config.yaml".source = ../../assets/config/clangd;
    "pwn.conf".source = ../../assets/config/pwn.conf;
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
    RUBY_THREAD_VM_STACK_SIZE = 1000000; # fix for zsteg
    _JAVA_AWT_WM_NONREPARENTING = 1; # fix for some java apps on wms
  };

  programs.home-manager.enable = true;
}
