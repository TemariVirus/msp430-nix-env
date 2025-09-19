# Example-asm

This is a minimal example that blinks the LEDs on an MSP430F5529.

1. Enter the development environment:

```sh
nix develop
cd example-asm  # If you haven't already
```

2. Build the example:

```sh
chmod +x ./build.sh
./build.sh
```

3. Plug in your MSP430F5529 LaunchPad and run:

```sh
chmod +x ./run.sh
./run.sh
```

mspdebug may not connect properly immediately after plugging in the LaunchPad. Wait a few seconds and try again if it fails.

4. Once mspdebug connects, run:

```plain
(mspdebug) prog blink.bin
(mspdebug) run
```

5. The red (P1.0) and green (P4.7) LEDs should blink alternately!
