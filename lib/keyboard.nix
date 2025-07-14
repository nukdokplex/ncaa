{ lib, ... }:
let
  directionKeys = lib.fix (keys: {
    # up right down left
    _count = builtins.length keys.direction;
    direction = [
      "up"
      "right"
      "down"
      "left"
    ];
    relativeDirection = [
      "top"
      "right"
      "bottom"
      "left"
    ];
    hyprland.direction = builtins.map (key: builtins.substring 0 1 key) keys.direction;

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
    swayResize = [
      "resize shrink height"
      "resize grow width"
      "resize grow height"
      "resize shrink width"
    ];
    resize = [
      "shrink height"
      "grow width"
      "grow height"
      "shrink width"
    ];

    tmux = {
      argument = map (d: "-${lib.toUpper (lib.substring 0 1 d)}") keys.direction;
      paneToken = map (d: "{${d}}") keys.relativeDirection;
      relativePaneToken = map (d: "{${d}-of}") keys.direction;
    };
    xkbNoPrefix = {
      arrow = map (key: "${lib.capitalizeString key}") keys.direction;
      wasd = map (key: lib.toUpper key) keys.wasd;
      hjkl = map (key: lib.toUpper key) keys.hjkl;
    };
    xkb = builtins.mapAttrs (_: value: map (elem: "XKB_KEY_${elem}") value) keys.xkbNoPrefix;
  });

  numberKeys = lib.fix (keys: {
    _count = builtins.length keys.number;
    number = builtins.genList (x: x + 1) 10;
    digit = builtins.map (
      x:
      let
        str = builtins.toString x;
      in
      builtins.substring ((builtins.stringLength str) - 1) 1 str
    ) keys.number;
    shiftedDigit = [
      "!"
      "@"
      "#"
      "$"
      "%"
      "^"
      "&"
      "*"
      "("
      ")"
    ];
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
    xkb = builtins.mapAttrs (_: value: builtins.map (elem: "XKB_KEY_${elem}") value) keys.xkbNoPrefix;
  });

  genParams =
    params:
    builtins.genList (
      i:
      lib.mapAttrsRecursive (_: value: if lib.isList value then builtins.elemAt value i else value) params
    ) params._count;
in
{
  withDirections = f: builtins.map (e: f e) (genParams directionKeys);

  withNumbers = f: builtins.map (e: f e) (genParams numberKeys);
}
