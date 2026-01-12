{ ... }:
{
  memory = {
    format = "mem:{percentage:03d}";
    interval = 3;
    tooltip-format = ''
      Total: {total:.1f} GiB
      Total swap: {swapTotal:.1f} GiB

      Used: {used:.1f} GiB
      Used swap: {swapUsed:.1f} GiB

      Free: {avail:.1f} GiB
      Free swap: {swapAvail:.1f} GiB'';
  };
}
