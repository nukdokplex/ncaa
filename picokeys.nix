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
      pico-fido = picokeys-pkgs.pico-fido.override {
        picoBoard = "waveshare_rp2350_one";
        vidPid = "Yubikey5";
        delayedBoot = true;
        eddsaSupport = true;
        generateOtpFile = true;
      };
      pico-openpgp = picokeys-pkgs.pico-openpgp.override {
        picoBoard = "waveshare_rp2350_one";
        vidPid = "Yubikey5";
        delayedBoot = true;
        eddsaSupport = true;
        generateOtpFile = true;
      };
      pico-fido2 = picokeys-pkgs.pico-fido2.override {
        picoBoard = "waveshare_rp2350_one";
        vidPid = "Yubikey5";
        delayedBoot = true;
        eddsaSupport = true;
        generateOtpFile = true;
      };
      pico-nuke = picokeys-pkgs.pico-nuke.override {
        picoBoard = "waveshare_rp2350_one";
        generateOtpFile = true;
      };
    }
  );
}
