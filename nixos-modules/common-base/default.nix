{
  inputs,
  ezModules,
  lib',
  ...
}:
{
  imports =
    [ ]
    ++ lib'.umport {
      path = ./modules;
      recursive = false;
    };
}
