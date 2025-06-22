{ pkgs, inputs, ... }:
{
  services.printing.drivers = [ pkgs.epson_201310w ];

  hardware.printers.ensurePrinters = [
    {
      name = "Epson_L120_Series";
      location = "Home";
      deviceUri = "socket://192.168.1.11:9101";
      model = "EPSON_L120.ppd";
    }
  ];
}
