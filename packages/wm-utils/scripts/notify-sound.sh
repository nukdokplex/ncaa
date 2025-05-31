function notify_sound() {
  pw-cat -p --media-role event "${SOUNDS}/${1}${SOUNDS_EXTENSION}" &
}
