{ lib, final, ... }:
{
  strings.reverseString = str: lib.concatStrings (lib.reverseList (lib.stringToCharacters str));
  inherit (final.strings) reverseStrings;
}
