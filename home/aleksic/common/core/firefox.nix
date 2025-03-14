{ pkgs, ... }:
{
  home.packages = with pkgs; [
    firefox-esr
  ];

  programs.firefox = {
    enable = true;
    profiles.default.isDefault = false;
  };
}
