; rutina za provjeru i ispis vremena
CHECK_DRAW_TIMER:
	; provjeri da li smo na izlasku iz igre
	LD	A, (GAMETIMER_ENDED)
	OR	A
	RET	NZ

	LD	HL, (LAST_SHOWN_GAME_TIME)
	LD	DE, (SEKUNDE)
	XOR	A
	SBC	HL, DE
	LD	A, L
	OR	H
	RET	Z
	LD	(LAST_SHOWN_GAME_TIME), DE
	
	LD	HL, (GAME_TIME)
	XOR	A
	SBC	HL, DE
	; ovdje imamo preostale sekunde
	; ako je rezultat 0 postavi varijablu GAMETIMER_ENDED, zapamti vrijeme, zaustavi glazbu i pusti sound effekt za kraj igre
	PUSH	HL ; *1 game time
	LD	A, L
	OR	H
	JR	NZ, CHECK_DRAW_TIMER_L0
	; isteklo vrijeme postavi varijablu
	DI
	LD	A, 1
	LD	(GAMETIMER_ENDED), A
	CALL	SOUNDS_PLAYER_STOP
	LD	A, 2
	CALL	SOUNDS_PLAYER_STOP
	CALL	PSG_PLAYER_STOP
        LD	HL, MUSIC_ENDGAME
        XOR	A ;Subsong 0.
        CALL	PSG_PLAYER_INIT
	LD	HL, (JIFFY)
	LD	(GAMETIMER_ENDED_BEGIN_TIME), HL
	EI
CHECK_DRAW_TIMER_L0:
	POP	HL; *1

CHECK_DRAW_TIMER_L1:
	
	CALL	DIVIDE60; A=minute, L=sekunde
	CALL	DIVIDE10; B=deset minuta, A=minuta
	ADD	A, 10
	LD	(TIMER_DISPLAY + 1), A
	LD	A, B
	ADD	A, 10
	LD	(TIMER_DISPLAY), A
	LD	A, L
	CALL	DIVIDE10; B=deset sekundi, A=sekunde
	ADD	A, 10
	LD	(TIMER_DISPLAY + 4), A
	LD	A, B
	ADD	A, 10
	LD	(TIMER_DISPLAY + 3), A

	LD	HL, (GRPNAM)
	LD	L, 26
	DI
	CALL	VRAM_POS
	LD	HL, TIMER_DISPLAY
	LD	B, 5
	CALL	VRAM_BBYTE_COPY
	EI

	RET

; rutina za punjenje ispisnog buffera za score
; prilagodjena je tome da brojke pocinju od znaka 10
; HL = score
; IX = buffer (Px<dvotocka>00000)
PREPARE_SCORE:
	LD	DE, 10000
	CALL	DIVIDE16BIT
	LD	A, C
	ADD	A, 10
	LD	(IX + 3), A
	LD	DE, 1000
	CALL	DIVIDE16BIT
	LD	A, C
	ADD	A, 10
	LD	(IX + 4), A
	LD	DE, 100
	CALL	DIVIDE16BIT
	LD	A, C
	ADD	A, 10
	LD	(IX + 5), A
	LD	DE, 10
	CALL	DIVIDE16BIT
	LD	A, C
	ADD	A, 10
	LD	(IX + 6), A
	LD	A, L
	ADD	A, 10
	LD	(IX + 7), A
	RET

; rutina za ispis scorea za player 1
; resetiraj flag za ispis
DRAW_PLAYER1_SCORE:
	XOR	A
	LD	(PLAYER1_SCORE_UPDATED), A
	LD	HL, (GRPNAM)
	INC	HL
	DI
	CALL	VRAM_POS
	LD	HL, PLAYER1_DISPLAY
	CALL	VRAM_8BYTE_COPY
	EI
	RET

; rutina za ispis scorea za player 2
DRAW_PLAYER2_SCORE:
	XOR	A
	LD	(PLAYER2_SCORE_UPDATED), A
	LD	HL, (GRPNAM)
	LD	L, 14
	DI
	CALL	VRAM_POS
	LD	HL, PLAYER2_DISPLAY
	CALL	VRAM_8BYTE_COPY
	EI
	RET

; rutina za dohvat vrijednosti pogodjenog broda
; provjeri da li se radi o high profile ili civilian target
; deaktivira high profile i civilian target
; IX = brod inst
; IY = inst sprite
; izlaz DE
GET_BROD_VALUE:
	; provjeri da li se radi o civilian target
	LD	HL, (CIVILIAN_TARGET_INST)
	LD	A, L
	OR	H
	JR	Z, GET_BROD_VALUE_L1
	LD	DE, (CIVILIAN_TARGET_SPRITE)
	PUSH	IY
	POP	HL
	XOR	A
	SBC	HL, DE
	JR	NZ, GET_BROD_VALUE_L1
	; civilian target pogodjen
	LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	HL, 0
	LD	(CIVILIAN_TARGET_INST), HL
	;LD	A, HW_SPRITE_HIDE_Y
	;LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_Y), A
	;LD	A, CIVILIAN_TARGET_HW_SPRITE_INDEX
	;LD	HL, CIVILIAN_TARGET_HW_SPRITE
	;CALL	PUT_SPRITE_LITE_Y
	PUSH	IX
	LD	HL, ANIMACIJA_MINUS_BODOVI_ZA_CIVILIAN_TARGET
	LD	BC, CIVILIAN_TARGET_HW_SPRITE
	LD	IX, CIVILIAN_TARGET_ANIMACIJA_INST
	LD	A, CIVILIAN_TARGET_HW_SPRITE_INDEX
	CALL	SET_ANIMACIJA_INST_TO_INIT
	POP	IX
	LD	DE, -999
	RET

