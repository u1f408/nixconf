{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      # for nvim-treesitter
      gcc
    ];

    extraConfig = ''
      set nocompatible
      set nobackup

      nnoremap <Leader>n :nohlsearch<CR>
      nnoremap <Leader>t :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

      au ColorScheme * hi Normal ctermbg=None guibg=None
    '';

    plugins = with pkgs.vimPlugins; [
      nvim-base16

      {
        plugin = lualine-nvim;
        config = "lua require('lualine').setup()";
      }

      {
        plugin = nvim-treesitter;
        config = ''
          lua <<EOF
            require'nvim-treesitter.configs'.setup {
              indent = { enable = true },
              highlight = { enable = true },
              ensure_installed = {
                "rust",
                "python",
                "javascript",
                "c",
                "cpp",
                "lua",
                "html",
                "toml",
                "json",
                "jsonc",
                "yaml",
              },
            }
          EOF
        '';
      }

      nvim-treesitter-context
    ];
  };
}
