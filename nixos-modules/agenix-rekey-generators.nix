{ lib, ... }:
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

    syncthing-keypair =
      {
        pkgs,
        lib,
        file,
        ...
      }:
      ''
        tmp=$(mktemp -d)
        '${lib.getExe pkgs.syncthing}' generate --home="$tmp"

        cat "$tmp/cert.pem" > ${lib.escapeShellArg (lib.removeSuffix ".age" file + "-public.pem")}
        '${lib.getExe pkgs.xmlstarlet}' sel -T -t -v '(//configuration/device)[1]/@id' "$tmp/config.xml" > ${
          lib.escapeShellArg (lib.removeSuffix ".age" file + "-id")
        }
        cat "$tmp/key.pem"
      '';

    netbird-datastore-encryption-key =
      { pkgs, lib, ... }: "'${lib.getExe pkgs.openssl}' rand -base64 32";
  }
  // (lib.pipe
    [
      "google" # Generate Google-style app passwords e.g, ofgl ruwd ngzs iphh
      "iphone" # Generate passwords that are easy to enter on the default iPhone keyboard
      "android" # Generate passwords that are easy to enter on the default Android keyboard
      "pin4" # Generate a random 4-digit pin
      "pin6" # Generate a random 6-digit pin
      "mac" # Generate a random mac address
      "banking" # Generate a random password suitable for protecting bank accounts.
      "strong" # Generate a strong password
      "ridiculous" # Generate a ridiculous password
      "ludicrous" # Generate a ludicrously strong password
      "painful" # Really? Wow.
    ]
    [
      (map (
        type:
        lib.nameValuePair "${type}-password" (
          { pkgs, lib, ... }: "'${lib.getExe pkgs.pwgen-secure}' strong"
        )
      ))
      lib.listToAttrs
    ]
  );
}
