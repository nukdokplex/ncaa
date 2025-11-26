{ ezModules, ... }:
{
  imports = with ezModules; [
    via
    k3b-custom
    xray
  ];
}
