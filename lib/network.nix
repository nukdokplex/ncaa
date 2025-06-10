{ lib, ... }:
{
  genEUI64Suffix =
    mac:
    let
      sanitizedMac = builtins.replaceStrings [ ":" "." ] [ "" "" ] (lib.toLower mac);
      resultHextets = [
        (lib.toHexString (builtins.bitXor 512 (lib.fromHexString (builtins.substring 0 4 sanitizedMac))))
        ((builtins.substring 4 2 sanitizedMac) + "ff")
        ("fe" + (builtins.substring 6 2 sanitizedMac))
        (builtins.substring 8 4 sanitizedMac)
      ];
    in
    lib.toLower (builtins.concatStringsSep ":" resultHextets);
}
