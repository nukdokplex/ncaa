{ lib, final, ... }:
let
  directionKeys = lib.fix (keys: {
    # up right down left
    direction = [
      "up"
      "right"
      "down"
      "left"
    ];
    wasd = [
      "w"
      "d"
      "s"
      "a"
    ];
    hjkl = [
      "k"
      "l"
      "j"
      "h"
    ];
    resizeVector = [
      {
        x = 0;
        y = 1;
      }
      {
        x = 1;
        y = 0;
      }
      {
        x = 0;
        y = -1;
      }
      {
        x = -1;
        y = 0;
      }
    ];
    xkbNoPrefix = {
      arrow = map (key: "${key}arrow") keys.direction;
      wasd = map (key: lib.toUpper key) keys.wasd;
      hjkl = map (key: lib.toUpper key) keys.hjkl;
    };
    xkb = builtins.mapAttrs (
      name: value: builtins.map (elem: "XKB_KEY_${elem}") value
    ) keys.xkbNoPrefix;
  });

  numberKeys = lib.fix (keys: {
    number = builtins.genList (x: x + 1) 10;
    digit = builtins.map (
      x:
      let
        str = builtins.toString x;
      in
      builtins.substring ((builtins.stringLength str) - 1) 1 str
    ) keys.number;
    xkbNoPrefix = {
      digit = keys.digit;
      keypadDigit = map (key: "KP_${key}") keys.digit;
      keypadFunction = map (key: "KP_${key}") [
        "End"
        "Down"
        "Next"
        "Left"
        "Begin"
        "Right"
        "Home"
        "Up"
        "Prior"
        "Insert"
      ];
    };
    xkb = builtins.mapAttrs (
      name: value: builtins.map (elem: "XKB_KEY_${elem}") value
    ) keys.xkbNoPrefix;
  });

  genParams =
    params: count:
    let
      attrsList = lib.mapAttrsRecursive (path: value: { inherit path value; }) params;
    in
    builtins.genList (
      i:
      builtins.foldl' (
        acc: elem: lib.recursiveUpdate acc (lib.setAttrByPath elem.path (builtins.elemAt elem.value i))
      ) { } attrsList
    ) count;
in
{
  keyboard.withDirections =
    f: builtins.map (e: f e) (genParams directionKeys (builtins.length directionKeys.direction));

  keyboard.withNumbers =
    f: builtins.map (e: f e) (genParams numberKeys (builtins.length numberKeys.digits));

  inherit (final.keyboard) withDirections withNumbers;
}
