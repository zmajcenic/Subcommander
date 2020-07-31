; rutine za rad sa Sony HBI-55 Data Cartridge / Yamaha UDC-01 Data Memory
; 4kb, iskoristivo 1-4095
; lokacija 0 je uvijek &53

; rutina za citanje
; HL = adresa
; vraca A
; adresa se ne uvecava automatski kao u VRAM-u
HBI55_READ:
	LD	A, &89
	OUT	(&B3), A
	LD	A, L
	OUT	(&B0), A
	LD	A, H
	OR	&C0
	OUT	(&B1), A
	IN	A, (&B2)
	RET

; rutina za pisanje
; HL = adresa
; C = vrijednost za upis
; adresa se ne uvecava automatski kao u VRAM-u
HBI55_WRITE:
	LD	A, &80
	OUT	(&B3), A
	LD	A, L
	OUT	(&B0), A
	LD	A, H
	OR	&40
	OUT	(&B1), A
	LD	A, C
	OUT	(&B2), A
	RET	