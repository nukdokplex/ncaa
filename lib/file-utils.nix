# thx for this functions to voronind 
{ lib }:
{
  # Remove tabs indentation,
  trimTabs =
    text:
    let
      shouldStripTab = lines: builtins.all (line: (line == "") || (lib.strings.hasPrefix "	" line)) lines;
      stripTab = lines: builtins.map (line: lib.strings.removePrefix "	" line) lines;
      stripTabs = lines: if (shouldStripTab lines) then (stripTabs (stripTab lines)) else lines;
    in
    builtins.concatStringsSep "\n" (stripTabs (lib.strings.splitString "\n" text));

  # List all files in a dir.
  ls =
    path:
    map (f: "${path}/${f}") (
      builtins.filter (i: builtins.readFileType "${path}/${i}" == "regular") (
        builtins.attrNames (builtins.readDir path)
      )
    );

  # Concat all nix file content by `file` key.
  catFile =
    files: args:
    lib.foldl' (acc: mod: acc + (builtins.readFile (import mod args).file) + "\n") "" files;

  # Concat all nix files as a set.
  catSet =
    files: args:
    builtins.foldl' (acc: mod: lib.recursiveUpdate acc mod) { } (map (file: import file args) files);

  # Concat all file contents.
  readFiles = files: builtins.foldl' (acc: mod: acc + (builtins.readFile mod) + "\n") "" files;
}

