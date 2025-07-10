{
  config,
  lib,
  pkgs,
  ...
}:
let
  tld = "nukdokplex.ru";
in
{
  services.ddclient = {
    enable = true;
    interval = "10min";
    protocol = "dyndns2";
    ssl = true;
    server = "update.dedyn.io"; # deSEC

    usev4 = lib.mkDefault "cmdv4, cmdv4=\"'${lib.getExe pkgs.curl}' https://checkipv4.dedyn.io/\"";
    # usev6 = "cmdv6, cmdv6=\"'${lib.getExe pkgs.curl}' https://checkipv6.dedyn.io/\"";
    usev6 = lib.mkDefault "cmdv6, cmdv6=\"'${lib.getExe pkgs.getv6addresses}' -p -e -x | tr '\\n' ',' | sed 's/,*$//'\"";

    username = tld;
    passwordFile = config.age.secrets.desec.path;
    domains = [ "${config.networking.hostName}.${tld}" ];
  };

  age.secrets.desec = { };
}
