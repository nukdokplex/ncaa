{ lib, ... }:
let
  keySynonims = {
    directions = rec {
      Left = {
        direction = "l";
        resizeVector = { x = -1; y = 0; };
      };
      H = Left;
      Right = {
        direction = "r";
        resizeVector = { x = 1; y = 0; };
      };
      L = Right;
      Up = {
        direction = "u";
        resizeVector = { x = 0; y = -1; };
      };
      K = Up;
      Down = {
        direction = "d";
        resizeVector = { x = 0; y = 1; };
      };
      J = Down;
    };
    numbersNormal = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ];
    numbersNumpad = [ "KP_End" "KP_Down" "KP_Next" "KP_Left" "KP_Begin" "KP_Right" "KP_Home" "KP_Up" "KP_Prior" "KP_Insert" ];
  };
in
{
  generateDirectionBinds = resizeModifier: fn: (lib.attrsets.mapAttrsToList (key: props: (fn { inherit key; inherit (props) direction; resizeX = builtins.toString (props.resizeVector.x * resizeModifier); resizeY = builtins.toString (props.resizeVector.y * resizeModifier); })) keySynonims.directions);
  generateWorkspaceBinds = fn: ((lib.lists.imap1 (i: key: (fn i key)) keySynonims.numbersNormal) ++ (lib.lists.imap1 (i: key: (fn i key)) keySynonims.numbersNumpad));
}
