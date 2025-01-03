{ configs, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    oh-my-posh
  ];

  programs.zsh = {
    enable = true;
    autocd = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      rmswp = "find $HOME/NixOS/ -iname '*' | grep '~' | xargs -I {} rm {}";
      ll = "ls -l";
      ls = "ls --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip --color=auto";
      alacritty = "LIBGL_ALWAYS_SOFTWARE=1 alacritty";
    };

    history = {
      size = 10000;
      path = "$XDG_DATA_HOME/zsh/history";
      append = true;
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "amro";
  };
}
