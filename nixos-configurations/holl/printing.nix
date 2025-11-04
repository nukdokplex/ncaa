{ pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ epson_201207w ];

  hardware.printers.ensurePrinters = [
    {
      name = "Epson_L120_Series";
      location = "Home";
      deviceUri = "usb://EPSON/L120%20Series?serial=544E594B3132383744";
      model = "epson-inkjet-printer-201207w/ppds/EPSON_L110.ppd";
      # l110 printer drivers are compatible with l120 drvers just because they are using same filter program. also l110 drivers bring a bit more types of paper available than l120
    }
  ];
}
