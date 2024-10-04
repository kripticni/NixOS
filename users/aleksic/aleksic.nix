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
      brave
      vim
      git
      curl
      wget
      alacritty
      efibootmgr
      tree
    ];
    shell = pkgs.zsh;
    initialPassword = "pw123";
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users."aleksic" = import ./home.nix;
  };
}
