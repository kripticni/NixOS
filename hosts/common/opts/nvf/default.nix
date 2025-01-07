{ pkgs, lib, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "nord";
          style = "dark";
        };

        extraPackages = with pkgs; [
          clangd
          fzf
          ripgrep
        ];

        disableArrows = true;
        hideSearchHighlight = true;
        enableLuaLoader = true;

        dashboard.dashboard-nvim = {
          enable = true;

        };
        notes.obsidian.enable = true;
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        filetree.neo-tree.enable = true;

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          markdown.enable = true;

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
