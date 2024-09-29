{ config, lib, pkgs, inputs, ... }:

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
    packages = with pkgs; [ brave vim git curl wget alacritty ];
    shell = pkgs.zsh;
    initialPassword = "pw123";
  };
}
