{ pkgs, ... }:
{
  services.printing.drivers = [ pkgs.epson_201310w ];

  hardware.printers.ensurePrinters = [
    {
      name = "Epson_L120_Series";
      location = "Home";
      deviceUri = "usb://EPSON/L120%20Series?serial=544E594B3132383744";
      model = "EPSON_L120.ppd";
    }
  ];
}
