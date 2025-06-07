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
      bind r refresh-client
      bind : command-prompt
      bind L clear-history

      # --- GLOBAL OPTIONS ---
      set -sg escape-time 0 # this disables tmux waiting key after pressing escape to make a combo, useful with vim

      # --- SESSIONS ---
      bind e new-session

      # --- WINDOWS ---
      set-window-option -g window-status-current-style fg=magenta
      setw -g monitor-activity on
      set -g visual-activity on
      bind , previous-window
      bind . next-window
      bind n new-window
      bind < swap-window -dt '{previous}'
      bind > swap-window -dt '{next}'
      unbind &
      bind & command-prompt -I "#S" { rename-window "%%" }
      bind v split-window -h
      bind s split-window -v
      bind q kill-window

      # --- PANES ---
      set-window-option -g other-pane-height 25
      set-window-option -g other-pane-width 80
      set-window-option -g display-panes-time 1500
      set -g pane-active-border-style fg=yellow
      set -g pane-border-style fg=cyan

      bind x kill-pane
      bind z next-layout
      bind M-z next-layout
      bind + select-layout main-horizontal
      bind = select-layout main-vertical

      # resize panes
      bind -nr C-M-h resize-pane -L 2
      bind -nr C-M-j resize-pane -D 2
      bind -nr C-M-k resize-pane -U 2
      bind -nr C-M-l resize-pane -R 2
      bind C-M-h send-keys 'C-M-h'
      bind C-M-j send-keys 'C-M-j'
      bind C-M-k send-keys 'C-M-k'
      bind C-M-l send-keys 'C-M-l'

      # move panes
      bind -nr M-H swap-pane -s '{left-of}'
      bind -nr M-J swap-pane -s '{down-of}'
      bind -nr M-K swap-pane -s '{up-of}'
      bind -nr M-L swap-pane -s '{right-of}'
      bind M-H send-keys 'M-h'
      bind M-J send-keys 'M-j'
      bind M-K send-keys 'M-k'
      bind M-L send-keys 'M-l'

      # focus panes
      bind -n 'M-\' run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys 'C-\\') || tmux select-pane -l"
      bind -n M-h run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-h) || tmux select-pane -L"
      bind -n M-j run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-j) || tmux select-pane -D"
      bind -n M-k run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-k) || tmux select-pane -U"
      bind -n M-l run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-l) || tmux select-pane -R"
      bind 'M-\' send-keys 'M-\'
      bind 'M-h' send-keys 'M-h'
      bind 'M-j' send-keys 'M-j'
      bind 'M-k' send-keys 'M-k'
      bind 'M-l' send-keys 'M-l'

      # --- COPY MODE ---

      bind y copy-mode
      bind p paste-buffer
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      unbind -T copy-mode-vi Enter
      bind -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"

      # --- STATUS BAR ---

      set -g status-interval 1
      set -g status-style bg=black
      set -g status-style fg=white
      set -g status-left '#[fg=green]#H #[default]'
      set -g status-right '%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d'
    '';
  };
}
