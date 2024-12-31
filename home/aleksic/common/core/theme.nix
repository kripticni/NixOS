{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    phinger-cursors
    nordzy-icon-theme
    utterly-nord-plasma
  ];

  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    x11.enable = true;
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
  };

  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style.package = pkgs.utterly-nord-plasma;
    style.name = "kvantum";
  };

  gtk = {
    enable = true;
    iconTheme.package = pkgs.nordzy-icon-theme;
    iconTheme.name = "Nordzy";
  };
}
