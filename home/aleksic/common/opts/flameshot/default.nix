{ pkgs, ... }:
{
  services.flameshot = {
    enable = false;
    settings = {
      General = {
        showStartupLaunchMessage = false;
      };
    };
  };
}
