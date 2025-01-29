{ lib, ... }:
{
  systemd.services.tor.serviceConfig.wantedBy = lib.mkForce [ ];
  systemd.services.tor.wantedBy = lib.mkForce [ ];
  services.tor = {
    enable = true;
    openFirewall = true;
  };
}
