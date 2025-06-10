{ lib, ... }:
{
  reverseString = str: lib.concatStrings (lib.reverseList (lib.stringToCharacters str));
  capitalizeString =
    str:
    (lib.toUpper (builtins.substring 0 1 str))
    + (lib.toLower (builtins.substring 1 ((builtins.stringLength str) - 1) str));
}
