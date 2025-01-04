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
      util-linux
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

      mount
      mount-zip
      squashfuse
      fuse
      jmtpfs
      brightnessctl

      exiftool
      mdbtools

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

      octaveFull
      conda
      python3Full
      lua
      luau

      gcc
      #libgcc
      clang-tools
      clang
      gdb
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
