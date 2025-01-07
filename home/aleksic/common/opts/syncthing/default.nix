{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.syncthing ];
  systemd.user.services.syncthing.serviceConfig.wantedBy = lib.mkForce [ ];
  services.syncthing = {
    enable = true;

    settings = {
      gui.theme = "black";
      options = {
        urAccepted = -1;
      };
    };
  };
}
