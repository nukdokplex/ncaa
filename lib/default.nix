{ lib, ... }:
lib.fix (self: {
  umport = import ./umport.nix { inherit lib; };
  hyprland-utils = import ./hyprland-utils.nix { inherit lib; };
  file-utils = import ./file-utils.nix { inherit lib; };

  reverseString = str: lib.concatStrings (lib.reverseList (lib.stringToCharacters str));

  deobfuscateMail =
    obfuscatedMail:
    builtins.concatStringsSep "@" (
      lib.imap (i: v: (if (lib.mod i 2) == 0 then self.reverseString v else v)) (
        lib.reverseList (lib.splitString "[has]" (lib.replaceStrings [ "_" ] [ "." ] obfuscatedMail))
      )
    );
})
