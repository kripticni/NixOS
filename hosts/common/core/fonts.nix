{ config, libs, pkgs, inputs, ... }:
{
  fonts.packages = with pkgs; [
    material-icons
    material-symbols
    nerdfonts
    unifont
    unifont_upper
    fira-code-nerdfont
    fira-code
    roboto-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans
  ];

  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
}
