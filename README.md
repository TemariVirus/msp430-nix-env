# msp430-nix-env

Nix development environment for MSP430 Microcontrollers.

## Enter the environtment

```sh
nix develop
```

Basically what you'd expect.

## Example

There is a minimal example that blinks the LEDs on an MSP430F5529.

Check [example/README.md](example/README.md) for more details.

## Udev rules

You need to add some udev rules so that mspdebug can access the device.

On NixOS systems, you can copy `msp430-udev.nix` and import it into your `configuration.nix`:

```nix
{
  imports = [
    ./msp430-udev.nix
  ];
}
```

On non-NixOS systems, create `/etc/udev/rules.d/61-msp430uif.rules` and add the following lines:

```plain
#TI MSP430UIF
ATTRS{idVendor}=="2047",ATTRS{idProduct}=="0010",MODE="0666"
ATTRS{idVendor}=="2047",ATTRS{idProduct}=="0013",MODE="0666"
ATTRS{idVendor}=="2047",ATTRS{idProduct}=="0203",MODE="0666"
```
