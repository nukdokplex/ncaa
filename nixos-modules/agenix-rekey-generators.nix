{
  age.generators = {
    wireguard-priv =
      {
        pkgs,
        lib,
        file,
        ...
      }:
      let
        wg = "'${lib.getExe pkgs.wireguard-tools}'";
      in
      ''
        priv=$(${wg} genkey)
        ${wg} pubkey <<< "$priv" > ${lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")}
        echo "$priv"
      '';

    uuid = { pkgs, lib, ... }: "'${lib.getExe' pkgs.util-linux "uuidgen"}'";

    reality-keypair =
      {
        pkgs,
        lib,
        file,
        ...
      }:
      ''
        keys=$('${lib.getExe pkgs.sing-box}' generate reality-keypair)
        echo "$keys" | '${lib.getExe' pkgs.gawk "awk"}' -F ": " '$1 == "PublicKey" { print $2 }' > ${
          lib.escapeShellArg (lib.removeSuffix ".age" file + ".pub")
        }
        echo "$keys" | '${lib.getExe' pkgs.gawk "awk"}' -F ": " '$1 == "PrivateKey" { print $2 }'
      '';

    reality-short-id = { pkgs, lib, ... }: "'${lib.getExe pkgs.sing-box}' generate rand --hex 8";
  };

}
