{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [
          pkgs.yajl
          pkgs.imlib2
        ];
        src = ../../../../sys/dwm/dwm;
      });
    };
  };
}
