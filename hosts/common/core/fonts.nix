{
  config,
  libs,
  pkgs,
  inputs,
  ...
}:
{
  fonts.packages = with pkgs; [
    material-icons
    material-symbols
    nerdfonts
    unifont
    unifont_upper
    fira-code-nerdfont
    fira-code
    fira
    hack-font
    roboto-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans
    dejavu_fonts
    meslo-lgs-nf
    font-awesome
  ];

  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  #fonts.fontconfig.enableProfileFonts = true;
}
