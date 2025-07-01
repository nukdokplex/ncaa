#!/bin/sh

file=$(mktemp)

lang=$1

eval "tts_model=\${tts_model_$lang}"
eval "tts_config=\${tts_config_$lang}"

# piper will consume stdin now
piper \
  --model "${tts_model:?}" \
  --config "${tts_config:?}" \
  --output_file "$file" 

pw-cat \
  --playback \
  --media-type Audio \
  --media-category Playback \
  --media-role Accessibility \
  "$file"

rm "$file"
