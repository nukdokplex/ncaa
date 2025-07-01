function tts {
  local lang=$1
  screenshot_file=$(mktemp)
  grim -l 0 -t png -g "$(slurp)" "$screenshot_file"
  notify_sound camera-shutter &
  tesseract "$screenshot_file" - -l eng+rus | tts-custom "$lang"
  rm "$screenshot_file"
}
