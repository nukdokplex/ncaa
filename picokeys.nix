{
  inputs,
  lib,
  withSystem,
  ...
}:
let
  system = "x86_64-linux"; # this is the only system picokeys-nix support
in
{
  flake.package.${system} = withSystem system (
    { pkgs, system, ... }:
    let
      picokeys-pkgs = inputs.picokeys-nix.packages.${system};
    in
    {
      pico-fido-eddsa = picokeys-pkgs.pico-fido.override {
        picoBoard = "waveshare_rp2350_one";
        vidPid = "Yubikey5";
        eddsaSupport = true;
      };
      pico-openpgp-eddsa = picokeys-pkgs.pico-openpgp.override {
        picoBoard = "waveshare_rp2350_one";
        vidPid = "Yubikey5";
        eddsaSupport = true;
      };
    }
  );
}
