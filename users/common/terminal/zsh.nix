{ configs, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh
    oh-my-posh
  ];

  programs.zsh = {
    enable = true;
    autocd = true;

    defaultKeymap = "viins";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      ls = "ls --color=auto";
      dir = "dir --color=auto";
      vdir = "vdir --color=auto";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      diff = "diff --color=auto";
      ip = "ip --color=auto";
    };

    history = {
      size = 10000;
      path = "$HOME/.config/zsh/history";
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    useTheme = "amro";
  };
}
