#!/bin/bash

# shitty hack
ln -s $MSP_INC/../lib/msp430f5529_symbols.ld .  
msp430-elf-gcc -O0 -g -mmcu=msp430f5529 -o main.elf main.c -I $MSP_INC -T $MSP_INC/../lib/msp430f5529.ld
unlink msp430f5529_symbols.ld
