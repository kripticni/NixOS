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
      xclip

      ffmpeg
      imagemagick

      man
      rpm
      dpkg

      aria2
      curl
      wget
      zip
      unzip
      gnutar
      file
      bc

      util-linux
      gparted
      hdparm
      mount
      mount-zip
      squashfuse
      fuse
      jmtpfs
      brightnessctl

      exiftool
      steghide
      mdbtools

      outils
      efibootmgr
      pciutils
      cryptsetup
      luksmeta

      distrobox
      podman
      docker
      dive
      docker-compose
      podman-compose

      nodejs_23

      octaveFull
      conda
      (python312.withPackages (python312Packages: with python312Packages; [
        requests
        urllib3
        #socketio-client
        paramiko
        scapy
        #httpx
        #pycurl
        cryptography
        pycrypto
        pycryptodome
        #pynacl
        #impacket
        #python-nmap
        #pwntools
        beautifulsoup4
        # REMINDER: pip2nix for any non-existing pip package in the official repo
        # devenv is also pretty useful
      ]))
        
      lua
      luau

      dotnet-sdk
      dotnet-repl

      gcc
      #libgcc
      clang-tools
      clang
      gdb
      pwndbg
      ghidra-bin
      pipx
      tealdeer
      gnumake
      cmake
      pkg-config
      stdman

      linuxKernel.packages.linux_6_6.perf
      hotspot
      heaptrack
      valgrind
      uasm
      nasm
      yasm

      tor-browser-bundle-bin
      obfs4

      monero-gui
      monero-cli
    ];
    shell = pkgs.zsh;
    initialPassword = "pw123";
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
    };
    users."aleksic" = ../../../home/aleksic/galahad.nix;
  };
}
