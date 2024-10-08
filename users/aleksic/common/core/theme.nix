{ pkgs, lib, ... }:
{
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
    theme.package = lib.mkForce pkgs.nordic;
    theme.name = lib.mkDefault "Nordic";
    iconTheme.package = pkgs.nordzy-icon-theme;
    iconTheme.name = "Nordzy";
  };
}
