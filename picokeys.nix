{
  inputs,
  lib,
  withSystem,
  flakeRoot,
  ...
}:
let
  system = "x86_64-linux"; # this is the only system picokeys-nix support
in
{
  flake.packages.${system} = withSystem system (
    { pkgs, system, ... }:
    let
      picokeys-pkgs = inputs.picokeys-nix.packages.${system};
    in
    {
      pico-fido =
        (picokeys-pkgs.pico-fido.overrideAttrs (
          final: prev: {
            cmakeFlags = lib.concatLists [
              prev.cmakeFlags
              # (lib.singleton (lib.cmakeBool "ENABLE_DELAYED_BOOT" true))
            ];
          }
        )).override
          {
            picoBoard = "waveshare_rp2350_one";
            vidPid = "Yubikey5";
            eddsaSupport = true;
            generateOtpFile = true;
            secureBootKey = builtins.toString (flakeRoot + /secrets/pico/sb_private.pem);
          };
    }
  );
}
