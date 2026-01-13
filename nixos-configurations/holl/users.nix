{
  config,
  lib,
  pkgs,
  ...
}:
{
  users = {
    groups = {
      torrent.gid = 901;
      music.gid = 902;
      documents.gid = 903;
      pictures.gid = 904;
      movies.gid = 905;
      shows.gid = 906;
    };

    users.nukdokplex.extraGroups = [
      "torrent"
      "music"
      "documents"
      "pictures"
      "movies"
      "shows"
    ];
  };

  system.activationScripts.samba_user_create = ''
    password=$(cat "${config.age.secrets.nukdokplex-smb-user-password.path}")
    echo -e "$password\n$password\n" | ${lib.getExe' pkgs.samba "smbpasswd"} -a -s nukdokplex
  '';

  age.secrets = {
    nukdokplex-smb-user-password.generator.script = "strong-password";
  };
}
