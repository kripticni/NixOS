{
  config,
  libs,
  pkgs,
  inputs,
  ...
}:
{
  fonts.packages =
    with pkgs;
    [
      material-icons
      material-symbols
      unifont
      unifont_upper
      nerd-fonts.fira-code
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
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  #fonts.fontconfig.enableProfileFonts = true;
}
