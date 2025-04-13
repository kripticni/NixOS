{
  pkgs,
  lib,
  config,
  options,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        luaConfigPre = ''
          vim.diagnostic.config({virtual_lines = true})
          vim.lsp.inlay_hint.enable(true)
        '';
        theme = {
          enable = true;
          name = "base16";
          style = "dark";
          transparent = false;
          base16-colors = {
            base00 = "#1F2A27"; #background, fixed
            base01 = "#242F2A"; #lualine and completes
            base02 = "#2C3C35"; #secondary lualine
            base03 = "#B0D0D3"; #comments color and warning code text color
            base04 = "#4F8566"; #line number and sugesstion class
            base05 = "#F5F5DC"; #braces, variables and main for nix, braces bg
            base06 = "#212121"; #???
            base07 = "#212121"; #???
            base08 = "#D7C4A1"; #namespaces, arguments, class with member function, command color of lualine
            #custom with hexcolorblender and error color
            base09 = "#C8A2C8"; #all constants
            base0A = "#6C9F7C"; #classes and lvalue, variables, types, searches and comparing
            base0B = "#A1C6EA"; #included libraries and strings in nix
            base0C = "#C8A2C8"; #strings in cpp
            base0D = "#A3BE8C"; #includes and functions and function calls
            base0E = "#2C7A3E"; #keywords and warnings
            base0F = "#A3BE8C"; #colons neotree
          };
        };
        options = {
          #disableArrows = true;
          #hideSearchHighlight = true;
          #enableLuaLoader = true;
          tabstop = 2;
          softtabstop = 2;
          shiftwidth = 2;
        };

        extraPackages = with pkgs; [
          fzf
          ripgrep
        ];

        dashboard.dashboard-nvim = {
          enable = true;
        };

        ui.colorizer = {
          enable = true;
          setupOpts.filetypes = {
            "*" = {};
          };
        };
        mini.statusline.enable = true;
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
            format.enable = false;
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
