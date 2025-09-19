#include <msp430.h>


char morse_code[] = "-.-. .- -. . -.-.--";
void sleep(unsigned volatile int delay) {
	while (delay) {
		delay--;
	}
}

void char_gap() {
	P1OUT = 0x00;
	sleep(0x3333);
}

void dot() {
	P1OUT = 0x01;
	sleep(0x5555);
}

void dash() {
	P1OUT = 0x01;
	sleep(0xaaaa);
}

int main(void) {
	WDTCTL = WDTPW + WDTHOLD;
	P1DIR |= 0x01;
	P1OUT = 0x00;
	while (1) {
		for (int i = 0; i < sizeof(morse_code); i++) {
			char choice = morse_code[i];
			switch (choice) {
				case '-':
					dash();
					break;
				case '.':
					dot();
					break;
				case ' ':
					sleep(0x5555);
					break;
			}
			char_gap();
		}
	}
}
