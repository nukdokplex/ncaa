{
  age.generators.wireguard-priv = {pkgs, lib, file, ...}: let
    wg = "'${lib.getExe pkgs.wireguard-tools}'";
  in ''
    priv=$(${wg} genkey)
    ${wg} pubkey <<< "$priv" > ${lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")}
    echo "$priv"
  '';
}
