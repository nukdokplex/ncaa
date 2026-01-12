_: {
  battery = {
    format = "bat\n{capacity:03d}";
    states = {
      critical = 20;
    };
    tooltip-format = ''
      Capacity: {capacity}%
      {timeTo}
      Draw: {power} watts.'';
  };
}
