{ ... }:
{
  services.kmonad = {
    enable = true;
    keyboards = {
      builtin = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        enableHardening = true;
        defcfg = {
          enable = true;
          fallthrough = false;
          allowCommands = false;
        };
        config = builtins.readFile ./builtin.kbd;
      };
    };
  };
}
