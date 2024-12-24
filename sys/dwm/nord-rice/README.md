my fork of: https://github.com/KawaiiKraken/polybar-dwm

# polybar-dwm - dwm with polybar support*
*patched to work with polybar-dwm-module which you can find here
 https://github.com/mihirlad55/polybar-dwm-module

# Included Patches
- anybar-polybar-tray-fix
- fullgaps
- ipc
- restartsig
- restoreafterrestart
- noborder
- tagshift
- swallow
- anybar-togglebar (custom patch)
- a few minor changes to prevent weird behaviour with polybar

added by kripticni:
- alpha
- always center
- autostart
- cfacts
- focusurgent
- ewmh support
- pertag patch

# Dependencies
------------
- yajl
- polybar-dwm-module
- freetype2
- libxft
- libxinerama
- libx11

Installation
------------
    Non-NixOS:
    make clean install

    NixOS in configuration.nix:
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.yajl ];
        src = ./relative-path-to-dwm-dir;
      });
    };

Running dwm
-----------
Non-NixOS:
Add the following line to your .xinitrc to start dwm using startx:

    exec dwm

In order to connect dwm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

    DISPLAY=foo.bar:1 exec dwm

(This will start dwm on display :1 of the host foo.bar.)
OR
use xrandr --output in .xinitrc (might not work in all display configs)

NixOS in configuration.nix:
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "none+dwm";
  };




Running polybar
-----------
ADD NOTHING TO XINITRC
polybar will run with dwm via bar.sh, if your bar is configured differently you can change it there

Configuration
-------------
- The configuration of dwm is done by editing config.h and running make install again.
- polybar-dwm-module is configured in .config/polybar/config
