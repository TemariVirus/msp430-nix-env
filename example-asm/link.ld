/* There are more interrupt vectors, but the user guide states: "Unassigned interrupt vectors can be
 * used for regular program code if necessary." */
MEMORY {
  ROM (rx)     : ORIGIN = 0xC000, LENGTH = 0x3FFE
  VECTORS_RST  : ORIGIN = 0xFFFE, LENGTH = 0x0002
}

SECTIONS
{
  .reset :
  {
    KEEP (*(.reset))
  } > VECTORS_RST

  .text :
  {
    . = ALIGN(2);
    KEEP (*(.init))
    KEEP (*(.text))
  } > ROM
}
