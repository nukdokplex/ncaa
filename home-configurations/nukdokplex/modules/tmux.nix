{
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 30000;
    newSession = true;
    shortcut = "[";
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = ''
      # -n is stands for -T root which means not in prefix table

      # Reload configuration
      bind -n M-r source-file ~/.config/tmux/tmux.conf

      # Copy
      set -s set-clipboard on
      bind -n M-v copy-mode
      bind -n M-p choose-buffer
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
    '';
  };
}
