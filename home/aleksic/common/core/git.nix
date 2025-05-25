{pkgs, ...}: {
  home.packages = with pkgs; [
    git
  ];
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "kripticni";
    userEmail = "kripticno@gmail.com";
    extraConfig = {
      pull = {rebase = false;};
    };
  };
}
