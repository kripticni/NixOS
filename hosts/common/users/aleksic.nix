{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
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

      hashid
      hash-identifier
      aria2
      curl
      wget
      p7zip
      zip
      unzip
      lzip
      lz4
      lzop
      gnutar
      file
      bc

      util-linux
      sharutils
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
      zsteg
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

      pandoc
      texliveSmall

      sqlite
      postgresql

      nodejs_23
      zulu

      octaveFull
      conda
      (python312.withPackages (python312Packages:
        with python312Packages; [
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
          pwntools
          beautifulsoup4
          pillow
          # REMINDER: pip2nix for any non-existing pip package in the official repo
          # devenv is also pretty useful
        ]))

      lua
      luau

      #jetbrains.rider # flatpaked
      dotnet-sdk_9
      dotnet-repl

      gcc
      #libgcc
      clang-tools
      clang
      gdb
      #gef # commented out for ghidra.gdb
      #pwndbg
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

  programs.ghidra = {
    enable = true;
    package = pkgs.ghidra-bin;
    gdb = true;
  };

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
    };
    users."aleksic" = ../../../home/aleksic/galahad.nix;
  };
}
