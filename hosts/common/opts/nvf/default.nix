{ pkgs,
  lib,
  config,
  options,
  ...
}:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "base16";
          style = "dark";
          transparent = false;
          base16-colors = {
            base00 = "#2e3440"; #background, fixed
            base01 = "#3b4252"; #lualine and completes
            base02 = "#434c5e"; #secondary lualine
            base03 = "#a3be8c"; #comments color and warning code text color
            base04 = "#8fbcbb"; #line number and sugesstion class
            base05 = "#d8dee9"; #braces, variables and main for nix, braces bg
            base06 = "#bf616a"; #???
            base07 = "#bf616a"; #???
            base08 = "#a6ccda"; #namespaces, class with member function, command color of lualine
            #^ custom with hexcolorblender and error color
            base09 = "#b48ead"; #all constants
            base0A = "#81a1c1"; #classes and lvalue variables and comparasings
            base0B = "#a3be8c"; #included libraries and strings in nix
            base0C = "#b48ead"; #strings in cpp
            base0D = "#88c0d0"; #includes and functions and function calls
            base0E = "#5e81ac"; #keywords and warnings
            base0F = "#88c0d0"; #colons neotree
          };
        };
        options = {
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
        };

        extraPackages = with pkgs; [
          fzf
          ripgrep
        ];

        disableArrows = true;
        hideSearchHighlight = true;
        enableLuaLoader = true;

        dashboard.dashboard-nvim = {
          enable = true;
        };

        mini.statusline.enable = true;
        statusline.lualine = {
          enable = false;
          theme = "nord";
        };
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        filetree.neo-tree.enable = true;

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
            format.enable = true;
          };

          nix.enable = true;
          bash.enable = true;
          csharp.enable = true;
          clang.enable = true;
          # vim.languages.clang.cHeader
          assembly.enable = true;

          python.enable = true;
          lua.enable = true;

          ts.enable = true;
          php.enable = true;
          css.enable = true;
          html.enable = true;

          sql.enable = true;
        };

      };
    };
  };

}
