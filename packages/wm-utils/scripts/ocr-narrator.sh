function ocr_narrator {
  lang=$1
  screenshot_file=$(mktemp)
  grim -l 0 -t png -g "$(slurp)" "$screenshot_file"
  notify_sound camera-shutter &
  case $lang in
    "ru")
      tesseract_lang="rus+eng"
      ;;
    "en")
      tesseract_lang="eng+rus"
      ;;
    *)
      echo "Error: non-supported language!" >&2
      exit 1
      ;;
  esac
  tesseract "$screenshot_file" - -l "${tesseract_lang:?}" | tts-custom "$lang"
  rm "$screenshot_file"
}
