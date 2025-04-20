function sound_output_cycle() {
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

function sound_output_toggle() {
  local state=$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d\  -f2)
  if [ "${state}" = "yes" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ 0
	 notify_sound single-click
  else
    notify_sound double-click
    pactl set-sink-mute @DEFAULT_SINK@ 1
  fi
}

function sound_input_toggle() {
  local state=$(pactl get-source-mute @DEFAULT_SOURCE@ | cut -d\  -f2)
  if [ "${state}" = "yes" ]; then
    notify_sound single-click
    pactl set-source-mute @DEFAULT_SOURCE@ 0
  else
    notify_sound double-click
    pactl set-source-mute @DEFAULT_SOURCE@ 1
  fi
}

