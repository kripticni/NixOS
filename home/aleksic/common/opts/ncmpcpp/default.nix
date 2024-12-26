{ pkgs, ... }:
{
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = "~/Music";
  };
}
