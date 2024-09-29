{
  pkgs,
  username,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
      ];
      shell = pkgs.zsh;
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
	  alacritty
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
          (python312Full.withPackages (ps: [
            ps.pkgconfig
            ps.requests
            ps.pip
          ]))
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
    };
    # "newuser" = {
    #   homeMode = "755";
    #   isNormalUser = true;
    #   description = "New user account";
    #   extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    #   shell = pkgs.bash;
    #   ignoreShellProgramCheck = true;
    #   packages = with pkgs; [];
    # };
  };
  programs.zsh.enable = true;
}
