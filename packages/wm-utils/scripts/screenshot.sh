function screenshot_region() {
  data=$(grim -l 6 -t png -g "$(slurp)" -)
  notify_sound camera-shutter &
  echo -ne "$data" | swappy -f -
}

function screenshot_output() {
  if [ -z "$DESKTOP_SESSION" ]; then
    echo "can't determine your $$DESKTOP_SESSION"
	 exit 1
  fi

  if [ "$DESKTOP_SESSION" = "sway" ]; then
    active_output=$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true).output')
  elif [ "$DESKTOP_SESSION" = "hyprland" ]; then
    active_output=$(hyprctl activeworkspace -j | jq -r '.monitor')
  else
    echo "unsupported $$DESKTOP_SESSION=$DESKTOP_SESSION"
    exit 1
  fi
  data=$(grim -c -l 5 -t png -o "$active_output" -)

  notify_sound camera-shutter &
  echo -ne "$data" | swappy -f -
}
