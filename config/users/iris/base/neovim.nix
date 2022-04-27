{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
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
    ];
  };
}
