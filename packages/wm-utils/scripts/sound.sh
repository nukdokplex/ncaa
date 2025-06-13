function wp_get_id() {
  wpctl inspect "$1" | head --lines 1 | awk -F ', ' '{print $1}' | awk '{print $2}'
}

function pw_get_mute_state() {
  local id
  local result

  id="$1"
  result=$(pw-dump | jq -r ".[] | select(.id==$id) | .info.params.Props | map(select(has(\"mute\")))[0] | .mute")

  [ "$result" = "false" ] || [ "$result" = "true" ] || return 1

  echo -ne "$result"
  return 0
}

function toggle_sound_mute() {
  # supposed to use @DEFAULT_SINK@ or @DEFAULT_INPUT@ in $1
  local id
  local state

  id=$(wp_get_id "$1")
  echo "got $1 id - $id" 1>&2

  {
    state=$(pw_get_mute_state "$id") 
  } || {
    echo "got error while trying to get mute state, toggling without sound notification..." 1>&2
    wpctl set-mute "$1" toggle
    return 1
  }

  case "$state" in
    true)
      echo "unmuting..." 1>&2
      wpctl set-mute "$id" 0
      if [[ -v NONBLOCKING_NOTIFY ]] && [[ "$NONBLOCKING_NOTIFY" == "true" ]]; then
        notify_sound device-added &
      else
        notify_sound device-added
      fi
      return 0 ;;
    false)
      echo "muting..." 1>&2
      if [[ -v NONBLOCKING_NOTIFY ]] && [[ "$NONBLOCKING_NOTIFY" == "true" ]]; then
        notify_sound device-removed &
      else
        notify_sound device-removed
      fi
      wpctl set-mute "$id" 1
      return 0 ;;
    *)
      echo "unexpected mute state, toggling without sound notification..." 1>&2
      wpctl set-mute "$1" toggle
      return 1 
  esac
}
