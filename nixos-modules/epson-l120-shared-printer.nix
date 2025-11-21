{ lib, ... }:
{
  hardware.printers.ensurePrinters = lib.singleton {
    name = "EPSON_L120_Series";
    location = "Home";
    deviceUri = "ipp://holl.ndp.local:631/printers/EPSON_L120_Series";
    model = "epson-inkjet-printer-201207w/ppds/EPSON_L110.ppd";
  };
}
