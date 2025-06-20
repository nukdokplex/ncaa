function screenshot_region() {
  screenshot_file=$(mktemp)
  grim -l 6 -t png -g "$(slurp)" "$screenshot_file"
  notify_sound camera-shutter &
  swappy -f "$screenshot_file"
  rm "$screenshot_file"
}

function screenshot_output() {
  if [ -z "$DESKTOP_SESSION" ]; then
    echo "can't determine your $$DESKTOP_SESSION"
    return 1
  fi

  if [ "$DESKTOP_SESSION" = "sway" ]; then
    active_output=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).output')
  elif [ "$DESKTOP_SESSION" = "hyprland" ]; then
    active_output=$(hyprctl activeworkspace -j | jq -r '.monitor')
  else
    echo "unsupported $$DESKTOP_SESSION=$DESKTOP_SESSION"
    return 1
  fi
  screenshot_file=$(mktemp)
  grim -c -l 5 -t png -o "$active_output" "$screenshot_file"
  notify_sound camera-shutter &
  swappy -f "$screenshot_file" 
}
