let
  sing-box-rand-base64 =
    keyLength:
    { pkgs, lib, ... }:
    "'${lib.getExe pkgs.sing-box}' generate rand --base64 ${builtins.toString keyLength}";
in
{
  age.generators = {
    mail-hashed-password =
      {
        pkgs,
        lib,
        file,
        ...
      }:
      "'${lib.getExe pkgs.pwgen}' -s 32 1 | '${lib.getExe' pkgs.coreutils "tee"}' ${lib.escapeShellArg (lib.removeSuffix ".age" file)} | '${lib.getExe pkgs.mkpasswd}' -sm bcrypt";

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

    sing-box-rand-base64-16 = sing-box-rand-base64 16;
    sing-box-rand-base64-32 = sing-box-rand-base64 32;
  };

}
