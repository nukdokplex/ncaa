{
  lib,
  writeShellApplication,
  coreutils,
  iproute2,
  gawk,
  grepcidr,
  sipcalc,
  ...
}:
{
  getv6addresses = writeShellApplication {
    name = "getv6addresses";

    runtimeInputs = [
      coreutils
      gawk
      iproute2
      grepcidr
      sipcalc
    ];

    text = builtins.readFile ./getv6addresses.sh;

    meta = {
      description = "Script that outputs all IPv6 addresses in the system and filter them";
      homepage = "https://github.com/nukdokplex/ncaa";
      license = lib.singleton lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
    };
  };
}
