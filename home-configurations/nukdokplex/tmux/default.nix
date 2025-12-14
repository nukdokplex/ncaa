{
  config,
  lib,
  lib',
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    tmux
  ];

  xdg.configFile."tmux/tmux.conf".text = lib.mkBefore (
    let
      tmuxConfigPath = "${config.home.homeDirectory}/${config.xdg.configFile."tmux/tmux.conf".target}";
      paneIsVim = "ps -o state= -o comm= -t \\'#{pane_tty}\\' | grep -iqE '^[^TXZ ]+ +(\\S+/)?g?\\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'";
    in
    ''
      # unbind all keys
      unbind -aT root 
      unbind -aT prefix 
      unbind -aT copy-mode 
      unbind -aT copy-mode-vi
    ''
    + "\n"
    + (builtins.readFile ./standard-binds.conf)
    + "\n"
    + ''
      # --- Server ---
      set -g default-terminal             "screen-256color"

      # --- Controls ---
      set -g mouse                        on
      set -g prefix                       M-Space
      set -g mode-keys                    vi
      set -g status-keys                  vi 
      set -g escape-time                  0 # this disables tmux waiting key after pressing escape to make a combo, useful with vimi

      # --- Windows ---
      set -g base-index                   1 
      set -g renumber-windows             on # renumber windows every time windows change
      set -g monitor-activity             on
      set -g visual-activity              on

      # --- Panes ---
      set -g pane-base-index              1
      set -g pane-border-lines            heavy

      # --- Statusbar ---
      set -g status                       on
      set -g status-interval              1
      set -g status-position              top
      set -g clock-mode-style             24
      set -g status-left                  '#[fg=green]#H #[default]'
      set -g status-right                 '%a%l:%M:%S %p#[default] #[fg=blue]%Y-%m-%d'
      set -g status-style                 fg=white,bg=black
      set -g window-status-current-style  fg=blue,bg=black,bold
      set -g window-status-style          fg=green,bg=black
      set -g window-status-bell-style     fg=red,bg=black,blink,bold
      set -g window-status-activity-style fg=yellow,bg=black,blink,bold

      # --- Custom ---

      # Prefix
      bind -N 'Pass prefix shortcut to application' M-Space send-prefix

      # Misc commands
      bind -N 'Reload tmux configuration' R "source-file '${tmuxConfigPath}' \\\; display-message 'tmux configuration reloaded'"
      bind -N 'Refresh client'            r refresh-client

      bind -N 'Open command prompt'    -n M-: command-prompt
      bind -N 'Open command prompt'       :   command-prompt
      bind -N 'Pass M-: to application'   M-: send-keys M-:

      bind -N 'Create new session'      -n M-n new-session
      bind -N 'Create new session'         n   new-session
      bind -N 'Pass M-n to application'    M-n send-keys M-n

      bind -N 'Select previous layout'  -n "M-{" select-layout -p
      bind -N 'Select next layout'      -n "M-}" select-layout -n
      bind -N 'Pass to M-{ application'    "M-{" send-keys "M-{"
      bind -N 'Pass to M-} application'    "M-}" send-keys "M-}"

      bind -N 'Split window vertically'   -n M-z split-window -v 
      bind -N 'Split window horizontally' -n M-x split-window -h 
      bind -N 'Pass to M-z application'      M-z send-keys M-z
      bind -N 'Pass to M-x application'      M-x send-keys M-x

      bind -N 'Kill window'             -n M-Q kill-window
      bind -N 'Kill pane'               -n M-q kill-pane
      bind -N 'Pass M-Q to application'    M-Q send-keys M-Q
      bind -N 'Pass M-q to application'    M-q send-keys M-q

      bind -N 'Rename window'           -n M-r command-prompt -p "New window name: "  "rename-window '%1'"
      bind -N 'Rename session'          -n M-R command-prompt -p "New session name: " "rename-session '%1'"
      bind -N 'Pass M-r to application'    M-r send-keys M-r
      bind -N 'Pass M-R to application'    M-R send-keys M-R

      bind -N 'Explore tmux tree'            -n M-Escape choose-tree -swZ -Otime
      bind -N 'Pass M-Escape to application'    M-Escape send-keys M-Escape
    ''
    + "\n"
    + builtins.concatStringsSep "\n" (
      lib.flatten (
        lib'.withNumbers (
          {
            number,
            digit,
            shiftedDigit,
            ...
          }:
          let
            numstr = toString number;
          in
          [
            "bind -N 'Focus window ${numstr}'        -n M-${digit}        if-shell 'tmux select-window -t :${numstr}' '' 'new-window -t :${numstr}'"
            "bind -N 'Move pane to window ${numstr}' -n M-${shiftedDigit} if-shell 'tmux join-pane -t :${numstr}'     '' 'new-window -dt :${numstr}; join-pane -t :${numstr}; select-pane -t top-left; kill-pane'"
          ]
        )
      )
    )
    + "\n"
    + builtins.concatStringsSep "\n" (
      lib.flatten (
        lib'.withDirections (
          {
            hjkl,
            tmux,
            resize,
            direction,
            relativeDirection,
            ...
          }:
          let
            HJKL = lib.toUpper hjkl;
          in
          [
            # binds with *vim awareness
            "bind -N 'Focus ${relativeDirection} with *vim awareness' -n  M-${hjkl}   if-shell \"${paneIsVim}\" 'send-keys M-${hjkl}' 'select-pane ${tmux.argument}'"
            "bind -N 'Move pane ${direction} with *vim awareness'     -n  M-${HJKL}   if-shell \"${paneIsVim}\" 'send-keys M-${HJKL}' 'swap-pane -s \"${tmux.relativePaneToken}\"'"
            "bind -N '${resize} of pane with *vim awareness'          -nr C-M-${hjkl} if-shell \"${paneIsVim}\" 'send-keys C-M-${hjkl}' 'resize-pane ${tmux.argument} 2'"

            # binds to pass to application
            "bind -N 'Pass M-${hjkl} to application'   M-${hjkl}   send-keys M-${hjkl}"
            "bind -N 'Pass M-${HJKL} to application'   M-${HJKL}   send-keys M-${HJKL}"
            "bind -N 'Pass C-M-${hjkl} to application' C-M-${hjkl} send-keys C-M-${hjkl}"

            # binds without *vim awareness
            "bind -N 'Focus ${relativeDirection} pane'    ${hjkl}   select-pane ${tmux.argument}"
            "bind -N 'Move pane ${direction}'             ${HJKL}   swap-pane -s '${tmux.relativePaneToken}'"
            "bind -N '${resize} of pane'               -r C-${hjkl} resize-pane ${tmux.argument} 2"
          ]
        )
      )
    )
    + "\n"
    + ''
      # --- COPY MODE ---
      bind -N 'Enter copy mode' -n M-y copy-mode
      bind -N 'Enter copy mode'    y copy-mode 

      bind -N 'Paste buffer' -n M-p paste-buffer
      bind -N 'Paste buffer'    p paste-buffer

      bind   -T copy-mode-vi v send -X begin-selection
      bind   -T copy-mode-vi y send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      unbind -T copy-mode-vi Enter
      bind   -T copy-mode-vi Enter send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
    ''
  );
}
