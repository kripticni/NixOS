{ pkgs, ... }:
{
  services.polybar = {
    enable = false;
    package = pkgs.polybarFull;
    config = ../../sys/polybar/nord.ini;
  };
}
