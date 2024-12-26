{ pkgs, ... }:
{
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
