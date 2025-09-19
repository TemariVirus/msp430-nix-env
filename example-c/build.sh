#!/usr/bin/env bash
set -eu

CHIP="msp430f5529"
msp430-elf-gcc -I $MSP_INC -L $MSP_LIB -T "$CHIP".ld -mmcu="$CHIP" -o main.o -g -O0 main.c
msp430-elf-strip -s -R .MSP430.attributes -R .comment main.o -o main.bin
