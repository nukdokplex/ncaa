# thx to voronind for this functions
function sound_output_cycle() {
  # TODO: REWRITE, it doesn't work
  local IFS=$'\n'
  local current=$(pactl get-default-sink)
  local all=($(pactl list short sinks | cut -f2))
  local i_current=$(_index_of ${current} ${all[@]})
  local i_total=${#all[@]}
  ((i_total--))
  local i_target=0

  [[ ${i_current} -lt ${i_total} ]] && i_target=$((i_current + 1))

  pactl set-default-sink ${all[${i_target}]}
  notify_sound single-click
}

function sound_input_cycle() {
  # TODO: REWRITE, it doesn't work
  notify_sound single-click
  local IFS=$'\n'
  local current=$(pactl get-default-source)
  local all=($(pactl list short sources | cut -f2 | rg input))
  local i_current=$(_index_of ${current} ${all[@]})
  local i_total=${#all[@]}
  ((i_total--))
  local i_target=0

  [[ ${i_current} -lt ${i_total} ]] && i_target=$((i_current + 1))

  pactl set-default-source ${all[${i_target}]}
}

function wp_get_id() {
  wpctl inspect $1 | head --lines 1 | awk -F ', ' '{print $1}' | awk '{print $2}'
}

function pw_get_mute_state() {
  result=$(pw-dump | '@jq@/bin/jq' -r ".[] | select(.id==$1) | .info.params.Props | map(select(has(\"mute\")))[0] | .mute")
  if [ "$result" = "true" ]; then
    exit 0
  elif [ "$result" = "false" ]; then
    exit 1
  fi
  exit 2
}

function toggle_sound_mute() {
  # supposed to use @DEFAULT_SINK@ or @DEFAULT_INPUT@ in $1
  id=$(wp_get_id $1)
  pw_get_mute_state $id

  if [ $? -eq 0 ]; then
    # it's muted now
    wpctl set-mute $id 0
    notify_sound single-click
    exit 0
  elif [ $? -eq 1 ]; then
    # it's not muted now
    notify_sound double-click
    wpctl set-mute $id 1
    exit 0
  fi

  # main algo didn't worked, fallback to simple toggle
  wpctl set-mute $1 toggle
  exit 1
}
