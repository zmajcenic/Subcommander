; rutina za dijeljenje sa 10
; ulaz u A
; izlaz B=desetke, A= ostatak
DIVIDE10:
	LD	B, 0
DIVIDE10_L1:
	CP	10
	RET	C
	INC	B
	SUB	10
	JR	DIVIDE10_L1

; rutina za izracun modulo
; A = orig broj
; C = modulo
MODULO8BIT:
	CP	C
	RET	C
	SUB	C
	JR	MODULO8BIT

; rutina za dijeljenje sa 60
; ulaz HL
; izlaz A=minute, L=sekunde
DIVIDE60:
	XOR	A
	LD	DE, 60
DIVIDE60_L1:
	SCF
	CCF
	SBC	HL, DE
	JR	C, DIVIDE60_L2
	INC	A
	JR	DIVIDE60_L1
DIVIDE60_L2:
	ADD	HL, DE
	RET

; rutina za 16 bitno dijeljenje
; HL = broj koji dijelimo
; DE = sa cime dijelimo
; BC = rezultat
DIVIDE16BIT:
	LD	BC, 0
DIVIDE16BIT_L1:
	XOR	A
	SBC	HL, DE
	JR	C, DIVIDE16BIT_L2
	INC	BC
	JR	DIVIDE16BIT_L1
DIVIDE16BIT_L2:
	ADD	HL, DE
	RET
