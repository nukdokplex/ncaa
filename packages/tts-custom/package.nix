{
  lib,
  fetchurl,

  piper-tts,
  pipewire,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "tts-custom";

  text = builtins.readFile ./script.sh;

  runtimeInputs = [
    piper-tts
    pipewire
  ];

  runtimeEnv = {
    tts_model_en = fetchurl {
      url = "https://github.com/dnhkng/GLaDOS/releases/download/0.1/glados.onnx";
      hash = "sha256-F+oW3RjhusNDCQuFiQQrQFLx5UVtQsrYhCpPEQ3iUJU=";
    };
    tts_config_en = fetchurl {
      url = "https://raw.githubusercontent.com/dnhkng/GLaDOS/refs/heads/main/models/TTS/glados.json";
      hash = "sha256-AfXmAuHsBNrsbVSWDk1kG13jBfORhuQL+bSke9dXpIk=";
    };

    tts_model_ru = fetchurl {
      url = "https://huggingface.co/rhasspy/piper-voices/resolve/main/ru/ru_RU/ruslan/medium/ru_RU-ruslan-medium.onnx?download=true";
      sha256 = "0zygipaaxd6b686mh4w6s5iazy11m8fqxn25xdj814i01f7gi9bj";
    };
    tts_config_ru = fetchurl {
      url = "https://huggingface.co/rhasspy/piper-voices/resolve/main/ru/ru_RU/ruslan/medium/ru_RU-ruslan-medium.onnx.json?download=true";
      sha256 = "05w1x1cwldxsajcd1yzvpzf68pk1mvg55d89g38an163gfqlyskh";
    };
  };

  meta = {
    homepage = "https://github.com/nukdokplex/ncaa";
    description = "Simple TTS (Text-to-speech) script using Piper.";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nukdokplex ];
    platforms = lib.platforms.all;
  };
}
