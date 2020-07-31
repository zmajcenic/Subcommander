ifndef EXPTBL
	EXPTBL	equ	&FCC1
endif
RAMAD0	equ	&F341			; slotid DOS ram page 0
RAMAD1	equ	&F342			; slotid DOS ram page 1
RDSLT	EQU	&C
WRSLT	EQU	&14
ifndef  ENASLT
	ENASLT	EQU	&24
endif

;	ld	a,(EXPTBL+0)
;        ld	(RAMAD0),a
;        ld	(RAMAD1),a		; assume no ram available for page 0 and 1
;	ld	c,000H
;        call	A5E52			; search ram in page 0
;        jr	c,A59C1
;        ld	(RAMAD0),a		; found, set ram slotid page 0
;A59C1	ld	c,040H
;        call	A5E52			; search ram in page 1
;        jr	c,A59CB
;        ld	(RAMAD1),a		; found, set ram slotid page 1


; rutina prepisana iz MSX-DOS-a za nalazenje RAM-a za pojedini page
; ulaz C=hi addr od page-a, 00=&0000, &40=&4000
; izlaz A = ExxxSSPP
; flag C postavljen ako nije nadjen RAM
FIND_RAM:
A5E52:	LD	HL,EXPTBL
        LD	B,4
        XOR	A
J5E58:	AND	3
        OR	(HL)
J5E5B:	PUSH	BC
        PUSH	HL
        LD	H,C
J5E5E:	LD	L,&10
J5E60:	PUSH	AF
        CALL	RDSLT
        CPL
        LD	E,A
        POP	AF
        PUSH	DE
        PUSH	AF
        CALL	WRSLT
        POP	AF
        POP	DE
        PUSH	AF
        PUSH	DE
        CALL	RDSLT
        POP	BC
        LD	B,A
        LD	A,C
        CPL
        LD	E,A
        POP	AF
        PUSH	AF
        PUSH	BC
        CALL	WRSLT
        POP	BC
        LD	A,C
        CP	B
        JR	NZ,J5E9A
        POP	AF
        DEC	L
        JR	NZ,J5E60
        INC	H
        INC	H
        INC	H
        INC	H
        LD	C,A
        LD	A,H
        CP	&40
        JR	Z,J5E96
        CP	&80
        LD	A,C
        JR	NZ,J5E5E
J5E96:	LD	A,C
        POP	HL
        POP	HL
        RET

J5E9A:	POP	AF
        POP	HL
        POP	BC
        AND	A
        JP	P,J5EA7
        ADD	A,4
        CP	&90
        JR	C,J5E5B
J5EA7:	INC	HL
        INC	A
        DJNZ	J5E58
        SCF
        RET

