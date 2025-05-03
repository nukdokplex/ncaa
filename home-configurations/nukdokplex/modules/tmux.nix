{ config, ... }:
{
  programs.tmux = {
    enable = true;

    prefix = "M-space";
    keyMode = "vi";
    mouse = true;

    clock24 = true;
    historyLimit = 30000;
    newSession = true;
    terminal = "screen-256color";

    extraConfig = ''
      # config reload
      bind-key R source-file ${config.home.homeDirectory}/${
        config.xdg.configFile."tmux/tmux.conf".target
      } \; display-message "tmux configuration reloaded"

      bind : command-prompt
      bind r refresh-client
      bind L clear-history

      bind , previous-window
      bind . next-window
      bind n new-window
      bind enter next-layout
      bind e new-session

      bind v split-window -h
      bind s split-window -v

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind x kill-pane
      bind q kill-window

      # Copy stuff

      ## Setup 'v' to begin selection as in Vim
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      ## bind copy mode
      bind y copy-mode
      bind p paste-buffer

      ## Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      # smart pane switching with awareness of vim splits
      bind -n C-h run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-h) || tmux select-pane -L"
      bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-j) || tmux select-pane -D"
      bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-k) || tmux select-pane -U"
      bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-l) || tmux select-pane -R"
      bind -n 'C-\' run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys 'C-\\') || tmux select-pane -l"
      bind C-l send-keys 'C-l'

      bind C-o rotate-window

      bind + select-layout main-horizontal
      bind = select-layout main-vertical


      set-window-option -g other-pane-height 25
      set-window-option -g other-pane-width 80
      set-window-option -g display-panes-time 1500
      set-window-option -g window-status-current-style fg=magenta

      # Status Bar
      set -g status-interval 1
      set -g status-style bg=black
      set -g status-style fg=white
      set -g status-left '#[fg=green]#H #[default]'
      set -g status-right '%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d'

      set -g pane-active-border-style fg=yellow
      set -g pane-border-style fg=cyan

      # Set window notifications
      setw -g monitor-activity on
      set -g visual-activity on

      # Allow the arrow key to be used immediately after changing windows
      set-option -g repeat-time 0
    '';
  };
}
