{ self, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    colorscheme = "nord";
    colorschemes.nord.enable = true;
    defaultEditor = true;

    opts = {
      autoindent = true;
      cursorline = true;
      expandtab = true;
      wrap = false;
      relativenumber = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;

      backup = false;
      writebackup = false;
      swapfile = false;
      undofile = false;

      ignorecase = true;
      smartcase = true;
    };

    performance = {
      byteCompileLua.enable = true;
      combinePlugins.enable = false;
    };

    extraPackages = with pkgs; [
      clang-tools
      nixfmt-rfc-style
      shfmt
      black
      isort
      stylua
      rustfmt
    ];

    plugins = {
      lualine.enable = true;
      oil.enable = true;
      nvim-tree.enable = true;
      neo-tree.enable = true;
      clangd-extensions.enable = true;
      cmake-tools.enable = true;
      # obsidian.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
      nix.enable = true;
      which-key.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          lua
          python
          rust
          nix
          c
          nasm
          asm
          regex
        ];
        nixGrammars = true;
        settings.highlight.enable = true;
        settings.indent.enable = true;
      };
      harpoon = {
        enable = true;
        enableTelescope = true;
      };
      alpha = {
        enable = true;
        theme = "startify";
      };
    };

    plugins.lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        bashls.enable = true;
        lua_ls.enable = true;
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
        pylsp.enable = true;
      };
    };

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };

    plugins.conform-nvim = {
      enable = true;

      settings = {
        formatters_by_ft = {
          "_" = [ "trim_whitespace" ];
          c = [ "clang-format" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          python = [
            "isort"
            "black"
          ];
          rust = [ "rustfmt" ];
          sh = [ "shfmt" ];
        };

        format_on_save = ''
          function(bufnr)
            local ignore_filetypes = { "helm" }
            if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
              return
            end

            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            -- Disable autoformat for files in a certain path
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("/node_modules/") then
              return
            end
            return { timeout_ms = 1000, lsp_fallback = true }
          end
        '';
      };
    };

  };
}
