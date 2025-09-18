{ pkgs, ... }:
let
  msp430-rules = pkgs.writeTextFile rec {
    # Need this extra tedium because `services.udev.extraRules` sets the priority to 99 instead of 61
    name = "61-msp430uif.rules";
    text = ''
      #TI MSP430UIF
      ATTRS{idVendor}=="2047",ATTRS{idProduct}=="0010",MODE="0666"
      ATTRS{idVendor}=="2047",ATTRS{idProduct}=="0013",MODE="0666"
      ATTRS{idVendor}=="2047",ATTRS{idProduct}=="0203",MODE="0666"
    '';
    destination = "/etc/udev/rules.d/${name}";
  };
in { services.udev.packages = [ msp430-rules ]; }