GET_BROD_VALUE_L1:
	LD	A, (IX + OFF_BROD_INST_ROW)
	CP	2
	JR	NZ, GET_BROD_VALUE_L2
	LD	DE, 99
	JR	GET_BROD_VALUE_L6
GET_BROD_VALUE_L2:
	CP	5
	JR	NZ, GET_BROD_VALUE_L3
	LD	DE, 88
	JR	GET_BROD_VALUE_L6
GET_BROD_VALUE_L3:
	CP	8
	JR	NZ, GET_BROD_VALUE_L4
	LD	DE, 77
	JR	GET_BROD_VALUE_L6
GET_BROD_VALUE_L4:
	CP	10
	JR	NZ, GET_BROD_VALUE_L5
	LD	DE, 66
	JR	GET_BROD_VALUE_L6
GET_BROD_VALUE_L5:
	LD	DE, 55
GET_BROD_VALUE_L6:
	PUSH	DE

	LD	HL, (HIGH_PROFILE_TARGET_INST)
	LD	A, L
	OR	H
	JR	Z, GET_BROD_VALUE_L7; ne postoji high profile target
	LD	HL, (HIGH_PROFILE_TARGET_SPRITE)
	PUSH	IY
	POP	DE
	XOR	A
	SBC	HL, DE
	JR	NZ, GET_BROD_VALUE_L7; nije pogodjen high profile target
	; zamijeni high profile animaciju sa x2
	LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	HL, 0
	LD	(HIGH_PROFILE_TARGET_INST), HL
	;LD	A, HW_SPRITE_HIDE_Y
	;LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_Y), A
	;LD	A, HIGH_PROFILE_TARGET_HW_SPRITE_INDEX
	;LD	HL, HIGH_PROFILE_TARGET_HW_SPRITE
	;CALL	PUT_SPRITE_LITE_Y
	PUSH	IX
	LD	HL, ANIMACIJA_DUPLI_BODOVI
	LD	BC, HIGH_PROFILE_TARGET_HW_SPRITE
	LD	IX, HIGH_PROFILE_TARGET_ANIMACIJA_INST
	LD	A, HIGH_PROFILE_TARGET_HW_SPRITE_INDEX
	CALL	SET_ANIMACIJA_INST_TO_INIT
	POP	IX
	POP	DE
	SLA	E; score x2
	RET

GET_BROD_VALUE_L7:
	POP	DE
	RET

; rutina za povecanje scorea za player 1 na temelju pogodjenog broda
; IX = brod inst
; IY = inst sprite
PLAYER1_UPDATE_SCORE:
	; ako smo na izlasku iz igre ne oduzimaj bodove
	LD	A, (GAMETIMER_ENDED)
	OR	A
	RET	NZ
	CALL	GET_BROD_VALUE
	LD	HL, (PLAYER1_SCORE)
	ADD	HL, DE
	; provjeri da li smo otisli u negativu
	BIT	7, H
	JR	Z, PLAYER1_UPDATE_SCORE_L1
	LD	HL, 0
PLAYER1_UPDATE_SCORE_L1:
	LD	(PLAYER1_SCORE), HL
	LD	A, 1
	LD	(PLAYER1_SCORE_UPDATED), A
	RET

; rutina za povecanje scorea za player 2 na temelju pogodjenog broda
; IX = brod inst
; IY = inst sprite
PLAYER2_UPDATE_SCORE:
	; ako smo na izlasku iz igre ne oduzimaj bodove
	LD	A, (GAMETIMER_ENDED)
	OR	A
	RET	NZ
	CALL	GET_BROD_VALUE
	LD	HL, (PLAYER2_SCORE)
	ADD	HL, DE
	; provjeri da li smo otisli u negativu
	BIT	7, H
	JR	Z, PLAYER2_UPDATE_SCORE_L1
	LD	HL, 0
PLAYER2_UPDATE_SCORE_L1:
	LD	(PLAYER2_SCORE), HL
	LD	A, 1
	LD	(PLAYER2_SCORE_UPDATED), A

	RET

; rutina za provjeru da li treba update scorea i update
CHECK_DRAW_SCORE:
	LD	A, (PLAYER1_SCORE_UPDATED)
	OR	A
	JR	Z, CHECK_DRAW_SCORE_L1
	LD	IX, PLAYER1_DISPLAY
	LD	HL, (PLAYER1_SCORE)
	CALL	PREPARE_SCORE
	CALL	DRAW_PLAYER1_SCORE
	
CHECK_DRAW_SCORE_L1:
	LD	A, (PLAYER2_SCORE_UPDATED)
	OR	A
	RET	Z
	LD	IX, PLAYER2_DISPLAY
	LD	HL, (PLAYER2_SCORE)
	CALL	PREPARE_SCORE
	CALL	DRAW_PLAYER2_SCORE

	RET


	