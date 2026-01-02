{
  writeShellApplication,
  lib,
  coreutils,
  ...
}:
writeShellApplication {
  name = "has-file-in-tree";
  text = builtins.readFile ./has-file-in-tree.sh;
  runtimeInputs = [ coreutils ];
  meta = {
    homepage = "https://github.com/nukdokplex/ncaa";
    description = "Simple script to determine if specified file exist in any parent dir of specified path.";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nukdokplex ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
