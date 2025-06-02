function notify_sound() {
  sound_file=$(find "$SOUNDS" -name "$1.*" -print -quit)
  pw-cat -p --media-role event "$sound_file"
}
