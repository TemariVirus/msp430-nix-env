.section .reset, "a"       /* The .reset needs to be alloc, otherwise the flashing tool does not know that this needs to be flashed */
    .word start            /* Address of entry point */

.text
start:
    mov #0x4400, r1        /* Set up stack to end of RAM */
    mov #0x5a80, &0x015c   /* Disable watchdog (WDTCTL = &0x015c, WDTPWD = 0x5a) */
    bis.b #0x01, &0x0204   /* Set P1.0 to output (P1DIR = &0x0204) */
    bis.b #0x80, &0x0225   /* Set P4.7 to output (P4DIR = &0x0225) */
    bis.b #0x01, &0x0202   /* Set P1.0 - (P1OUT = &0x0202) */
    bic.b #0x80, &0x0223   /* Clear P4.7 - (P4OUT = &0x0223) */

loop:
    xor.b #0x01, &0x0202   /* Toggle P1.0 - (P1OUT = &0x0202) */
    xor.b #0x80, &0x0223   /* Toggle P4.7 - (P4OUT = &0x0223) */
    mov #50000, r5         /* Set delay in R5 */

wait:
    sub #1, r5             /* Decrement delay */
    jz loop                /* Restart loop when delay is zero */
    jmp wait               /* Otherwise, continue waiting */
