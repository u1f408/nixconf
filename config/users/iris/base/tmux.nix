{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # terminal overrides
      set-option -g default-terminal 'screen-256color'
      set-option -ga terminal-overrides ',screen-256color:Tc'

      # base index of 1, reassign <Prefix>0 to window 10
      set-option -g base-index 1
      set-window-option -g pane-base-index 1
      unbind-key 0
      bind-key 0 select-window -t 10

      # don't rename windows automatically
      set-option -g allow-rename off

      # set window title
      set-option -g set-titles on

      # make <Prefix>/ enter search mode
      unbind-key '/'
      bind-key '/' copy-mode \; send-key C-s

      # make <Prefix>| split horizontally and <Prefix>- split vertically
      unbind-key '"'
      unbind-key '%'
      bind-key '|' split-window -h -c "#{pane_current_path}"
      bind-key '-' split-window -v -c "#{pane_current_path}"

      # make <Prefix>m toggle mouse
      unbind-key m
      bind-key m set-window-option mouse

      # make <Prefix>m reload the tmux config
      bind-key r source-file ~/.config/tmux/tmux.conf

      # status bar config
      set-option -g status on
      set-option -g status-interval 5
      set-option -g status-position top
      set-option -g status-justify absolute-centre
      set-option -g status-left-length 32
      set-option -g status-right-length 64
      set-option -g status-style 'bg=colour6 fg=colour7 dim'
      set-option -g status-left ' #(echo $USER)@#H [#S] '
      set-option -g status-right ' %a %Y-%m-%d %H:%M %Z '
      set-window-option -g window-status-bell-style 'bg=colour1 fg=colour7 bold'
      set-window-option -g window-status-current-style 'bg=colour2 fg=colour0'
      set-window-option -g window-status-current-format '[#F#I:#W]'
      set-window-option -g window-status-format '#F#I:#W'
    '';
  };
}
