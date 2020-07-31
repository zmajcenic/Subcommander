;BuildROM	equ 1
BuildDisk	equ 1

; za 32k ROM file
ifdef BuildROM
	org &4000
	write "SUBCMDR.ROM"
	;limit &7fff		
	db "AB"
	dw INIT
	db 00,00,00,00,00,00
endif
ifdef BuildDisk
	ORG	&4000
	write	"disk_version.bin"
	DB	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
endif

FileStart:

	; rucno prekopirano nakon kompajliranja PSG playera
	PSG_PLAYER_INIT		EQU &C0DE
	PSG_PLAYER_PLAY		EQU &C142
	PSG_PLAYER_STOP		EQU &C12C
	SOUNDS_PLAYER_INIT	EQU &C000
	SOUNDS_PLAYER_PLAY	EQU &C004
	SOUNDS_PLAYER_STOP	EQU &C02C

	MUSIC_GAMEPLAY		EQU &8184
	MUSIC_HIGHSCORE		EQU &83BD
	MUSIC_ENDGAME		EQU &8699
	SOUNDS			EQU &8806
	SOUNDS_END		EQU &89B5

	HBI55_BEGIN_ADDRESS	EQU 4000

	read "grafika.asm" ; ovo treba biti prvo
	read "Vblank.asm"
	read "math.asm"
	read "timer_score_display.asm"
	read "Collision.asm"
	read "Mine.asm"
	read "HBI55.asm"

; Const
	GRPNAM  	EQU &F3C7; karakter
	GRPCOL		EQU &F3C9; boje
	GRPCGP		EQU &F3CB; definicija karaktera
	GRPATR		EQU &F3CD; sprite attribute
	GRPPAT		EQU &F3CF; sprite pattern
	JIFFY		EQU &FC9E; time
	HTIMI		EQU &FD9F; H.TIMI
	FORCLR		EQU &F3E9; foreground color
	BAKCLR		EQU &F3EA; background color
	BDRCLR		EQU &F3EB; border color 
	RG1SAV		EQU &F3E0; VDP R1 mirror
	CLIKSW		EQU &F3DB; key press click, 0=disable
	NEWKEY		EQU &FBE5 
	OLDKEY		EQU &FBDA
	CGTABL		EQU &0004; character set in ROM
	PUTPNT		EQU &F3F8; kbd buf put
	GETPNT		EQU &F3FA; kbd buf get
	PSLTRG		EQU &A8
	EXPTBL		EQU &FCC1
	FNKSTR		EQU &F87F ; function keys text

	HW_SPRITE_HIDE_Y	EQU 210; uvecano za 1 jer rutina smanjuje za 1

; BIOS
	FILVRM	EQU &56
	LDIRVM	EQU &5C
	CHGMOD	EQU &5F
	CHGCLR	EQU &62
	CHPUT	EQU &A2
	DISSCR	EQU &41
	ENASCR	EQU &44
	CHSNS	EQU &9C
	CHGET	EQU &9F
	ENASLT	EQU &24
	RSLREG  EQU &138

INTRVECTORTBL	EQU &8000
INTRVECTORROUT	EQU &8181
INTRTBLHIADDR	EQU &80
INTRROUTHIADDR	EQU &81

Fonts	EQU SOUNDS_END

Main_screen_graphics	EQU Fonts + 768


; struktura koja drzi podatke o brodu u pomacima od 0 do 7
; struct
;	DB DIM_X
OFF_BROD_DIM_X		EQU 0
;	DB DIM_Y
OFF_BROD_DIM_Y		EQU 1
;	DB CH_SIZE = broj znakova potrebnih za sve pomake
OFF_BROD_CH_SIZE	EQU 2
;	DB SMJER = 0 za pomak udesno, ostalo za ulijevo (mirror)
OFF_BROD_SMJER		EQU 3
;	DW [8] *DATAPTR
OFF_BROD_DATAPTR	EQU 4
;	DW [DIM_Y] *FG_COLORS
OFF_BROD_FG_COLORS	EQU 20

SIZEOF_BROD_1		EQU 24
SIZEOF_BROD_2		EQU 24
SIZEOF_BROD_DESTROYER_1	EQU 24
SIZEOF_BROD_SAILSHIP_1	EQU 26
SIZEOF_BROD_SAILSHIP_2	EQU 26
SIZEOF_BROD_PASSENGER_1	EQU 24
SIZEOF_BROD_CARGOSHIP_1 EQU 24
SIZEOF_BROD_FLOATSOME_1	EQU 24
SIZEOF_BROD_PLAYER_1	EQU 22
SIZEOF_BROD_PLAYER_2	EQU 22

BROD_1			EQU Main_screen_graphics + 2048
BROD_1_MIRR		EQU BROD_1 + SIZEOF_BROD_1
BROD_DESTROYER_1	EQU BROD_1_MIRR + SIZEOF_BROD_2
BROD_DESTROYER_1_MIRR	EQU BROD_DESTROYER_1 + SIZEOF_BROD_DESTROYER_1
BROD_SAILSHIP_1		EQU BROD_DESTROYER_1_MIRR + SIZEOF_BROD_DESTROYER_1
BROD_SAILSHIP_1_MIRR	EQU BROD_SAILSHIP_1 + SIZEOF_BROD_SAILSHIP_1
BROD_SAILSHIP_2		EQU BROD_SAILSHIP_1_MIRR + SIZEOF_BROD_SAILSHIP_1
BROD_SAILSHIP_2_MIRR	EQU BROD_SAILSHIP_2 + SIZEOF_BROD_SAILSHIP_2
BROD_PASSENGER_1	EQU BROD_SAILSHIP_2_MIRR + SIZEOF_BROD_SAILSHIP_2
BROD_PASSENGER_1_MIRR	EQU BROD_PASSENGER_1 + SIZEOF_BROD_PASSENGER_1
BROD_CARGOSHIP_1	EQU BROD_PASSENGER_1_MIRR + SIZEOF_BROD_PASSENGER_1
BROD_CARGOSHIP_1_MIRR	EQU BROD_CARGOSHIP_1 + SIZEOF_BROD_CARGOSHIP_1
BROD_FLOATSOME_1	EQU BROD_CARGOSHIP_1_MIRR + SIZEOF_BROD_CARGOSHIP_1
BROD_PLAYER_1		EQU BROD_FLOATSOME_1 + SIZEOF_BROD_FLOATSOME_1 
BROD_PLAYER_2		EQU BROD_PLAYER_1 + SIZEOF_BROD_PLAYER_1

; ptr na sve brodove za brzi random izbor
SVI_BRODOVI	EQU BROD_PLAYER_2 + SIZEOF_BROD_PLAYER_2
HEAPBEGIN 	EQU 4*BROJ_BRODOVA + SVI_BRODOVI

ifdef BuildDisk
; ovo nam treba samo kod disk verzije
ROT_1:	LD    HL,(ROT_I1)
        LD    IX,(ROT_O1)
        LD    DE,8
        LD    B,E
ROT_L2: PUSH  HL
        PUSH  IX
        PUSH  BC
        SCF
        CCF
        LD    A,(ROT_X)
        LD    B,A
ROT_L1: LD    A,(HL)
        RRA
        LD    (IX),A
        EX    AF,AF' ; sacuvaj c flag
        ADD   HL,DE
        ADD   IX,DE
        EX    AF,AF'
        DJNZ  ROT_L1
        LD    A,0
        RRA
	;ovo ne bi smio raditi kad ROT_EX = 0
        LD    (IX),A
        POP   BC
        POP   IX
        POP   HL
        INC   HL
        INC   IX
        DJNZ  ROT_L2
        RET

; Rotira lik od par redaka za 1 bit udesno iz input u output buffer
; pocetak na ROTATE_RIGHT
; na DB(ROT_X) - broj znakova u retku
; na DB(ROT_Y2) - broj redaka
; na DW(ROT_I1) - input buffer trenutnog retka
; na DW(ROT_O1) - output buffer trnutnog retka
; na DW(ROT_I2) - input buffer cijelog lika
; na DW(ROT_O2) - output buffer cijelog lika
; na DW(ROT_EX) - stavljamo 8 ako zelimo podatke od preljeva
;                 output buffer treba biti onda i veci da primi te podatke
;                 za prvu rotaciju stavimo da je lik velik X*Y uz EX=8
;                 za slijedecu (X+1)*Y uz EX=0

ROTATE_RIGHT:
	PUSH  AF
	PUSH  HL
	PUSH  DE
	PUSH  BC
	PUSH  IX
	LD    HL,0
        LD    DE,8
        LD    A,(ROT_X)
        LD    B,A
ROT_L3: ADD   HL,DE
        DJNZ  ROT_L3
        PUSH  HL
        POP   DE
        LD    A,(ROT_Y2)
        LD    B,A
        LD    HL,(ROT_I2)
        LD    (ROT_I1),HL
        LD    IX,(ROT_O2)
        LD    (ROT_O1),IX
ROT_L4: PUSH  HL
        PUSH  DE
        PUSH  IX
        PUSH  BC
        CALL  ROT_1
        POP   BC
        POP   IX
        LD    DE,(ROT_EX)
        ADD   IX,DE
        POP   DE
        ADD   IX,DE
        LD    (ROT_O1),IX
        POP   HL
        ADD   HL,DE
        LD    (ROT_I1),HL
        DJNZ  ROT_L4
	POP   IX
	POP   BC
	POP   DE
	POP   HL
	POP   AF
        RET

; rutina za MIRROR ROT_X*ROT_Y2 lika
; pocetak na MIRROR
; na DB(ROT_X) - broj znakova u retku
; na DB(ROT_Y2) - broj redaka
; na DW(ROT_I2) - input buffer cijelog lika
; na DW(ROT_O2) - output buffer cijelog lika
MIRROR:
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	IX
	PUSH	AF

	LD IX,(ROT_I2)
	LD HL,(ROT_O2)
	LD DE, 8
	LD A, (ROT_Y2)
	LD B, A
MIRROR_LOOP_6:
	PUSH BC
	LD A, (ROT_X)
	LD B,A
	PUSH  BC	; FOR petlja za broj znakova u retku
	DEC B
	JR Z, MIRROR_LOOP_5
MIRROR_LOOP_1:
	ADD HL,DE
	DJNZ MIRROR_LOOP_1
MIRROR_LOOP_5:
	LD (ROT_O1),HL ; spremi out lokaciju za slijedeci red kasnije
	POP BC
MIRROR_LOOP_2:
	PUSH BC
	LD B,8 ; FOR petlja za bajtove u znaku
MIRROR_LOOP_3:
	PUSH BC
	LD B,8 ; FOR petlja za bitove u znaku
	LD A, (IX)
MIRROR_LOOP_4:
	SRL A
	RL (HL)
	DJNZ MIRROR_LOOP_4
	INC HL
	INC IX
	POP BC
	DJNZ MIRROR_LOOP_3
	OR A ; set C = 0
	SBC HL,DE ; kako naopacke idemo kroz output buffer, za prelazak na slijedeci znak se treba vratiti 16 bajtova, a DE je vec 8
	OR A
	SBC HL,DE
	POP BC
	DJNZ MIRROR_LOOP_2
; tu smo odradili jedan redak
; IX je vec na dobrom mjestu
; HL nam je jedan znak ispred pocetka proslog retka
; uzmemo ga iz (ROT_O1) i dodamo 8
	LD HL, (ROT_O1)
	ADD HL, DE
	POP BC
	DJNZ MIRROR_LOOP_6

	POP	AF
	POP	IX
	POP	BC
	POP	DE
	POP	HL
	RET  
endif

; rutina za dohvacanje random broja 0-255
; cita slijedno iz &0000-&1FFF
; drzi trenutnu lokaciju u (RNDPTR)
GET_RND_NUM:
	PUSH	HL
	LD	HL, (RNDPTR)
	LD	A, H
	AND	&1F
	LD	H, A
	LD	A, R
	ADD	A, (HL)
	INC	HL
	LD	(RNDPTR), HL
	POP	HL
	RET
	

; color schemes
COLTBL:
DB	11,10,14,9,8,6,1 ; crvena 
DB	11,10,14,3,2,12,1 ; zelena
DB	11,10,14,7,5,4,1 ; plava

GET_COLOR_IDX:	; u BC je broj retka
        PUSH  HL
        PUSH  DE
        PUSH  BC
        LD    H,&FF 
        LD    L,&F0; HL = -16
        ADD   HL,BC
        CALL  GET_RND_NUM
        AND   &1F ; ogranici na 32
        LD    B,0
        LD    C,A
        ADD   HL,BC
        BIT   7,H
        JR    NZ, GET_COLOR_IDX_LOOP_E ; broj je negativan, index je 0
        LD    A,L
        CP    162 ; sve iznad 162 je index 6
        JR    NC, GET_COLOR_IDX_GORNJA
        LD    C,27
GET_COLOR_IDX_LOOP1:  
	SUB   C
        JR    C, GET_COLOR_IDX_LOOP_E
        INC   B
        JR    GET_COLOR_IDX_LOOP1
GET_COLOR_IDX_LOOP_E: 
	LD    A,B
        POP   BC
        POP   DE
        POP   HL
        RET
GET_COLOR_IDX_GORNJA: 
	LD    B,6
        JR    GET_COLOR_IDX_LOOP_E
GET_COLOR_IDX_ENTRY:  ; na (IX) ide rezultat
	CALL  GET_COLOR_IDX
        LD    H,0
        LD    L,A
        ADD   HL,DE
        LD    A,(HL)
        LD    (IX),A
        INC   IX
        INC   BC
        RET
; rutina za izracun pozadiske boje
; u DE = tablica boja
; u BC = redak
; U IX = output buffer
; popunjava buffer u COLBUF
GET_COLOR_BUF:
        PUSH  HL
        PUSH  IX
	PUSH  AF
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
        CALL  GET_COLOR_IDX_ENTRY
	POP   AF
        POP   IX
        POP   HL
        RET

; rutina za pozicioniranje u VRAM-u
; prepisano iz ROM-a
; izbacen DI/EI za potrebe rada u VBLANK modu
; u normalnom kodu potrebno ubaciti DI/EI oko poziva pisanja u VRAM
; HL = adresa
VRAM_POS:
	LD	A, L
	OUT	(&99), A
	LD	A, H
	AND	&3F
	OR	&40
	OUT	(&99), A
	RET

; rutina za prebacivanje 8 karaktera u VRAM pocevsi od (HL)
; lokaciju u VRAM-u treba prvo postaviti sa VRAM_POS
; ne moze biti 8x OUTI zbog sporosti VDP-a
; map.grauw.nl/articles/vdp_tut.php
VRAM_8BYTE_COPY:
	PUSH	BC
	LD	BC, &0898
VRAM_8BYTE_COPY_L1:
	OUTI
	JP	NZ, VRAM_8BYTE_COPY_L1
	POP	BC
	RET

; rutina za prebacivanje B karaktera u VRAM pocevsi od (HL)
; lokaciju u VRAM-u treba prvo postaviti sa VRAM_POS
VRAM_BBYTE_COPY:
	PUSH	BC
	LD	C, &98
VRAM_BBYTE_COPY_L1:
	OUTI
	JP	NZ, VRAM_BBYTE_COPY_L1
	POP	BC
	RET

; rutina za izracun boje za pojedini redak
; u A je red
; rezultat ide u tabelu ROWCOLBUF [24*8]
; u HL je vracena adresa u koju je upisana boja
GET_ROW_COLOR:
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	IX
	LD	DE, 8
	LD	HL, ROWCOLBUF
	OR	A
	JR	Z, GET_ROW_COLOR_LOOP1
	LD	B, A
GET_ROW_COLOR_LOOP2:
	ADD	HL, DE
	DJNZ	GET_ROW_COLOR_LOOP2
GET_ROW_COLOR_LOOP1:
	SLA	A
	SLA	A
	SLA	A
	LD	C, A
	LD	B, 0
	PUSH	HL
	POP	IX
	LD	DE, (COLOR_SCHEME)
	CALL	GET_COLOR_BUF
	POP	IX
	POP	DE
	POP	BC
	POP	AF
	RET

; rutina za zapisivanje boje retka u VRAM
; ekraj se dijeli na 3 dijela po 8 redaka
; prvih 8 znakova u svakoj trecini se koriste za pojedini redak
; u HL color buffer
; u A redak 0-23
PUT_ROW_COLOR_TO_VRAM:
	PUSH	AF
	PUSH	DE
	PUSH	BC
	PUSH	HL
	LD	HL, (GRPCOL)
	LD	DE, 32*8*8
	SUB	8
	JP	M, PUT_ROW_COLOR_TO_VRAM_L1
	ADD	HL, DE
	SUB	8
	JP	M, PUT_ROW_COLOR_TO_VRAM_L1
	ADD	HL, DE
PUT_ROW_COLOR_TO_VRAM_L2:
	SLA	A
	SLA	A
	SLA	A
	LD	D, 0
	LD	L, A
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	POP	HL
	CALL	VRAM_8BYTE_COPY
	EI
	POP	BC
	POP	DE
	POP	AF
	RET
PUT_ROW_COLOR_TO_VRAM_L1:
	ADD	A, 8
	JR	PUT_ROW_COLOR_TO_VRAM_L2

; rutina za popunjavanje retka karakterom za prazninu
; u A je redak 0-23
; pretpostavlja da je boja vec u VRAM-u
DRAW_EMPTY_ROW:
	PUSH	HL
	PUSH	BC
	PUSH	AF
	PUSH	DE
	LD	DE, 32
	LD	HL, (GRPNAM)
	OR	A
	JR	Z, DRAW_EMPTY_ROW_L1
	LD	B, A
DRAW_EMPTY_ROW_L2:
	ADD	HL, DE
	DJNZ	DRAW_EMPTY_ROW_L2
	SUB	8
	JP	M, DRAW_EMPTY_ROW_L3
	SUB	8
	JP	M, DRAW_EMPTY_ROW_L3
DRAW_EMPTY_ROW_L1:
	LD	BC, 32
	; pozovi BIOS rutinu za pisanje
	; ne brini o DI/EI jer se ovo ionako ne zove u modu igranja
	CALL	FILVRM
	POP	DE
	POP	AF
	POP	BC
	POP	HL
	RET
DRAW_EMPTY_ROW_L3:
	ADD	A, 8
	JR	DRAW_EMPTY_ROW_L1

ifdef BuildDisk
; rutina za izradu pomaknutih verzija brodova
; u HL ptr na brod u ROM-u
; u IX ptr na output struct
; HEAPPTR je gdje alociramo buffere
FILL_STRUCT_BRODOVI:
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	IX
	PUSH	IY
	PUSH 	AF

	LD	IY, (HEAPPTR)
	; prvo da izracunamo CH_SIZE za znati koliko znakova nam treba za ubaciti instancu broda u trecinu ekrana
	; to je 8*(DIM_X+1)*DIM_Y-DIM_Y = DIM_Y * (8*(DIM_X+1) - 1)
	LD	A, (HL) ; DIM_X
	LD	(IX), A
	LD	(ROT_X), A
	INC	HL
	INC	A
	SLA	A
	SLA	A
	SLA	A
	DEC	A ; A = (8*(DIM_X+1) - 1)
	LD	E, A
	LD	A, (HL) ; DIM_Y
	INC	HL
	PUSH	HL ; za kasnije
	LD	(ROT_Y2), A
	LD	(IX + 1), A
	LD	B, A
	XOR	A
FILL_STRUCT_BRODOVI_L5:
	ADD	A, E
	DJNZ	FILL_STRUCT_BRODOVI_L5
	LD	(IX + 2), A ; CH_SIZE
	LD	(IX + 3), 0 ; smjer = 0
	
	; izracunamo koliko se moramo pomicati u memoriji za svaki novi pomak
	; DIM_Y*(DIM_X+1)*8, to je isto kao CH_SIZE + DIM_Y
	ADD	A, (IX + 1)
	LD	E, A
	LD	D, 0
	
	INC	IX
	INC	IX
	INC	IX
	INC	IX

	XOR	A
	LD	(ROT_EX+1), A
	LD	A, 8
	LD	(ROT_EX), A
	LD	(ROT_I2), HL
	LD	(ROT_O2), IY
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	CALL	ROTATE_RIGHT
; tu smo odradili prvi pomak
; sad moramo postaviti ROT_EX na 0
; u DE je velicina buffera tocna
; u (IX) ide ptr na mem lokaciju slijedeceg generiranog buffera
	XOR 	A
	LD	(ROT_EX), A
	LD	A, (ROT_X)
	INC	A
	LD	(ROT_X), A
	LD	B, 6
FILL_STRUCT_BRODOVI_L2:
	PUSH	IY
	POP	HL
	LD	(ROT_I2), HL
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	ADD	IY, DE
	LD	(ROT_O2), IY
	CALL	ROTATE_RIGHT
	DJNZ	FILL_STRUCT_BRODOVI_L2

	PUSH	IY
	POP	HL
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	ADD	IY, DE
	LD	(HEAPPTR), IY
; sad se vracamo na boje
; na stacku je adresa od DATA
	POP	HL
	LD	D, 0
	LD	A, (ROT_X)
	DEC	A ; jer smo ga gore povecali
	SLA	A
	SLA	A
	SLA	A
	LD	E, A
	LD	A, (ROT_Y2)
	LD	B, A
FILL_STRUCT_BRODOVI_L3:
	ADD	HL, DE
	DJNZ	FILL_STRUCT_BRODOVI_L3
	LD	A, (ROT_Y2)
	LD	B, A
	LD	E, 8
FILL_STRUCT_BRODOVI_L4:
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	ADD	HL, DE
	DJNZ	FILL_STRUCT_BRODOVI_L4
	POP	AF
	POP	IY
	POP	IX
	POP	BC
	POP	DE
	POP 	HL
	RET
	
; rutina za izradu pomaknutih mirror verzija brodova
; u HL ptr na normalni brod u ROM-u
; u IX ptr na output struct
; HEAPPTR je gdje alociramo buffere
FILL_STRUCT_BRODOVI_MIRROR:
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	IX
	PUSH	IY
	PUSH 	AF

	LD	IY, (HEAPPTR)
	LD	A, (HL) ; DIM_X
	LD	(IX), A
	LD	(ROT_X), A
	INC	HL
	; izracunaj velicinu za preskok reda originala
	SLA	A
	SLA	A
	SLA	A
	LD	E, A
	LD	D, 0 ; u DE = DIM_X * 8

	LD	A, (HL) ; DIM_Y
	LD	(IX + 1), A
	LD	(ROT_Y2), A
	INC	HL	; sad smo na data broda

; tu kreiramo mirror verziju iz (HL) u (IY)
	LD	(ROT_I2), HL
	LD	(ROT_O2), IY
	CALL	MIRROR
	LD	(ROT_I2), IY ; za prvi poziv ROTATE_RIGHT

	; preskoci original data te povecaj IY
	LD	B, A
FILL_STRUCT_BRODOVI_MIRROR_L5:
	ADD	HL, DE
	ADD	IY, DE
	DJNZ	FILL_STRUCT_BRODOVI_MIRROR_L5

	PUSH	HL	; za kasnije da nadjemo boje 

	; izracunaj pomak u mem kad radimo sa DIM_X+1
	LD	A, (ROT_X)
	INC	A
	SLA	A
	SLA	A
	SLA	A
	LD	E, A

	LD	A, (ROT_Y2)
	LD	B, A
	LD	HL, 0
FILL_STRUCT_BRODOVI_MIRROR_L1:
	ADD	HL, DE
	DJNZ	FILL_STRUCT_BRODOVI_MIRROR_L1
	EX	DE, HL

	; popuni jos CH_SIZE = E - DIM_Y
	LD	A, E
	SUB	A, (IX + 1)
	LD	(IX + 2), A
	LD	(IX + 3), 1 ; negativan smjer
	INC	IX	
	INC	IX
	INC	IX
	INC 	IX

	XOR	A
	LD	(ROT_EX+1), A
	LD	A, 8
	LD	(ROT_EX), A
	LD	(ROT_O2), IY
	LD	HL, (ROT_I2)
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	CALL	ROTATE_RIGHT
; tu smo odradili prvi pomak
; sad moramo postaviti ROT_EX na 0
; u DE je velicina buffera tocna
; u (IX) ide ptr na mem lokaciju slijedeceg generiranog buffera
	XOR 	A
	LD	(ROT_EX), A
	LD	A, (ROT_X)
	INC	A
	LD	(ROT_X), A
	LD	B, 6
FILL_STRUCT_BRODOVI_MIRROR_L2:
	PUSH	IY
	POP	HL
	LD	(ROT_I2), HL
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	ADD	IY, DE
	LD	(ROT_O2), IY
	CALL	ROTATE_RIGHT
	DJNZ	FILL_STRUCT_BRODOVI_MIRROR_L2

	PUSH	IY
	POP	HL
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	ADD	IY, DE
	LD	(HEAPPTR), IY
; sad se vracamo na boje
; na stacku je adresa od COLOR
	POP	HL
	
	LD	A, (ROT_Y2)
	LD	B, A
	LD	E, 8
FILL_STRUCT_BRODOVI_MIRROR_L4:
	LD	(IX), L
	INC	IX
	LD	(IX), H
	INC	IX
	ADD	HL, DE
	DJNZ	FILL_STRUCT_BRODOVI_MIRROR_L4
	POP	AF
	POP	IY
	POP	IX
	POP	BC
	POP	DE
	POP 	HL
	RET
endif

; rutina za inicijalizaciju ROWx struktura sa nulama
ROWx_INIT:
	LD	HL, ROW2_BROD_INST
	XOR	A
	CALL	ROWx_INIT_1

	LD	HL, ROW5_BROD_INST
	CALL	ROWx_INIT_1

	LD	HL, ROW8_BROD_INST
	CALL	ROWx_INIT_1

	LD	HL, ROW10_BROD_INST
	CALL	ROWx_INIT_1

	LD	HL, ROW13_BROD_INST
	CALL	ROWx_INIT_1

	LD	HL, ROW16_BROD_INST
	CALL	ROWx_INIT_1

	LD	HL, ROW22_BROD_INST
	CALL	ROWx_INIT_1

	LD	HL, ROW23_BROD_INST
	CALL	ROWx_INIT_1

	RET
ROWx_INIT_1:
	LD	B, SIZEOF_BROD_INST
ROWx_INIT_2:
	LD	(HL), A
	INC	HL
	DJNZ	ROWx_INIT_2
	RET

; rutina za inicijalizaciju trecina ekrana
TRECINA_EKRANA_INIT:
	LD	HL, PRVA_TRECINA_EKRANA
	LD	(HL), PRVA_TRECINA_EKRANA_NUM_FREE
	INC	HL
	LD	(HL), PRVA_TRECINA_EKRANA_FREE_START
	INC	HL
	LD	DE, (GRPCGP)
	LD	HL, PRVA_TRECINA_EKRANA_VRAM_BEGIN
	ADD	HL, DE
	LD	E, L
	LD	D, H
	LD	HL, PRVA_TRECINA_EKRANA + OFF_TRECINA_EKRANA_VRAM_BEGIN
	LD	(HL), E
	INC	HL
	LD	(HL), D
	INC	HL
	LD	B, PRVA_TRECINA_EKRANA_NUM_FREE
	CALL	TRECINA_EKRANA_INIT_L1

	LD	HL, DRUGA_TRECINA_EKRANA
	LD	(HL), DRUGA_TRECINA_EKRANA_NUM_FREE
	INC	HL
	LD	(HL), DRUGA_TRECINA_EKRANA_FREE_START
	INC	HL
	LD	DE, (GRPCGP)
	LD	HL, DRUGA_TRECINA_EKRANA_VRAM_BEGIN
	ADD	HL, DE
	LD	E, L
	LD	D, H
	LD	HL, DRUGA_TRECINA_EKRANA + OFF_TRECINA_EKRANA_VRAM_BEGIN
	LD	(HL), E
	INC	HL
	LD	(HL), D
	INC	HL
	LD	B, DRUGA_TRECINA_EKRANA_NUM_FREE
	CALL	TRECINA_EKRANA_INIT_L1

	LD	HL, TRECA_TRECINA_EKRANA
	LD	(HL), TRECA_TRECINA_EKRANA_NUM_FREE
	INC	HL
	LD	(HL), TRECA_TRECINA_EKRANA_FREE_START
	INC	HL
	LD	DE, (GRPCGP)
	LD	HL, TRECA_TRECINA_EKRANA_VRAM_BEGIN
	ADD	HL, DE
	LD	E, L
	LD	D, H
	LD	HL, TRECA_TRECINA_EKRANA + OFF_TRECINA_EKRANA_VRAM_BEGIN
	LD	(HL), E
	INC	HL
	LD	(HL), D
	INC	HL
	LD	B, TRECA_TRECINA_EKRANA_NUM_FREE
	
TRECINA_EKRANA_INIT_L1:
	; zapisuje id=0, row=255
	LD	(HL), 0
	INC	HL
	LD	(HL), &FF
	INC	HL
	DJNZ	TRECINA_EKRANA_INIT_L1
	RET

; rutina za postavljanje boja za znakove u odredjenom retku
; kombinira boju broda koji zauzima taj redak i boju pozadine
; E = row
; ako je row < 2 samo izadje
; takodjer provjeri da li brod uopce zauzima redak
COLOUR_CHARS_IN_ROW:
	PUSH	AF
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX
	PUSH	IY
	
	LD	A, E
	CP	2
	JP	C, COLOUR_CHARS_IN_ROW_EXIT
	CP	5
	JR	NC, COLOUR_CHARS_IN_ROW_L1
	; row 2
	LD	IY, ROW2_BROD_INST
	SUB	2 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L1:
	CP	8
	JR	NC, COLOUR_CHARS_IN_ROW_L2
	; row 5
	LD	IY, ROW5_BROD_INST
	SUB	5 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L2:
	CP	10
	JR	NC, COLOUR_CHARS_IN_ROW_L3
	; row 8
	LD	IY, ROW8_BROD_INST
	SUB	8 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L3:
	CP	13
	JR	NC, COLOUR_CHARS_IN_ROW_L4
	; row 10
	LD	IY, ROW10_BROD_INST
	SUB	10 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L4:
	CP	16
	JR	NC, COLOUR_CHARS_IN_ROW_L5
	; row 13
	LD	IY, ROW13_BROD_INST
	SUB	13 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L5:
	CP	20
	JP	NC, COLOUR_CHARS_IN_ROW_L15
	; row 16
	LD	IY, ROW16_BROD_INST
	SUB	16 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L15:
	CP	22
	JR	NZ, COLOUR_CHARS_IN_ROW_L16
	; row 22
	LD	IY, ROW22_BROD_INST
	SUB	22 ; idx u FG_COLOUR tabeli
	JR	COLOUR_CHARS_IN_ROW_L6
COLOUR_CHARS_IN_ROW_L16:
	; row 23
	LD	IY, ROW23_BROD_INST
	SUB	23 ; idx u FG_COLOUR tabeli

COLOUR_CHARS_IN_ROW_L6:
	; provjeri da li je instanca u upotrebi, id!=0
	LD	B, A
	LD	A, (IY + OFF_BROD_INST_ID)
	OR	A
	JP	Z, COLOUR_CHARS_IN_ROW_EXIT
	; provjeri da li je redak uopce iskoristen od instance
	; tj. da li je brod dovoljno visok
	LD	A, (IY + OFF_BROD_INST_DIM_Y)
	DEC	A
	CP	B
	JP	C, COLOUR_CHARS_IN_ROW_EXIT

	PUSH	IY ;*1
	; u HL ucitaj inst.brodptr
	LD	L, (IY + OFF_BROD_INST_BROD);
	LD	H, (IY + OFF_BROD_INST_BROD + 1);
	LD	C, E; zapamti row
	LD	DE, OFF_BROD_FG_COLORS
	ADD	HL, DE

	LD	E, B	
	SLA	E
	ADD	HL, DE
	; u (HL) = fg color za row
	LD	E, (HL)
	INC	HL
	LD	D, (HL)
	LD	H, D
	LD	L, E
	; u HL je fg colors
	PUSH	HL
	LD	DE, 8
	LD	HL, ROWCOLBUF
	LD	A, C
	OR	A
	JR	Z, COLOUR_CHARS_IN_ROW_L7
	LD	B, A
COLOUR_CHARS_IN_ROW_L8:
	ADD	HL, DE
	DJNZ	COLOUR_CHARS_IN_ROW_L8
COLOUR_CHARS_IN_ROW_L7:
	PUSH	HL
	POP	IX
	POP	HL
	LD	IY, COL_GEN_BUF
	; HL = fg color
	; IX = bg color
	; IY = tmp buf
	LD	B, 8
COLOUR_CHARS_IN_ROW_L9:
	LD	A, (HL)
	OR	(IX)
	LD	(IY), A
	INC	HL
	INC	IX
	INC	IY
	DJNZ	COLOUR_CHARS_IN_ROW_L9
	
	; sad prolazimo kroz trecina ekrana i stavljamo boje
	; u C je row
	LD	A, C
	CP	8
	JR	NC, COLOUR_CHARS_IN_ROW_L10
	LD	IX, PRVA_TRECINA_EKRANA
	LD	B, PRVA_TRECINA_EKRANA_NUM_FREE
	JR	COLOUR_CHARS_IN_ROW_L12
COLOUR_CHARS_IN_ROW_L10:
	CP	16
	JR	NC, COLOUR_CHARS_IN_ROW_L11
	LD	IX, DRUGA_TRECINA_EKRANA
	LD	B, DRUGA_TRECINA_EKRANA_NUM_FREE
	JR	COLOUR_CHARS_IN_ROW_L12
COLOUR_CHARS_IN_ROW_L11:
	LD	IX, TRECA_TRECINA_EKRANA
	LD	B, TRECA_TRECINA_EKRANA_NUM_FREE

COLOUR_CHARS_IN_ROW_L12:
	POP	IY; *1
	INC	IX
	INC	IX
	LD	L, (IX)
	INC	IX
	LD	H, (IX)
	INC	IX
	; u HL je pozicija u char vramu
	; oduzmi offset pocetka char vrama i dodaj offset pocetka color tabele
	LD	DE, (GRPCGP)
	SCF
	CCF
	SBC	HL, DE
	LD	DE, (GRPCOL)
	ADD	HL, DE
	LD	DE, 8

COLOUR_CHARS_IN_ROW_L13:
	LD	A, (IX + 1); row u trecina ekrana
	INC	IX
	INC	IX
	CP	C
	JR	NZ, COLOUR_CHARS_IN_ROW_L14
	DI
	CALL	VRAM_POS
	PUSH	HL
	LD	HL, COL_GEN_BUF
	PUSH	BC
	CALL	VRAM_8BYTE_COPY
	EI
	POP	BC
	POP	HL
COLOUR_CHARS_IN_ROW_L14:
	ADD	HL, DE
	DJNZ	COLOUR_CHARS_IN_ROW_L13

COLOUR_CHARS_IN_ROW_EXIT:
	POP	IY
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	POP	AF
	RET

; rutina koja u instancu ubaci random brod
; UZASNO CPU skupa funkcija - potrebno ubaciti provjeru torpedo hitova
; HL = trecina ekrana
; IX = instanca
; IY = brod
; E = row
INSERT_BROD:
	; definiraj instance id, preskoci 0(prazno) i 255(rezervirano)
	; bilo bi dobro i kasnije ali treba nam za ubacivanje u {id, row} i bojanje
	LD	A, (UNIQUE_INST_ID)
	INC	A
	CP	255
	JR	NZ, INSERT_BROD_L1
	LD	A, 1
INSERT_BROD_L1:
	LD	(UNIQUE_INST_ID), A
	LD	(IX + OFF_BROD_INST_ID), A

	; zapisi dim_x, dim_y, smjer
	LD	(IX + OFF_BROD_INST_ROW), E
	LD	A, (IY + OFF_BROD_DIM_X)
	LD	(IX + OFF_BROD_INST_DIM_X), A
	LD	A, (IY + OFF_BROD_DIM_Y)
	LD	(IX + OFF_BROD_INST_DIM_Y), A
	LD	A, (IY + OFF_BROD_SMJER) ; 0=u desno kretanje
	OR	A
	JR	NZ, INSERT_BROD_L2
	LD	(IX + OFF_BROD_INST_SMJER), 1
	LD	(IX + OFF_BROD_INST_SMJER + 1), 0
	JR	INSERT_BROD_L3
INSERT_BROD_L2:
	LD	(IX + OFF_BROD_INST_SMJER), &FF
	LD	(IX + OFF_BROD_INST_SMJER + 1), &FF
INSERT_BROD_L3:
	; pomocne varijable
	; (ROT_O1) = VRAM pos
	; (ROT_X)  = koliko znakova u retku
	; (ROT_EX) = trecina ekrana {id, row} dio
	; (ROT_O2) = broj znaka sa kojim radimo u popunjavanju
	INC	HL 
	LD	A, (HL) ; free_start u trecina ekrana
	LD	(ROT_O2), A
	INC	HL
	LD	C, (HL)
	INC	HL
	LD	B, (HL)
	INC	HL
	LD	(ROT_O1), BC ; pozicija u VRAM-u
	LD	(ROT_EX), HL ; pozicija u {id, row}
	LD	A, (IX + OFF_BROD_INST_DIM_X)
	LD	(ROT_X), A ; za pomak 0
	
	PUSH	IY; *2
	LD	L, (IY + OFF_BROD_DATAPTR)
	LD	H, (IY + OFF_BROD_DATAPTR + 1)
	PUSH	HL
	PUSH	IX
	POP	HL
	LD	C, E; spremi row
	LD	DE, OFF_BROD_INST_ZNAKOVI
	ADD	HL, DE
	LD	(IX + OFF_BROD_INST_ZNPTR), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 1), H ; inst.znptr[0]=pocetak buffera
	PUSH	HL
	POP	IY
	POP	HL
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 0

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 2), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 3), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 2)
	LD	H, (IY + OFF_BROD_DATAPTR + 3)
	POP	IY
	LD	A, (IX + OFF_BROD_INST_DIM_X)
	INC	A
	LD	(ROT_X), A ; za pomake 1-7
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 1

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 4), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 5), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 4)
	LD	H, (IY + OFF_BROD_DATAPTR + 5)
	POP	IY
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 2

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 6), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 7), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 6)
	LD	H, (IY + OFF_BROD_DATAPTR + 7)
	POP	IY
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 3

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 8), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 9), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 8)
	LD	H, (IY + OFF_BROD_DATAPTR + 9)
	POP	IY
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 4

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 10), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 11), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 10)
	LD	H, (IY + OFF_BROD_DATAPTR + 11)
	POP	IY
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 5

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 12), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 13), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 12)
	LD	H, (IY + OFF_BROD_DATAPTR + 13)
	POP	IY
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 6

	PUSH	IY
	POP	HL
	LD	(IX + OFF_BROD_INST_ZNPTR + 14), L
	LD	(IX + OFF_BROD_INST_ZNPTR + 15), H
	POP	IY; *2
	PUSH	IY; *2
	PUSH	HL
	LD	L, (IY + OFF_BROD_DATAPTR + 14)
	LD	H, (IY + OFF_BROD_DATAPTR + 15)
	POP	IY
	CALL	INSERT_BROD_WRITE
	; odradjen pomak 7
	POP	IY ;* 2

	; oboji retke
	LD	E, C
	LD	B, (IX + OFF_BROD_INST_DIM_Y)
INSERT_BROD_L4:
	LD	A, (IX + OFF_BROD_INST_DIM_Y)
	SUB	B
	ADD	A, C
	LD	E, A
	; E = row
	CALL	COLOUR_CHARS_IN_ROW
	DJNZ	INSERT_BROD_L4

	; inicijaliziraj sprajtove
	LD	DE, OFF_BROD_INST_SPRITE
	ADD	IX, DE

	; podesi y poziciju
	LD	A, C
	SLA	A
	SLA	A
	SLA	A
	LD	(IX + OFF_SPRITE_Y), A
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_Y), A
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_Y), A
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_Y), A

INSERT_BROD_SPECIAL_FLOATSOME_ENTRY:
	; ovdje mozemo pozvati rutinu
	; da samo izracuna nove pocetne pozicije za floatsome
	; moramo podesiti 
	; IX = sprajtovi
	; IY = brod

	; izracunaj duljinu lika u pikselima
	LD	E, (IY + OFF_BROD_DIM_X)
	SLA	E
	SLA	E
	SLA	E
	LD	D, 0
	
	LD	A, (IY + OFF_BROD_SMJER)
	OR	A
	JR	NZ, INSERT_BROD_L5
	; udesno
	LD	HL, 0
	SCF
	CCF
	SBC	HL, DE
	LD	(IX + OFF_SPRITE_X), L
	LD	(IX + OFF_SPRITE_X + 1), H

	CALL	GET_RND_NUM
	AND	&3F
	ADD	A, E
	ADD	A, 16
	PUSH	DE
	LD	E, A
	SBC	HL, DE
	POP	DE
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_X), L
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_X + 1), H

	CALL	GET_RND_NUM
	AND	&3F
	ADD	A, E
	ADD	A, 16
	PUSH	DE
	LD	E, A
	SBC	HL, DE
	POP	DE
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_X), L
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_X + 1), H

	CALL	GET_RND_NUM
	AND	&3F
	ADD	A, E
	ADD	A, 16
	PUSH	DE
	LD	E, A
	SBC	HL, DE
	POP	DE
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_X), L
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_X + 1), H
	JR	INSERT_BROD_L6
INSERT_BROD_L5:
	; ulijevo
	LD	HL, 256
	LD	(IX + OFF_SPRITE_X), L
	LD	(IX + OFF_SPRITE_X + 1), H

	CALL	GET_RND_NUM
	AND	&3F
	ADD	A, E
	ADD	A, E
	ADD	A, 16
	PUSH	DE
	LD	E, A
	ADD	HL, DE
	POP	DE
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_X), L
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_X + 1), H

	CALL	GET_RND_NUM
	AND	&3F
	ADD	A, E
	ADD	A, E
	ADD	A, 16
	PUSH	DE
	LD	E, A
	ADD	HL, DE
	POP	DE
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_X), L
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_X + 1), H

	CALL	GET_RND_NUM
	AND	&3F
	ADD	A, E
	ADD	A, E
	ADD	A, 16
	PUSH	DE
	LD	E, A
	ADD	HL, DE
	POP	DE
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_X), L
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_X + 1), H

INSERT_BROD_L6:
	; postavi aktiv flag = 1
	LD	(IX + OFF_SPRITE_AKTIV_FLAG), 1 
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 1
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 1
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 1

	RET
INSERT_BROD_WRITE:
	PUSH	BC; *3
	LD	DE, 8
	LD	B, (IX + OFF_BROD_INST_DIM_Y)
INSERT_BROD_WRITE_L1:
	PUSH	BC
	LD	A, (ROT_X)
	LD	B, A
	; IX = inst
	; IY = pos u inst.znakovi
	; HL = data
	; C = row
	PUSH	HL; *1
	LD	HL, (ROT_EX); {id, row}
INSERT_BROD_WRITE_L2:
	LD	A, (HL)
	OR	A
	JR	Z, INSERT_BROD_WRITE_L3
	; znak vec upotrijebljen, preskoci
	INC	HL
	INC	HL
	LD	A, (ROT_O2); znak sa kojim radimo
	INC	A	
	LD	(ROT_O2), A
	PUSH	HL
	LD	HL, (ROT_O1); VRAM pos
	ADD	HL, DE
	LD	(ROT_O1), HL
	POP	HL
	JR	INSERT_BROD_WRITE_L2
INSERT_BROD_WRITE_L3:
	; zapisi znak
	LD	A, (IX + OFF_BROD_INST_ID)
	LD	(HL), A
	INC	HL
	LD	(HL), C
	INC	HL
	LD	(ROT_EX), HL
	LD	A, (ROT_O2)
	LD	(IY), A
	INC	IY
	INC	A
	LD	(ROT_O2), A
	LD	HL, (ROT_O1); VRAM pos
	DI
	CALL	VRAM_POS
	ADD	HL, DE
	LD	(ROT_O1), HL
	POP	HL; *1
	PUSH	BC
	CALL	VRAM_8BYTE_COPY
	EI
	POP	BC
	PUSH	HL; gornja rutina ga vec povecala za 8
	LD	HL, (ROT_EX)
	DJNZ	INSERT_BROD_WRITE_L2

	; provjeri collision jer smo potrosili puno CPU-a i moguce da je doslo do vecih pomaka torpeda i mina
	PUSH	DE
	PUSH	IX
	PUSH	IY
	CALL	CHECK_TORPEDO_HITS
	CALL	CHECK_MINE_COLLISIONS
	POP	IY
	POP	IX
	POP	DE

	POP	HL
	POP	BC
	INC	C
	DJNZ	INSERT_BROD_WRITE_L1
	POP	BC; *3
	RET	

; rutina za aktiviranje animacija inst i postavljenja vrijednosti na 0 te prikaz spritea
; ocekuje da su x i y vec podeseni
; HL = animacija
; IX = animacija inst
; BC = hw sprite
; A = hw sprite index
SET_ANIMACIJA_INST_TO_INIT:
	PUSH	DE
	PUSH	AF
	PUSH	BC
	LD	(IX + OFF_ANIMACIJA_INST_ANIMACIJA), L
	LD	(IX + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), A
	LD	D, 0
	LD	A, (HL); num_iter
	LD	E, A
	INC	HL
	INC	HL; pause
	INC	BC
	INC	BC
	INC	BC; pattern
	ADD	HL, DE; pattern[0]
	LD	A, (HL)
	LD	(BC), A
	ADD	HL, DE
	INC	BC
	LD	A, (HL)
	LD	(BC), A
	LD	(IX + OFF_ANIMACIJA_INST_CURR_ITER), 0
	POP	HL
	POP	AF
	;DI
	CALL	PUT_SPRITE_FULL
	LD	(IX + OFF_ANIMACIJA_INST_ACTIVE), 1
	LD	HL, (JIFFY)
	LD	(IX + OFF_ANIMACIJA_INST_TIME), L
	LD	(IX + OFF_ANIMACIJA_INST_TIME + 1), H
	;EI
	POP	DE
	RET

; rutina za ispunjavanje prazne instance
; takodjer uz neku vjerojatnost postavlja high profile i civilian target
; HL = trecina ekrana
; IX = instanca
; D = max velicina broda
; E = row
NAPUNI_BROD_INST:
	PUSH	BC
	PUSH	HL
	PUSH	DE

	; uzmemo random brod
	; postoji lista svih kandidata
	; struct brod* SVI_BRODOVI[2*BROJ_BRODOVA]
	CALL	GET_RND_NUM
	LD	C, 2*BROJ_BRODOVA; jer imamo i mirror varijante
	CALL	MODULO8BIT
	SLA	A
	LD	B, 0
	LD	C, A
	LD	IY, SVI_BRODOVI
	ADD	IY, BC
	LD	C, (IY)
	LD	B, (IY + 1)
	PUSH	BC
	POP	IY

	LD	A, D
	LD	D, (IY + OFF_BROD_DIM_Y)
	CP	D
	JP	C, NAPUNI_BROD_INST_EXIT ; ne stane brod, izadji
	; provjeri ima li slobodnih znakova za instancu
	
	LD	A, (IY + OFF_BROD_CH_SIZE)
	LD	D, A
	LD	A, (HL) ;  num_free
	CP	D
	JP	C, NAPUNI_BROD_INST_EXIT ; nema dovoljno slobodnih znakova, izadji
	SUB	D
	LD	(HL), A

	; spremi ptr na brod
	LD	(IX + OFF_BROD_INST_BROD), C
	LD	(IX + OFF_BROD_INST_BROD + 1), B 

	PUSH	IX
	CALL	INSERT_BROD
	POP	IX

	; sad prodji kroz generirane sprajtove i postavi high profile ili civilian target
	; ako vec ne postoje i zadovoljimo neku vjerojatnost
	LD	DE, OFF_BROD_INST_SPRITE
	PUSH	IX
	POP	IY
	ADD	IY, DE
	LD	DE, SIZEOF_SPRITE
	LD	B, 4
NAPUNI_BROD_INST_L1:
	LD	HL, (HIGH_PROFILE_TARGET_INST)
	LD	A, L
	OR	H
	JR	NZ, NAPUNI_BROD_INST_L2
	; nema aktivnog high profile targeta
	CALL	GET_RND_NUM
	CP	220
	JR	C, NAPUNI_BROD_INST_L2
	; prosli smo %, postavi high profile target
	LD	(HIGH_PROFILE_TARGET_INST), IX
	LD	(HIGH_PROFILE_TARGET_SPRITE), IY
	;XOR	A
	;LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_CURR_ITER), A
	LD	A, (IX + OFF_BROD_INST_DIM_Y)
	SLA	A
	SLA	A
	SLA	A
	SUB	16
	SRL	A
	ADD	A, (IY + OFF_SPRITE_Y)
	LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_Y), A
	LD	HL, -16
	LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_X), HL
	;LD	A, (ANIMACIJA_HIGH_PROFILE_TARGET + OFF_ANIMACIJA_NUM_ITER)
	;PUSH	DE
	;LD	E, A
	;LD	HL, ANIMACIJA_HIGH_PROFILE_TARGET + OFF_ANIMACIJA_PAUSE
	;ADD	HL, DE
	;LD	A, (HL)
	;LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_PATTERN), A
	;ADD	HL, DE
	;LD	A, (HL)
	;LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_COLOR), A
	;POP	DE
	;LD	HL, HIGH_PROFILE_TARGET_HW_SPRITE
	;LD	A, HIGH_PROFILE_TARGET_HW_SPRITE_INDEX
	;DI
	;CALL	PUT_SPRITE_FULL
	;LD	A, 1
	;LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	;LD	HL, (JIFFY)
	;LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_TIME), HL
	;EI
	LD	HL, ANIMACIJA_HIGH_PROFILE_TARGET
	PUSH	IX
	LD	IX, HIGH_PROFILE_TARGET_ANIMACIJA_INST
	PUSH	BC
	LD	BC, HIGH_PROFILE_TARGET_HW_SPRITE
	LD	A, HIGH_PROFILE_TARGET_HW_SPRITE_INDEX
	DI
	CALL	SET_ANIMACIJA_INST_TO_INIT
	EI
	POP	BC
	POP	IX
	JR	NAPUNI_BROD_INST_L3

NAPUNI_BROD_INST_L2:
	LD	HL, (CIVILIAN_TARGET_INST)
	LD	A, L
	OR	H
	JR	NZ, NAPUNI_BROD_INST_L3
	; nema aktivnog civilian targeta
	CALL	GET_RND_NUM
	CP	220
	JR	C, NAPUNI_BROD_INST_L3
	; prosli smo %, postavi civilian target
	LD	(CIVILIAN_TARGET_INST), IX
	LD	(CIVILIAN_TARGET_SPRITE), IY
	;XOR	A
	;LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_CURR_ITER), A
	LD	A, (IX + OFF_BROD_INST_DIM_Y)
	SLA	A
	SLA	A
	SLA	A
	SUB	16
	SRL	A
	ADD	A, (IY + OFF_SPRITE_Y)
	LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_Y), A
	LD	HL, -16
	LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_X), HL
	;LD	A, (ANIMACIJA_CIVILIAN_TARGET + OFF_ANIMACIJA_NUM_ITER)
	;PUSH	DE
	;LD	E, A
	;LD	HL, ANIMACIJA_CIVILIAN_TARGET + OFF_ANIMACIJA_PAUSE
	;ADD	HL, DE
	;LD	A, (HL)
	;LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_PATTERN), A
	;ADD	HL, DE
	;LD	A, (HL)
	;LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_COLOR), A
	;POP	DE
	;LD	HL, CIVILIAN_TARGET_HW_SPRITE
	;LD	A, CIVILIAN_TARGET_HW_SPRITE_INDEX
	;DI
	;CALL	PUT_SPRITE_FULL
	;LD	A, 1
	;LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	;LD	HL, (JIFFY)
	;LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_TIME), HL
	;EI
	LD	HL, ANIMACIJA_CIVILIAN_TARGET
	PUSH	IX
	LD	IX, CIVILIAN_TARGET_ANIMACIJA_INST
	PUSH	BC
	LD	BC, CIVILIAN_TARGET_HW_SPRITE
	LD	A, CIVILIAN_TARGET_HW_SPRITE_INDEX
	DI
	CALL	SET_ANIMACIJA_INST_TO_INIT
	EI
	POP	BC
	POP	IX

NAPUNI_BROD_INST_L3:
	ADD	IY, DE
	DEC	B
	JP	NZ, NAPUNI_BROD_INST_L1

NAPUNI_BROD_INST_EXIT:
	POP	DE
	POP	HL
	POP	BC
	RET
	
; rutina za popunjavanje prve trecine ekrana
; provjeri da li je instanca aktivna, ako nije pozove ispunu
;PRVA_TRECINA_GEN:
;	LD	HL, PRVA_TRECINA_EKRANA
	
;	LD	IX, ROW2_BROD_INST
;	LD	D, 3
;	LD	E, 2
;	LD	A, (IX + OFF_BROD_INST_ID)
;	OR	A
;	CALL	Z, NAPUNI_BROD_INST
	
;	LD	IX, ROW5_BROD_INST
;	LD	E, 5
;	LD	A, (IX + OFF_BROD_INST_ID)
;	OR	A
;	CALL	Z, NAPUNI_BROD_INST
	
;	RET

; rutina za popunjavanje druge trecine ekrana
; provjeri da li je instanca aktivna, ako nije pozove ispunu
;DRUGA_TRECINA_GEN:
;	LD	HL, DRUGA_TRECINA_EKRANA
	
;	LD	IX, ROW8_BROD_INST
;	LD	D, 2
;	LD	E, 8
;	LD	A, (IX + OFF_BROD_INST_ID)
;	OR	A
;	CALL	Z, NAPUNI_BROD_INST
	
;	LD	IX, ROW10_BROD_INST
;	LD	D, 3
;	LD	E, 10
;	LD	A, (IX + OFF_BROD_INST_ID)
;	OR	A
;	CALL	Z, NAPUNI_BROD_INST

;	LD	IX, ROW13_BROD_INST
;	LD	E, 13
;	LD	A, (IX + OFF_BROD_INST_ID)
;	OR	A
;	CALL	Z, NAPUNI_BROD_INST
	
;	RET

; rutina za iscrtavanje sprajta iz instance
; IX = instanca
; IY = sprite
; pomocna tabela za offset retka u vramu da ne racunamo u petlji svaki put
ROW_VRAM_OFFSET:
DW &0000, &0020, &0040, &0060, &0080, &00A0, &00C0, &00E0
DW &0100, &0120, &0140, &0160, &0180, &01A0, &01C0, &01E0
DW &0200, &0220, &0240, &0260, &0280, &02A0, &02C0, &02E0

DRAW_INST_SPRITE:
	PUSH	BC
	PUSH	DE
	PUSH	HL
	PUSH	IX

	LD	D, 0
	LD	A, (IX + OFF_BROD_INST_ROW)
	LD	E, A
	SLA	E
	LD	HL, ROW_VRAM_OFFSET
	ADD	HL, DE
	LD	E, (HL)
	INC	HL
	LD	D, (HL)
	LD	HL, (GRPNAM)
	ADD	HL, DE
	; HL = VRAM pos retka
	LD	(DIS_VRAM_POS), HL

	; nadji znak praznine za redak
	; u A je jos row
	AND	A, 7
	LD	(DIS_EMPTY_CHAR), A

	LD	B, (IX +  OFF_BROD_INST_DIM_Y)
	LD	A, (IX +  OFF_BROD_INST_DIM_X)
	LD	(DIS_DIM_X), A

	LD	A, (IY + OFF_SPRITE_X)
	AND	7
	LD	(DIS_POMAK), A; pomak
	SLA	A
	LD	D, 0
	LD	E, A
	ADD	IX, DE
	LD	DE, OFF_BROD_INST_ZNPTR
	ADD	IX, DE
	LD	E, (IX)
	LD	D, (IX + 1)
	PUSH	DE
	POP	IX
	; IX = znakovi za pomak

DRAW_INST_SPRITE_L4:
	PUSH	BC
	; izracunaj pocetnu poziciju za znak praznine ulijevo
	LD	L, (IY + OFF_SPRITE_X)
	LD	H, (IY + OFF_SPRITE_X + 1)
	LD	DE, 8
	SCF
	CCF
	SBC	HL, DE
	LD	(DIS_TMPX), HL	
	
	BIT	7, H
	JR	NZ, DRAW_INST_SPRITE_L5; negativno pa ga ne crtamo
	LD	A, H
	OR	A
	JR	NZ, DRAW_INST_SPRITE_EXIT; pocetni znak je vec izvan 256
	; ovdje znamo da je pocetak unutar vidljivog ekrana
	; nadji offset u VRAM-u
	LD	E, L
	SRL	E
	SRL	E
	SRL	E
	; u E je offset
	LD	HL, (DIS_VRAM_POS)
	ADD	HL, DE
	CALL	VRAM_POS
	LD	A, (DIS_EMPTY_CHAR); znak praznine
	OUT	(&98), A
	JR	DRAW_INST_SPRITE_L6
DRAW_INST_SPRITE_L5:
	; samo postavi VRAM poziciju na pocetak reda za kasnije
	LD	HL, (DIS_VRAM_POS)
	CALL	VRAM_POS
DRAW_INST_SPRITE_L6:
	LD	HL, (DIS_TMPX)
	LD	E, 8
	ADD	HL, DE
	LD	A, (DIS_POMAK); pomak
	OR	A
	JR	Z, DRAW_INST_SPRITE_L7
	LD	A, (DIS_DIM_X)
	INC	A
	JR	DRAW_INST_SPRITE_L8
DRAW_INST_SPRITE_L7:
	LD	A, (DIS_DIM_X)
DRAW_INST_SPRITE_L8:
	LD	B, A
	; VRAM pos je postavljen
	; IX = znakovi
	; B = broj znakova u retku
	; HL = x, provjerimo za svaki da li je u ekranu
DRAW_INST_SPRITE_L9:
	BIT	7, H
	JR	NZ, DRAW_INST_SPRITE_L10; van ekrana, preskoci
	LD	A, H
	OR	A
	JR	NZ, DRAW_INST_SPRITE_L10; izvan ekrana, preskoci
	LD	A, (IX)
	OUT	(&98), A
DRAW_INST_SPRITE_L10:
	INC	IX
	ADD	HL, DE
	DJNZ	DRAW_INST_SPRITE_L9
	; jos praznina na desno
	BIT	7, H
	JR	NZ, DRAW_INST_SPRITE_L11; van ekrana, preskoci
	LD	A, H
	OR	A
	JR	NZ, DRAW_INST_SPRITE_L11; izvan ekrana, odi dalje
	LD	A, (DIS_EMPTY_CHAR)
	OUT	(&98), A
DRAW_INST_SPRITE_L11:
	POP	BC
	LD	HL, (DIS_VRAM_POS)
	LD	DE, 32
	ADD	HL, DE
	LD	(DIS_VRAM_POS), HL
	LD	A, (DIS_EMPTY_CHAR); znak praznine
	INC	A
	LD	(DIS_EMPTY_CHAR), A
	DJNZ	DRAW_INST_SPRITE_L4
DRAW_INST_SPRITE_L12:
	POP	IX
	POP	HL
	POP	DE
	POP	BC
	RET
DRAW_INST_SPRITE_EXIT:
	POP	BC
	JR	DRAW_INST_SPRITE_L12

; rutina za brisanje sprajta na ekranu
; IX = instanca
; IY = sprite
ERASE_INST_SPRITE:
	PUSH	BC
	PUSH	DE
	PUSH	HL

	LD	D, 0
	LD	A, (IX + OFF_BROD_INST_ROW)
	LD	E, A
	SLA	E
	LD	HL, ROW_VRAM_OFFSET
	ADD	HL, DE
	LD	E, (HL)
	INC	HL
	LD	D, (HL)
	LD	HL, (GRPNAM)
	ADD	HL, DE
	; HL = VRAM pos retka
	LD	(DIS_VRAM_POS), HL

	; nadji znak praznine za redak
	; u A je jos row
	AND	A, 7
	LD	(DIS_EMPTY_CHAR), A

	LD	B, (IX +  OFF_BROD_INST_DIM_Y)
	LD	A, (IX +  OFF_BROD_INST_DIM_X)
	LD	(DIS_DIM_X), A

	LD	A, (IY + OFF_SPRITE_X)
	AND	7
	LD	(DIS_POMAK), A; pomak
	LD	D, 0

ERASE_INST_SPRITE_L4:
	PUSH	BC
	; izracunaj pocetnu poziciju
	LD	L, (IY + OFF_SPRITE_X)
	LD	H, (IY + OFF_SPRITE_X + 1)
	LD	(DIS_TMPX), HL	
	
	BIT	7, H
	JR	NZ, ERASE_INST_SPRITE_L5; negativno pa ga ne crtamo
	LD	A, H
	OR	A
	JR	NZ, ERASE_INST_SPRITE_EXIT; pocetni znak je vec izvan 256
	; ovdje znamo da je pocetak unutar vidljivog ekrana
	; nadji offset u VRAM-u
	LD	E, L
	SRL	E
	SRL	E
	SRL	E
	; u E je offset
	LD	HL, (DIS_VRAM_POS)
	ADD	HL, DE
	CALL	VRAM_POS
	JR	ERASE_INST_SPRITE_L6
ERASE_INST_SPRITE_L5:
	; samo postavi VRAM poziciju na pocetak reda za kasnije
	LD	HL, (DIS_VRAM_POS)
	CALL	VRAM_POS
ERASE_INST_SPRITE_L6:
	LD	E, 8
	LD	A, (DIS_POMAK); pomak
	OR	A
	JR	Z, ERASE_INST_SPRITE_L7
	LD	A, (DIS_DIM_X)
	INC	A
	JR	ERASE_INST_SPRITE_L8
ERASE_INST_SPRITE_L7:
	LD	A, (DIS_DIM_X)
ERASE_INST_SPRITE_L8:
	LD	B, A
	LD	HL, (DIS_TMPX)
	; VRAM pos je postavljen
	; B = broj znakova u retku
	; HL = x, provjerimo za svaki da li je u ekranu
ERASE_INST_SPRITE_L9:
	BIT	7, H
	JR	NZ, ERASE_INST_SPRITE_L10; van ekrana, preskoci
	LD	A, H
	OR	A
	JR	NZ, ERASE_INST_SPRITE_L10; izvan ekrana, preskoci
	LD	A, (DIS_EMPTY_CHAR)
	OUT	(&98), A
ERASE_INST_SPRITE_L10:
	ADD	HL, DE
	DJNZ	ERASE_INST_SPRITE_L9
ERASE_INST_SPRITE_L11:
	POP	BC
	LD	HL, (DIS_VRAM_POS)
	LD	DE, 32
	ADD	HL, DE
	LD	(DIS_VRAM_POS), HL
	LD	A, (DIS_EMPTY_CHAR); znak praznine
	INC	A
	LD	(DIS_EMPTY_CHAR), A
	DJNZ	ERASE_INST_SPRITE_L4
ERASE_INST_SPRITE_L12:

	POP	HL
	POP	DE
	POP	BC
	RET
ERASE_INST_SPRITE_EXIT:
	POP	BC
	JR	ERASE_INST_SPRITE_L12

; rutina za iscrtavanje cijelog ekrana
INIT_PLAY_SCREEN: 
	LD	B, 24
INIT_PLAY_SCREEN_L1:
	LD	A, B
	DEC	A
	CALL	GET_ROW_COLOR
	CALL	PUT_ROW_COLOR_TO_VRAM
	CALL	DRAW_EMPTY_ROW
	DJNZ	INIT_PLAY_SCREEN_L1

	; prebaci znakove P,dvotocka i brojke u VRAM za prvu trecinu ekrana
	LD	HL, (GRPCGP)
	LD	L, 64
	DI
	CALL	VRAM_POS
	EI
	LD	HL, BROJEVI_PATTERN
	LD	B, 96
	CALL	VRAM_BBYTE_COPY

	; pobojaj
	LD	HL, (GRPCOL)
	LD	L, 64
	DI
	CALL	VRAM_POS
	EI
	LD	IY, COL_GEN_BUF
	LD	HL, ROWCOLBUF
	LD	B, 8
INIT_PLAY_SCREEN_L3:
	LD	A, (HL)
	OR	&40; boja slova
	LD	(IY), A
	INC	HL
	INC	IY
	DJNZ	INIT_PLAY_SCREEN_L3
	LD	B, 12
INIT_PLAY_SCREEN_L4:
	LD	HL, COL_GEN_BUF
	CALL	VRAM_8BYTE_COPY
	DJNZ	INIT_PLAY_SCREEN_L4

	; inicijaliziraj buffere za prikaz scorea i vremena
	LD	IX, PLAYER1_DISPLAY
	LD	(IX), 8; P
	LD	(IX + 1), 11; 1
	LD	(IX + 2), 9; dvotocka
	LD	(IX + 3), 10; nula
	LD	(IX + 4), 10; nula
	LD	(IX + 5), 10; nula
	LD	(IX + 6), 10; nula
	LD	(IX + 7), 10; nula

	LD	IX, PLAYER2_DISPLAY
	LD	(IX), 8; P
	LD	(IX + 1), 12; 2
	LD	(IX + 2), 9; dvotocka
	LD	(IX + 3), 10; nula
	LD	(IX + 4), 10; nula
	LD	(IX + 5), 10; nula
	LD	(IX + 6), 10; nula
	LD	(IX + 7), 10; nula
	
	LD	IX, TIMER_DISPLAY
	LD	(IX), 10; nula
	LD	(IX + 1), 10; nula
	LD	(IX + 2), 9; dvotocka
	LD	(IX + 3), 10; nula
	LD	(IX + 4), 10; nula

	; ispisi
	CALL	DRAW_PLAYER1_SCORE
	CALL	DRAW_PLAYER2_SCORE

	;LD	HL, (GRPNAM)
	;LD	L, 27
	;DI
	;CALL	VRAM_POS
	;EI
	;LD	HL, TIMER_DISPLAY
	;LD	B, 5
	;CALL	VRAM_BBYTE_COPY

	RET

; rutina za praznjenje instance
; postavlja id na 0
; brise sve zapise iz trecine ekrana
; IX = instanca
; IY = trecina ekrana
INST_CLEAR:
	LD	L, (IX + OFF_BROD_INST_BROD)
	LD	H, (IX + OFF_BROD_INST_BROD + 1)
	LD	A, (IY + OFF_TRECINA_EKRANA_NUMFREE)
	LD	DE, OFF_BROD_CH_SIZE
	ADD	HL, DE
	ADD	A, (HL)
	LD	(IY + OFF_TRECINA_EKRANA_NUMFREE), A
	
	LD	HL, 256
	LD	E, (IY + OFF_TRECINA_EKRANA_FREE_START)
	SCF
	CCF
	SBC	HL, DE
	LD	B, L

	LD	A, (IX + OFF_BROD_INST_ID)
	LD	(IX + OFF_BROD_INST_ID), 0
	
	LD	DE, OFF_TRECINA_EKRANA_USAGE
	PUSH	IY
	POP	HL
	ADD	HL, DE
INST_CLEAR_L1:
	CP	(HL)
	JR	NZ, INST_CLEAR_L2
	LD	(HL), 0
	INC	HL
	LD	(HL), &FF
	INC	HL
	DJNZ	INST_CLEAR_L1
	RET
INST_CLEAR_L2:
	INC	HL
	INC	HL
	DJNZ	INST_CLEAR_L1
	RET

; rutina za iscrtavanje sprajtova iz instance
CHECK_DRAW_INSTANCES:
	PUSH	BC
	PUSH	DE
	PUSH	HL

	; ROW 2
	LD	IX, ROW2_BROD_INST
	LD	A, (IX + OFF_BROD_INST_ID)
	OR	A
	JR	Z, CHECK_DRAW_INSTANCES_L1; neaktivna instanca
	; provjeri da li su u aktivnoj instanci svi sprajtovi neaktivni
	LD	IY, ROW2_BROD_INST + OFF_BROD_INST_SPRITE
	LD	A, (IY + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG) 
	OR	(IY + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	JR	NZ, CHECK_DRAW_INSTANCES_L2
	; pobrisi instancu
	LD	IY, PRVA_TRECINA_EKRANA
	CALL	INST_CLEAR
	JR	CHECK_DRAW_INSTANCES_L2
CHECK_DRAW_INSTANCES_L1:
	; probaj popuniti instancu
	LD	HL, PRVA_TRECINA_EKRANA
	LD	D, 3
	LD	E, 2
	CALL	NAPUNI_BROD_INST
	CALL	GET_RND_NUM
	AND	1
	LD	(ROW2_SPEED), A

CHECK_DRAW_INSTANCES_L2:
	; ROW 5
	LD	IX, ROW5_BROD_INST
	LD	A, (IX + OFF_BROD_INST_ID)
	OR	A
	JR	Z, CHECK_DRAW_INSTANCES_L3; neaktivna instanca
	; provjeri da li su u aktivnoj instanci svi sprajtovi neaktivni
	LD	IY, ROW5_BROD_INST + OFF_BROD_INST_SPRITE
	LD	A, (IY + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG) 
	OR	(IY + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	JR	NZ, CHECK_DRAW_INSTANCES_L4
	; pobrisi instancu
	LD	IY, PRVA_TRECINA_EKRANA
	CALL	INST_CLEAR
	JR	CHECK_DRAW_INSTANCES_L4
CHECK_DRAW_INSTANCES_L3:
	; probaj popuniti instancu
	LD	HL, PRVA_TRECINA_EKRANA
	LD	D, 3
	LD	E, 5
	CALL	NAPUNI_BROD_INST
	CALL	GET_RND_NUM
	AND	1
	LD	(ROW5_SPEED), A

CHECK_DRAW_INSTANCES_L4:
	; ROW 8
	LD	IX, ROW8_BROD_INST
	LD	A, (IX + OFF_BROD_INST_ID)
	OR	A
	JR	Z, CHECK_DRAW_INSTANCES_L5; neaktivna instanca
	; provjeri da li su u aktivnoj instanci svi sprajtovi neaktivni
	LD	IY, ROW8_BROD_INST + OFF_BROD_INST_SPRITE
	LD	A, (IY + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG) 
	OR	(IY + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	JR	NZ, CHECK_DRAW_INSTANCES_L6
	; pobrisi instancu
	LD	IY, DRUGA_TRECINA_EKRANA
	CALL	INST_CLEAR
	JR	CHECK_DRAW_INSTANCES_L6
CHECK_DRAW_INSTANCES_L5:
	; probaj popuniti instancu
	LD	HL, DRUGA_TRECINA_EKRANA
	LD	D, 2
	LD	E, 8
	CALL	NAPUNI_BROD_INST
	CALL	GET_RND_NUM
	AND	1
	LD	(ROW8_SPEED), A

CHECK_DRAW_INSTANCES_L6:
	; ROW 10
	LD	IX, ROW10_BROD_INST
	LD	A, (IX + OFF_BROD_INST_ID)
	OR	A
	JR	Z, CHECK_DRAW_INSTANCES_L7; neaktivna instanca
	; provjeri da li su u aktivnoj instanci svi sprajtovi neaktivni
	LD	IY, ROW10_BROD_INST + OFF_BROD_INST_SPRITE
	LD	A, (IY + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG) 
	OR	(IY + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	JR	NZ, CHECK_DRAW_INSTANCES_L8
	; pobrisi instancu
	LD	IY, DRUGA_TRECINA_EKRANA
	CALL	INST_CLEAR
	JR	CHECK_DRAW_INSTANCES_L8
CHECK_DRAW_INSTANCES_L7:
	; probaj popuniti instancu
	LD	HL, DRUGA_TRECINA_EKRANA
	LD	D, 3
	LD	E, 10
	CALL	NAPUNI_BROD_INST
	CALL	GET_RND_NUM
	AND	1
	LD	(ROW10_SPEED), A

CHECK_DRAW_INSTANCES_L8:
	; ROW 13
	LD	IX, ROW13_BROD_INST
	LD	A, (IX + OFF_BROD_INST_ID)
	OR	A
	JR	Z, CHECK_DRAW_INSTANCES_L9; neaktivna instanca
	; provjeri da li su u aktivnoj instanci svi sprajtovi neaktivni
	LD	IY, ROW13_BROD_INST + OFF_BROD_INST_SPRITE
	LD	A, (IY + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG) 
	OR	(IY + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	JR	NZ, CHECK_DRAW_INSTANCES_L10
	; pobrisi instancu
	LD	IY, DRUGA_TRECINA_EKRANA
	CALL	INST_CLEAR
	JR	CHECK_DRAW_INSTANCES_L10
CHECK_DRAW_INSTANCES_L9:
	; probaj popuniti instancu
	LD	HL, DRUGA_TRECINA_EKRANA
	LD	D, 3
	LD	E, 13
	CALL	NAPUNI_BROD_INST
	CALL	GET_RND_NUM
	AND	1
	LD	(ROW13_SPEED), A

CHECK_DRAW_INSTANCES_L10:
	; ROW16 / FLOATSOME
	; provjeri da li su u aktivnoj instanci svi sprajtovi neaktivni
	LD	IY, ROW16_BROD_INST + OFF_BROD_INST_SPRITE
	LD	A, (IY + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	OR	(IY + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG) 
	OR	(IY + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG)
	JR	NZ, CHECK_DRAW_INSTANCES_L13
	; postavi novi smjer, pripadne x koordinate i active flags
	LD	IX, ROW16_BROD_INST + OFF_BROD_INST_SPRITE
	LD	IY, BROD_FLOATSOME_1
	;CALL	GET_RND_NUM
	;AND	&01
	;LD	(BROD_FLOATSOME_1 + OFF_BROD_SMJER), A
	;JR	NZ, CHECK_DRAW_INSTANCES_L11
	;LD	HL, 1
	;JR	CHECK_DRAW_INSTANCES_L12
;CHECK_DRAW_INSTANCES_L11
	;LD	HL, &FFFF
;CHECK_DRAW_INSTANCES_L12
	;LD	(ROW16_BROD_INST + OFF_BROD_INST_SMJER), HL
	CALL	INSERT_BROD_SPECIAL_FLOATSOME_ENTRY

CHECK_DRAW_INSTANCES_L13:
	POP	HL
	POP	DE
	POP	BC
	RET

; rutina za citanje reda tipkovnice
; B = row
KEYBOARD_ROW_SCAN:
	IN	A, (&AA)
	AND	&F0
	OR	B
	OUT	(&AA), A
	IN	A, (&A9)
RET

; rutina za kontrolu broda kursorskim tipkama + space
; E = -2, 0 ili 2 - pomak podmornice
; A !=0 ako pritisnut fire
GET_PLAYER_ACTION_CURSORS:
	LD	B, 8; row sa kursorima i space tipkom
	CALL	KEYBOARD_ROW_SCAN
	LD	E, 0
	BIT	7, A ; ->
	JR	NZ, GET_PLAYER_ACTION_CURSORS_L1
	LD	E, 2
GET_PLAYER_ACTION_CURSORS_L1:
	BIT	4, A ; <-
	JR	NZ, GET_PLAYER_ACTION_CURSORS_L2
	DEC	E
	DEC	E
GET_PLAYER_ACTION_CURSORS_L2:
	AND	1
	XOR	1
	RET

; rutina za kontrolu broda tipkama A, D i control tipkom
; E = -2, 0 ili 2 - pomak podmornice
; A !=0 ako pritisnut fire
GET_PLAYER_ACTION_ADCTRL:
	LD	B, 3
	CALL	KEYBOARD_ROW_SCAN
	LD	E, 0
	BIT	1, A; D
	JR	NZ, GET_PLAYER_ACTION_ADCTRL_L1
	LD	E, 2
GET_PLAYER_ACTION_ADCTRL_L1:
	LD	B, 2
	CALL	KEYBOARD_ROW_SCAN
	BIT	6, A; A
	JR	NZ, GET_PLAYER_ACTION_ADCTRL_L2
	DEC	E
	DEC	E
GET_PLAYER_ACTION_ADCTRL_L2:
	LD	A, (NEWKEY+6)
	AND	2
	XOR	2
	RET

; rutina za kontrolu broda tipkama I, P i SHIFT tipkom
; E = -2, 0 ili 2 - pomak podmornice
; A !=0 ako pritisnut fire
GET_PLAYER_ACTION_IPSHIFT:
	LD	B, 4
	CALL	KEYBOARD_ROW_SCAN
	LD	E, 0
	BIT	5, A; P
	JR	NZ, GET_PLAYER_ACTION_IPSHIFT_L1
	LD	E, 2
GET_PLAYER_ACTION_IPSHIFT_L1:
	LD	B, 3
	CALL	KEYBOARD_ROW_SCAN
	BIT	6, A; I
	JR	NZ, GET_PLAYER_ACTION_IPSHIFT_L2
	DEC	E
	DEC	E
GET_PLAYER_ACTION_IPSHIFT_L2:
	LD	A, (NEWKEY+6)
	AND	1
	XOR	1
	RET

; rutina za kontrolu broda sa joystickom u portu 0
; E = -2, 0 ili 2 - pomak podmornice
; A !=0 ako pritisnut fire
GET_PLAYER_ACTION_JOY1:
	LD	E, 0
	LD	A, 15
	OUT	(&A0), A
	IN	A, (&A2)
	AND	&BF
	OUT	(&A1), A
	LD	A, 14
	OUT	(&A0), A
	IN	A, (&A2)
	CPL
	RRCA
	RRCA
	RRCA
	JR	NC, GET_PLAYER_ACTION_JOY1_L1
	LD	E, &FE
GET_PLAYER_ACTION_JOY1_L1:
	RRCA
	JR	NC, GET_PLAYER_ACTION_JOY1_L2
	LD	E, 2
GET_PLAYER_ACTION_JOY1_L2:
	RRCA
	SBC	A, A
	RET

; rutina za kontrolu broda sa joystickom u portu 1
; E = -2, 0 ili 2 - pomak podmornice
; A !=0 ako pritisnut fire
GET_PLAYER_ACTION_JOY2:
	LD	E, 0
	LD	A, 15
	OUT	(&A0), A
	IN	A, (&A2)
	AND	&BF
	OR	&40
	OUT	(&A1), A
	LD	A, 14
	OUT	(&A0), A
	IN	A, (&A2)
	CPL
	RRCA
	RRCA
	RRCA
	JR	NC, GET_PLAYER_ACTION_JOY2_L1
	LD	E, &FE
GET_PLAYER_ACTION_JOY2_L1:
	RRCA
	JR	NC, GET_PLAYER_ACTION_JOY2_L2
	LD	E, 2
GET_PLAYER_ACTION_JOY2_L2:
	RRCA
	SBC	A, A
	RET

ifndef BuildROM
; rutina za generiranje brodova i mirror varijanti u RAM-u
INIT_BRODOVI:
	LD	IY, SVI_BRODOVI	

	; init TEST_BROD
	LD	HL, TEST_BROD
	LD	IX, BROD_1
	LD	DE, BROD_1
	LD	(IY), E
	LD	(IY + 1), D
	CALL	FILL_STRUCT_BRODOVI
	LD	IX, BROD_1_MIRR
	LD	DE, BROD_1_MIRR
	LD	(IY + 2), E
	LD	(IY + 3), D
	CALL	FILL_STRUCT_BRODOVI_MIRROR

	; INIT DESTROYER_1
	LD	HL, DESTROYER_1
	LD	IX, BROD_DESTROYER_1
	LD	DE, BROD_DESTROYER_1
	LD	(IY + 4), E
	LD	(IY + 5), D
	CALL	FILL_STRUCT_BRODOVI
	LD	IX, BROD_DESTROYER_1_MIRR
	LD	DE, BROD_DESTROYER_1_MIRR
	LD	(IY + 6), E
	LD	(IY + 7), D
	CALL	FILL_STRUCT_BRODOVI_MIRROR

	; INIT SAILSHIP_1
	LD	HL, SAILSHIP_1
	LD	IX, BROD_SAILSHIP_1
	LD	DE, BROD_SAILSHIP_1
	LD	(IY + 8), E
	LD	(IY + 9), D
	CALL	FILL_STRUCT_BRODOVI
	LD	IX, BROD_SAILSHIP_1_MIRR
	LD	DE, BROD_SAILSHIP_1_MIRR
	LD	(IY + 10), E
	LD	(IY + 11), D
	CALL	FILL_STRUCT_BRODOVI_MIRROR

	; INIT SAILSHIP_2
	LD	HL, SAILSHIP_2
	LD	IX, BROD_SAILSHIP_2
	LD	DE, BROD_SAILSHIP_2
	LD	(IY + 12), E
	LD	(IY + 13), D
	CALL	FILL_STRUCT_BRODOVI
	LD	IX, BROD_SAILSHIP_2_MIRR
	LD	DE, BROD_SAILSHIP_2_MIRR
	LD	(IY + 14), E
	LD	(IY + 15), D
	CALL	FILL_STRUCT_BRODOVI_MIRROR

	; INIT PASSENGER_1
	LD	HL, PASSENGER_1
	LD	IX, BROD_PASSENGER_1
	LD	DE, BROD_PASSENGER_1
	LD	(IY + 16), E
	LD	(IY + 17), D
	CALL	FILL_STRUCT_BRODOVI
	LD	IX, BROD_PASSENGER_1_MIRR
	LD	DE, BROD_PASSENGER_1_MIRR
	LD	(IY + 18), E
	LD	(IY + 19), D
	CALL	FILL_STRUCT_BRODOVI_MIRROR

	; INIT CARGOSHIP
	LD	HL, CARGOSHIP_1
	LD	IX, BROD_CARGOSHIP_1
	LD	DE, BROD_CARGOSHIP_1
	LD	(IY + 20), E
	LD	(IY + 21), D
	CALL	FILL_STRUCT_BRODOVI
	LD	IX, BROD_CARGOSHIP_1_MIRR
	LD	DE, BROD_CARGOSHIP_1_MIRR
	LD	(IY + 22), E
	LD	(IY + 23), D
	CALL	FILL_STRUCT_BRODOVI_MIRROR

	; INIT FLOATSOME_1
	LD	HL, FLOATSOME_1
	LD	IX, BROD_FLOATSOME_1
	CALL	FILL_STRUCT_BRODOVI

	; INIT PLAYER_1
	LD	HL, PLAYER_1
	LD	IX, BROD_PLAYER_1
	CALL	FILL_STRUCT_BRODOVI

	; INIT PLAYER_2
	LD	HL, PLAYER_2
	LD	IX, BROD_PLAYER_2
	CALL	FILL_STRUCT_BRODOVI

	RET
endif

; rutina za generiranje pauze za potrebe floatsome-a
; vraca od 10-19 sekundi u A
;GET_FLOATSOME_WAIT_TIME:
;	CALL	GET_RND_NUM
;	LD	C, 10
;	CALL	MODULO8BIT
;	ADD	A, 10
;	RET

; rutina za inicijalizaciju floatsome-a te player brodova
INIT_ROW_16_22_23:
	; floatsome
	LD	IX, BROD_FLOATSOME_1
	LD	HL, TRECA_TRECINA_EKRANA
	LD	A, (BROD_FLOATSOME_1 + OFF_BROD_CH_SIZE)
	LD	D, A
	LD	A, (HL) ;  num_free
	SUB	D
	LD	(HL), A

	; spremi ptr na brod
	LD	DE, BROD_FLOATSOME_1
	LD	IX, ROW16_BROD_INST
	LD	(IX + OFF_BROD_INST_BROD), E
	LD	(IX + OFF_BROD_INST_BROD + 1), D
	LD	IY, BROD_FLOATSOME_1
	LD	E, 16
	CALL	INSERT_BROD

	; player 1
	LD	IX, BROD_PLAYER_1
	LD	HL, TRECA_TRECINA_EKRANA
	LD	A, (BROD_PLAYER_1 + OFF_BROD_CH_SIZE)
	LD	D, A
	LD	A, (HL) ;  num_free
	SUB	D
	LD	(HL), A

	; spremi ptr na brod
	LD	DE, BROD_PLAYER_1
	LD	IX, ROW23_BROD_INST
	LD	(IX + OFF_BROD_INST_BROD), E
	LD	(IX + OFF_BROD_INST_BROD + 1), D
	LD	IY, BROD_PLAYER_1
	LD	E, 23
	CALL	INSERT_BROD
	; disable sprite 2, 3 i 4
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 0
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 0
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 0
	; postavi sprite na sredinu ekrana
	LD	(IX + OFF_SPRITE_X), 116
	LD	(IX + OFF_SPRITE_X + 1), 0

	; player 2
	LD	IX, BROD_PLAYER_2
	LD	HL, TRECA_TRECINA_EKRANA
	LD	A, (BROD_PLAYER_2 + OFF_BROD_CH_SIZE)
	LD	D, A
	LD	A, (HL) ;  num_free
	SUB	D
	LD	(HL), A

	; spremi ptr na brod
	LD	DE, BROD_PLAYER_2
	LD	IX, ROW22_BROD_INST
	LD	(IX + OFF_BROD_INST_BROD), E
	LD	(IX + OFF_BROD_INST_BROD + 1), D
	LD	IY, BROD_PLAYER_2
	LD	E, 22
	CALL	INSERT_BROD
	; disable sprite 2, 3 i 4
	LD	(IX + SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 0
	LD	(IX + 2*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 0
	LD	(IX + 3*SIZEOF_SPRITE + OFF_SPRITE_AKTIV_FLAG), 0
	; postavi sprite na sredinu ekrana
	LD	(IX + OFF_SPRITE_X), 116
	LD	(IX + OFF_SPRITE_X + 1), 0

	RET

; rutina za postavljanje sprite
; postavlja sve podatke
; prilagodjava x i y pravilima za lociranje u VDP-u
PUT_SPRITE_FULL:
	; prvo postavi adresu
	PUSH	HL
	SLA	A
	SLA	A
	LD	L, A
	LD	A, (GRPATR + 1)
	LD	H, A
	CALL	VRAM_POS
	POP	HL
	
	; postavi y_vdp = hw_sprite.y - 1
	LD	A, (HL)
	DEC	A
	INC	HL
	OUT	(&98), A

	; hw_sprite.x je 16-bit
	LD	E, (HL)
	INC	HL
	LD	D, (HL)
	INC	HL
	PUSH	HL

	BIT	7, D
	JR	Z, PUT_SPRITE_FULL_L0
	LD	HL, 15
	EX	DE, HL
	ADD	HL, DE
	BIT	7, H
	JR	NZ, PUT_SPRITE_FULL_L1 ; hw_sprite.x <= -16
	XOR	A
	SBC	HL, DE
	BIT	7, H
	JR	NZ, PUT_SPRITE_FULL_L2; 0 > hw_sprite.x > -16
PUT_SPRITE_FULL_L0:
	LD	A, D
	CP	1
	JR	NC, PUT_SPRITE_FULL_L1 ; hw_sprite.x >= 256
	; 0 <= hw_sprite.x <= 255
	LD	A, E
	LD	E, 0; EC flag
	JR	PUT_SPRITE_FULL_L3
PUT_SPRITE_FULL_L1:
	; postavi sprite van ekrana (-32)
	XOR	A
	LD	E, &80
	JR	PUT_SPRITE_FULL_L3
PUT_SPRITE_FULL_L2:
	LD	A, L
	ADD	A, 32
	LD	E, &80
PUT_SPRITE_FULL_L3:
	OUT	(&98), A
	POP	HL
	LD	A, (HL); pattern
	INC	HL
	OUT	(&98), A
	LD	A, (HL); color
	OR	E ; EC flag
	NOP
	OUT	(&98), A
	RET

; rutina za postavljanje spritea
; postavlja samo x
PUT_SPRITE_LITE_X:
	; prvo postavi adresu
	PUSH	HL
	SLA	A
	SLA	A
	INC	A
	LD	L, A
	LD	A, (GRPATR + 1)
	LD	H, A
	CALL	VRAM_POS
	POP	HL
	
	INC	HL
	; hw_sprite.x je 16-bit
	LD	A, (HL)
	OUT	(&98), A
	RET

; rutina za postavljanje spritea
; postavlja samo y
PUT_SPRITE_LITE_Y:
	; prvo postavi adresu
	PUSH	HL
	SLA	A
	SLA	A
	LD	L, A
	LD	A, (GRPATR + 1)
	LD	H, A
	CALL	VRAM_POS
	POP	HL
	
	LD	A, (HL)
	DEC	A
	OUT	(&98), A
	RET

; rutina za postavljanje spritea
; postavlja samo p
PUT_SPRITE_LITE_PATTERN:
	; prvo postavi adresu
	PUSH	HL
	SLA	A
	SLA	A
	INC	A
	INC	A
	LD	L, A
	LD	A, (GRPATR + 1)
	LD	H, A
	CALL	VRAM_POS
	POP	HL
	
	INC	HL
	INC	HL
	INC	HL
	LD	A, (HL)
	OUT	(&98), A
	RET

; rutina za izracun sprite patterna za napunjenost torpednih cijevi
; IX = ptr na L1 torpedo od playera
GET_TORPEDO_TUBES_SPRITE_PATTERN:
	LD	A, (IX + OFF_TORPEDO_STATUS)
	OR	(IX + SIZEOF_TORPEDO + OFF_TORPEDO_STATUS)
	AND	TORPEDO_STATUS_READY ; namjesteno na 1
	LD	L, A
	LD	A, (IX + 2*SIZEOF_TORPEDO + OFF_TORPEDO_STATUS)
	OR	(IX + 3*SIZEOF_TORPEDO + OFF_TORPEDO_STATUS)
	AND	TORPEDO_STATUS_READY ; namjesteno na 1
	LD	H, A

	OR	L
	; to =1 ako barem jedna torpedna cijev puna
	JR	NZ, GET_TORPEDO_TUBES_SPRITE_PATTERN_L1
	; obje prazne
	LD	A, PLAYER_BOTH_TORPEDO_TUBES_EMPTY
	RET
GET_TORPEDO_TUBES_SPRITE_PATTERN_L1:
	LD	A, L
	XOR	H
	; = 0 ako obje pune
	JR	Z, GET_TORPEDO_TUBES_SPRITE_PATTERN_L2
	LD	A, L
	OR	A
	; = 0 desni pun
	JR	Z, GET_TORPEDO_TUBES_SPRITE_PATTERN_L3
	; lijevi pun
	LD	A, PLAYER_LEFT_TORPEDO_TUBE_FULL
	RET
GET_TORPEDO_TUBES_SPRITE_PATTERN_L2:
	; obje cijevi pune
	LD	A, PLAYER_BOTH_TORPEDO_TUBES_FULL
	RET
GET_TORPEDO_TUBES_SPRITE_PATTERN_L3:
	; desna puna
	LD	A, PLAYER_RIGHT_TORPEDO_TUBE_FULL
	RET

; rutina za prebacivanje sprite patterna
INIT_VDPSPRITES:
	LD	HL, (GRPPAT)
	DI
	CALL	VRAM_POS
	EI

	LD	HL, HW_SPRITE_PATTERNS
	LD	B, TOTAL_HW_SPRITE_NUMBER
INIT_VDPSPRITES_L1:
	PUSH	BC
	LD	B, 32
	CALL	VRAM_BBYTE_COPY
	POP	BC
	DJNZ	INIT_VDPSPRITES_L1

	RET


; rutina za inicijalizaciju raznih struktura
; HW_SPRITES
; TORPEDOS
; ANIMACIJA_INST
INIT_MISC_STRUCTS:
	LD	IX, HW_SPRITE_TORPEDO_STATUS_PLAYER1
	LD	(IX + OFF_HW_SPRITE_Y), 187
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), PLAYER_BOTH_TORPEDO_TUBES_FULL
	LD	(IX + OFF_HW_SPRITE_COLOR), 15

	LD	IX, HW_SPRITE_TORPEDO_STATUS_PLAYER2
	LD	(IX + OFF_HW_SPRITE_Y), 179
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), PLAYER_BOTH_TORPEDO_TUBES_FULL
	LD	(IX + OFF_HW_SPRITE_COLOR), 15

	LD	IX, HW_SPRITE_TORPEDO_PLAYER1_L1
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 15

	LD	IX, HW_SPRITE_TORPEDO_PLAYER1_L2
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 15

	LD	IX, HW_SPRITE_TORPEDO_PLAYER1_R1
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 15

	LD	IX, HW_SPRITE_TORPEDO_PLAYER1_R2
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 15

	LD	IX, HW_SPRITE_TORPEDO_PLAYER2_L1
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 13

	LD	IX, HW_SPRITE_TORPEDO_PLAYER2_L2
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 13

	LD	IX, HW_SPRITE_TORPEDO_PLAYER2_R1
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 13

	LD	IX, HW_SPRITE_TORPEDO_PLAYER2_R2
	LD	(IX + OFF_HW_SPRITE_Y), HW_SPRITE_HIDE_Y
	LD	(IX + OFF_HW_SPRITE_X), 122 
	LD	(IX + OFF_HW_SPRITE_X + 1), 0
	LD	(IX + OFF_HW_SPRITE_PATTERN), TORPEDO_SPRITE_PATTERN
	LD	(IX + OFF_HW_SPRITE_COLOR), 13

	LD	A, TORPEDO_STATUS_READY
	LD	(PLAYER1_TORPEDO_L1 + OFF_TORPEDO_STATUS), A 
	LD	(PLAYER1_TORPEDO_L2 + OFF_TORPEDO_STATUS), A
	LD	(PLAYER1_TORPEDO_R1 + OFF_TORPEDO_STATUS), A
	LD	(PLAYER1_TORPEDO_R2 + OFF_TORPEDO_STATUS), A
	LD	(PLAYER2_TORPEDO_L1 + OFF_TORPEDO_STATUS), A
	LD	(PLAYER2_TORPEDO_L2 + OFF_TORPEDO_STATUS), A
	LD	(PLAYER2_TORPEDO_R1 + OFF_TORPEDO_STATUS), A
	LD	(PLAYER2_TORPEDO_R2 + OFF_TORPEDO_STATUS), A

	LD	A, HW_SPRITE_TORPEDO_PLAYER1_L1_INDEX
	LD	(PLAYER1_TORPEDO_L1 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER1_L2_INDEX
	LD	(PLAYER1_TORPEDO_L2 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER1_R1_INDEX
	LD	(PLAYER1_TORPEDO_R1 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER1_R2_INDEX
	LD	(PLAYER1_TORPEDO_R2 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER2_L1_INDEX
	LD	(PLAYER2_TORPEDO_L1 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER2_L2_INDEX
	LD	(PLAYER2_TORPEDO_L2 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER2_R1_INDEX
	LD	(PLAYER2_TORPEDO_R1 + OFF_TORPEDO_HW_SPRITE_INDEX), A
	LD	A, HW_SPRITE_TORPEDO_PLAYER2_R2_INDEX
	LD	(PLAYER2_TORPEDO_R2 + OFF_TORPEDO_HW_SPRITE_INDEX), A

	;LD	HL, ANIMACIJA_FLOATSOME_HIT
	LD	IX, ANIMACIJA_INST_PLAYER1_TORPEDO_L1
	LD	(IX + OFF_ANIMACIJA_INST_ACTIVE), 0
	LD	(IX + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER1_L1_INDEX
	;LD	(IX + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; L2
	LD	(IX + SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER1_L2_INDEX
	;LD	(IX + SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + 2*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; R1
	LD	(IX + 2*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER1_R1_INDEX
	;LD	(IX + 2*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + 2*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + 3*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; R2
	LD	(IX + 3*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER1_R2_INDEX
	;LD	(IX + 3*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + 3*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + 4*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; P2_L1
	LD	(IX + 4*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER2_L1_INDEX
	;LD	(IX + 4*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + 4*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + 5*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; P2_L2
	LD	(IX + 5*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER2_L2_INDEX
	;LD	(IX + 5*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + 5*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + 6*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; P2_R1
	LD	(IX + 6*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER2_R1_INDEX
	;LD	(IX + 6*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + 6*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H
	LD	(IX + 7*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), 0; P2_R2
	LD	(IX + 7*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), HW_SPRITE_TORPEDO_PLAYER2_R2_INDEX
	;LD	(IX + 7*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), L
	;LD	(IX + 7*SIZEOF_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA + 1), H

	; inicijaliziran strukture za high profile target i civilian target
	LD	HL, ANIMACIJA_HIGH_PROFILE_TARGET
	LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), HL
	LD	HL, ANIMACIJA_CIVILIAN_TARGET
	LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ANIMACIJA), HL
	LD	A, HIGH_PROFILE_TARGET_HW_SPRITE_INDEX
	LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), A
	LD	A, CIVILIAN_TARGET_HW_SPRITE_INDEX
	LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_HW_SPRITE_INDEX), A
	XOR	A
	LD	(HIGH_PROFILE_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(CIVILIAN_TARGET_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(MINA1_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(MINA2_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(OSTECENA_PODMORNICA1_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(OSTECENA_PODMORNICA2_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(MINA_POGODAK_MINUS_BODOVI_ANIMACIJA_INST + OFF_ANIMACIJA_INST_ACTIVE), A
	LD	(PLAYER1_DISABLED), A
	LD	(PLAYER2_DISABLED), A
	LD	(GAME_ENDED), A
	LD	(GAMETIMER_ENDED), A
	LD	(PAUSED), A
	LD	HL, 0
	LD	(HIGH_PROFILE_TARGET_INST), HL
	LD	(CIVILIAN_TARGET_INST), HL

	; inicijaliziraj score
	;LD	HL, 0
	LD	(PLAYER1_SCORE), HL
	LD	(PLAYER2_SCORE), HL
	LD	(LAST_SHOWN_GAME_TIME), HL
	;XOR	A
	;LD	(PLAYER1_SCORE_UPDATED), A
	;LD	(PLAYER2_SCORE_UPDATED), A
	LD	(PLAYER1_FIRE_PAUSE), A
	LD	(PLAYER2_FIRE_PAUSE), A

	RET

; rutina koja inicijalizira sve za samu partiju igranja
; ukljuci i IM 2
INIT_GAMEPLAY:
	CALL	DISSCR

	; podesi random paletu boja
	CALL	GET_RND_NUM
	LD	C, 3
	CALL	MODULO8BIT
	LD	HL, COLTBL
	OR	A
	JR	Z, INIT_GAMEPLAY_L0
	LD	DE, 7
	LD	B, A
INIT_GAMEPLAY_L2:
	ADD	HL, DE
	DJNZ	INIT_GAMEPLAY_L2
INIT_GAMEPLAY_L0:
	LD	(COLOR_SCHEME), HL
	; popuni prvih 8 znakova sa 0
	; jer nam pocetni ekran to promijeni
	; a treba za prazni znak i kako se definiraju boje
	XOR	A
	LD	HL, (GRPCGP)
	LD	BC, 64
	CALL	FILVRM
	XOR	A
	LD	HL, (GRPCGP)
	LD	BC, 2048
	ADD	HL, BC
	LD	BC, 64
	CALL	FILVRM
	XOR	A
	LD	HL, (GRPCGP)
	LD	BC, 4096
	ADD	HL, BC
	LD	BC, 64
	CALL	FILVRM
	; inicijaliziraj ROW strukture
	CALL	ROWx_INIT
	; popuni trecina ekrana strukture
	CALL	TRECINA_EKRANA_INIT
	; kreiraj boje i iscrtaj pozadinu
	CALL	INIT_PLAY_SCREEN
	; popuni ROW 16, 22 i 23 
	; tocnije ubaci playere i floatsome
	CALL	INIT_ROW_16_22_23
	; inicijaliziraj HW_SPRITE i TORPEDO strukture
	CALL	INIT_MISC_STRUCTS
	CALL	ENASCR

	;Initializes the music.
        LD	HL, MUSIC_GAMEPLAY
        XOR	A ;Subsong 0.
        CALL	PSG_PLAYER_INIT
	LD	HL, Sounds
	CALL	SOUNDS_PLAYER_INIT

	; nacrtaj playere 
	DI

	LD	A, (TWO_PLAYER_GAME)
	OR	A
	JR	Z, INIT_GAMEPLAY_L1
	LD	IX, ROW22_BROD_INST
	LD	IY, ROW22_BROD_INST + OFF_BROD_INST_SPRITE
	CALL 	DRAW_INST_SPRITE
	LD	A, HW_SPRITE_TORPEDO_STATUS_PLAYER2_INDEX
	LD	HL, HW_SPRITE_TORPEDO_STATUS_PLAYER2
	CALL	PUT_SPRITE_FULL
INIT_GAMEPLAY_L1:
	LD	IX, ROW23_BROD_INST
	LD	IY, ROW23_BROD_INST + OFF_BROD_INST_SPRITE
	CALL 	DRAW_INST_SPRITE
	LD	A, HW_SPRITE_TORPEDO_STATUS_PLAYER1_INDEX
	LD	HL, HW_SPRITE_TORPEDO_STATUS_PLAYER1
	CALL	PUT_SPRITE_FULL

	; resetiraj brojace vremena
	LD	HL, (JIFFY)
	LD	(TIME), HL
	XOR	A
	LD	(SEKUNDE), A
	LD	(SEKUNDE + 1), A

	;LD	IX, HTIMI
	;LD	HL, VBLANK
	;LD	(IX), &C3 ; JP instrukcija
	;LD	(IX + 1), L
	;LD	(IX + 2), H
	LD	A, INTRTBLHIADDR
	LD	I, A
	IM	2

	EI
	RET

; rutina gdje se sama partija odvija u petlji
; izlazi se kad istekne vrijeme ili pritisne CTRL+STOP
GAMEPLAY:
	CALL	CHECK_DRAW_INSTANCES
	CALL	CHECK_TORPEDO_HITS
	CALL	CHECK_DRAW_TIMER
	CALL	CHECK_MINE_COLLISIONS
	CALL	CHECK_FIRE_MINE
	CALL	CHECK_DRAW_SCORE

	HALT

	LD	A, (GAME_ENDED)
	OR	A
	JR	Z, GAMEPLAY

	DI
	IM	1
	EI

	LD	A, 1
	CALL	SOUNDS_PLAYER_STOP
	LD	A, 2
	CALL	SOUNDS_PLAYER_STOP
	CALL	PSG_PLAYER_STOP

	RET

; rutina za ispis slova pocetnom ekranu
; kopira punih 8 bajtova i radi invert po potrebi
; VRAM adresa mora biti postavljena
; ispisuje znakove 32-127, ostalo pretvara u blank (32)
; inverzno ispisuje ako bit 7 inputa = 1
; HL = ptr na font na znak ' '
; C = znak za ispis, bit 7 odredjuje inverzni ispis
DRAW_CHAR:
	LD	A, C
	AND	&7F
	SUB	' '
	JR	NC, DRAW_CHAR_L1
	XOR	A
DRAW_CHAR_L1:
	LD	E, A
	XOR	A
	SLA	E
	RLA
	SLA	E
	RLA
	SLA	E
	RLA
	LD	D, A
	ADD	HL, DE
	BIT	7, C
	JR	NZ, DRAW_CHAR_L2
	JP	VRAM_8BYTE_COPY
DRAW_CHAR_L2:
	LD	B, 8
DRAW_CHAR_L3:
	LD	A, (HL)
	XOR	&FF
	OUT	(&98), A
	INC	HL
	DJNZ	DRAW_CHAR_L3
	RET

; rutina ispisuje tekst string
; ocekuje se da je VRAM pos vec postavljen
; HL = tekst
; C = padding chr
; B = duljina
; E = offset
; ispisuje B znakova, ako je tekst kraci, ispisuje znak C
; svakom znaku dodaje E
WRITE_STRING:
	LD	A, (HL)
	OR	A
	JR	NZ, WRITE_STRING_1
	LD	A, C
	DEC	HL
WRITE_STRING_1:
	ADD	A, E
	PUSH	HL
	PUSH	DE
	PUSH	BC
	; uzimamo font iz ROM-a
	;LD	HL, (CGTABL)
	;LD	DE, 256
	;ADD	HL, DE
	LD	HL, Fonts
	LD	C, A
	CALL	DRAW_CHAR
	POP	BC
	POP	DE
	POP	HL
	INC	HL
	DJNZ	WRITE_STRING
	RET

; rutina ispisuje broj igraca na temelju TWO_PLAYER_GAME
WRITE_NUMBER_OF_PLAYERS:
	; pos (3, 10)
	LD	HL, (GRPCGP)
	LD	DE, 2584 ;10*256+3*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	LD	HL, MAINSCREEN_TEXT_PLAYER_NUMBER
	LD	A, (TWO_PLAYER_GAME)
	OR	A
	JR	Z, WRITE_NUMBER_OF_PLAYERS_L1
	INC	HL
WRITE_NUMBER_OF_PLAYERS_L1:
	LD	B, 1
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING
	EI
	RET

; rutina ispisuje input metodu
; potrebno prije toga podesiti VRAM pos
; A = input method
WRITE_INPUT_METHOD:
	CP	CTRL_JOY1
	JR	NZ, WRITE_INPUT_METHOD_L1
	LD	HL, MAINSCREEN_TEXT_INPUT_JOY_A
	JR	WRITE_INPUT_METHOD_L5
WRITE_INPUT_METHOD_L1:
	CP	CTRL_JOY2
	JR	NZ, WRITE_INPUT_METHOD_L2
	LD	HL, MAINSCREEN_TEXT_INPUT_JOY_B
	JR	WRITE_INPUT_METHOD_L5
WRITE_INPUT_METHOD_L2:
	CP	CTRL_CURSORS
	JR	NZ, WRITE_INPUT_METHOD_L3
	LD	HL, MAINSCREEN_TEXT_INPUT_CURSORS
	JR	WRITE_INPUT_METHOD_L5
WRITE_INPUT_METHOD_L3:
	CP	CTRL_ADCTRL
	JR	NZ, WRITE_INPUT_METHOD_L4
	LD	HL, MAINSCREEN_TEXT_INPUT_ADCTRL
	JR	WRITE_INPUT_METHOD_L5
WRITE_INPUT_METHOD_L4:
	LD	HL, MAINSCREEN_TEXT_INPUT_IPSHIFT
WRITE_INPUT_METHOD_L5:
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING
	RET

; rutina ispisuje input method za igraca 1
WRITE_INPUT_METHOD_PLAYER1:
	; pos (3, 13)
	LD	HL, (GRPCGP)
	LD	DE, 3352 ;13*256+3*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	A, (PLAYER1_INPUT)
	JP	WRITE_INPUT_METHOD

; rutina ispisuje input method za igraca 2
WRITE_INPUT_METHOD_PLAYER2:
	; pos (3, 16)
	LD	HL, (GRPCGP)
	LD	DE, 4120 ;16*256+3*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	A, (PLAYER2_INPUT)
	JP	WRITE_INPUT_METHOD
	
; rutina ispisuje duljinu trajanja igre
WRITE_GAME_DURATION:
	; pos (3, 19)
	LD	HL, (GRPCGP)
	LD	DE, 4888 ;19*256+3*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI

	LD	HL, (GAME_TIME)
	CALL	DIVIDE60
	CP	3
	JR	NZ, WRITE_GAME_DURATION_L1
	LD	HL, MAINSCREEN_TEXT_DURATION_5
	JR	WRITE_GAME_DURATION_L3
WRITE_GAME_DURATION_L1:
	CP	6
	JR	NZ, WRITE_GAME_DURATION_L2
	LD	HL, MAINSCREEN_TEXT_DURATION_10
	JR	WRITE_GAME_DURATION_L3
WRITE_GAME_DURATION_L2:
	LD	HL, MAINSCREEN_TEXT_DURATION_15
WRITE_GAME_DURATION_L3:
	LD	B, 1
	LD	E, 0
	CALL	WRITE_STRING
	RET

; rutina inicijalizira high score tabelu
INIT_HIGH_SCORE_TABLE:
	LD	A, (USE_SRAM_MODULE)
	OR	A
	JR	Z, INIT_HIGH_SCORE_TABLE_CLEAN
	; zelimo koristiti SRAM modul
	; provjeri da li postoji 'SC' header
	LD	HL, HBI55_BEGIN_ADDRESS
	CALL	HBI55_READ
	CP	'S'
	JR	NZ, INIT_HIGH_SCORE_TABLE_CLEAN
	INC	HL
	CALL	HBI55_READ
	CP	'C'
	JR	NZ, INIT_HIGH_SCORE_TABLE_CLEAN
	; imamo zapisan high score table od prije
	LD	B, 80
	INC	HL
	LD	IX, HIGH_SCORE_TABLE
INIT_HIGH_SCORE_TABLE_L1:
	CALL	HBI55_READ
	LD	(IX), A
	INC	IX
	INC	HL
	DJNZ	INIT_HIGH_SCORE_TABLE_L1
	RET
INIT_HIGH_SCORE_TABLE_CLEAN:
	LD	C, '.'
	LD	B, 10
	LD	DE, 8
	LD	IX, HIGH_SCORE_TABLE
INIT_HIGH_SCORE_TABLE_L2:
	LD	(IX), B
	LD	(IX + 1), 0
	LD	(IX + 2), C
	LD	(IX + 3), C
	LD	(IX + 4), C
	LD	(IX + 5), C
	LD	(IX + 6), C
	LD	(IX + 7), C
	ADD	IX, DE
	;INC	C
	DJNZ	INIT_HIGH_SCORE_TABLE_L2
	RET

EMPTY_STRING:
	DB	0
; rutina za ispis jednog retka high score tabele
; IX = ptr na redak u high score tabeli
; A = redak ekrana 1..10
PRINT_HIGH_SCORE_ENTRY:
	LD	L, (IX)
	LD	H, (IX + 1)
	PUSH	IX
	LD	IX, PLAYER1_DISPLAY ; P1<dvotocka>00000
	PUSH	AF
	CALL	PREPARE_SCORE
	POP	AF
	LD	HL, (GRPCGP)
	LD	DE, 2712 ;10*256+19*8 ; pos(19,10)
	ADD	HL, DE
	LD	DE, 256
	LD	B, A
PRINT_HIGH_SCORE_ENTRY_L1:
	ADD	HL, DE
	DJNZ	PRINT_HIGH_SCORE_ENTRY_L1
	;PUSH	HL
	DI
	CALL	VRAM_POS
	EI
	LD	B, 5
	LD	E, '0'-10
	PUSH	IX
	POP	HL
	INC	HL
	INC	HL
	INC	HL
	CALL	WRITE_STRING
	LD	HL, EMPTY_STRING
	LD	B, 1
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING
	;POP	HL
	;LD	DE, 6*8
	;ADD	HL, DE
	;DI
	;CALL	VRAM_POS
	;EI
	LD	B, 6
	LD	E, 0
	POP	HL
	INC	HL
	INC	HL
	CALL	WRITE_STRING
	LD	HL, EMPTY_STRING
	LD	B, 1
	LD	C, ' '
	LD	E, 0
	JP	WRITE_STRING

; rutina za ispis cijele high score tabele
PRINT_HIGH_SCORE_TABLE:
	LD	HL, (GRPCGP)
	LD	DE, 2448 ;9*256+18*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, MAINSCREEN_TEXT_HIGH_SCORES
	LD	B, 13
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING
	LD	HL, (GRPCGP)
	LD	DE, 2712 ;10*256+19*8 ; pos(19,10)
	ADD	HL, DE
	LD	BC, 96
	XOR	A
	CALL	FILVRM

	; posakrivaj sprajtove za slucaj
	; da dolazimo iz ispisanih
	; uputa o igri
	CALL	HIDE_ALL_HW_SPRITES

	LD	B, 10
	LD	DE, -8
	LD	IX, HIGH_SCORE_TABLE + 72
PRINT_HIGH_SCORE_TABLE_L1:
	PUSH	BC
	PUSH	DE
	PUSH	IX
	LD	A, B
	CALL	PRINT_HIGH_SCORE_ENTRY
	POP	IX
	POP	DE
	POP	BC
	ADD	IX, DE
	DJNZ	PRINT_HIGH_SCORE_TABLE_L1
	RET

TEXT_INSTR_0:
	DB	"INFO", 0
TEXT_INSTR_1:
	DB	"Sink ships", 0
TEXT_INSTR_2:
	DB	"except", 0
TEXT_INSTR_3:
	DB	"civilian", 0
TEXT_INSTR_4:
	DB	"High profile", 0
TEXT_INSTR_5:
	DB	"target", 0
TEXT_INSTR_6:
	DB	"is worth", 0
TEXT_INSTR_7:
	DB	"double", 0
TEXT_INSTR_8:
	DB	"Torpedoes", 0
TEXT_INSTR_9:
	DB	"take time to", 0
TEXT_INSTR_10:
	DB	"reload", 0
TEXT_INSTR_11:
	DB	"Avoid mines!", 0
; rutina za ispis instrukcija za igru
PRINT_GAME_INSTRUCTIONS:
	LD	HL, (GRPCGP)
	LD	DE, 2456 ;9*256+19*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_0
	LD	B, 12
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING

	LD	HL, (GRPCGP)
	LD	DE, 2712 ;10*256+19*8 ; pos(19,10)
	ADD	HL, DE
	PUSH	HL
	LD	DE, 256
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_1
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_2
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_3
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_4
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_5
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_6
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_7
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_8
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_9
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_10
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_INSTR_11
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	LD	A, 116
	LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_Y), A
	LD	HL, 29*8
	LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_X), HL
	LD	A, HIGH_PRIORITY_TARGET_PATTERN_1
	LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_PATTERN), A
	LD	A, 6
	LD	(HIGH_PROFILE_TARGET_HW_SPRITE + OFF_HW_SPRITE_COLOR), A
	LD	A, HIGH_PROFILE_TARGET_HW_SPRITE_INDEX
	LD	HL, HIGH_PROFILE_TARGET_HW_SPRITE
	DI
	CALL	PUT_SPRITE_FULL
	EI

	LD	A, 84
	LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_Y), A
	LD	HL, 29*8
	LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_X), HL
	LD	A, CIVILIAN_TARGET_PATTERN
	LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_PATTERN), A
	LD	A, 12
	LD	(CIVILIAN_TARGET_HW_SPRITE + OFF_HW_SPRITE_COLOR), A
	LD	A, CIVILIAN_TARGET_HW_SPRITE_INDEX
	LD	HL, CIVILIAN_TARGET_HW_SPRITE
	DI
	CALL	PUT_SPRITE_FULL
	EI

	RET

TEXT_CREDITS_0:
	DB	"CREDITS", 0
TEXT_CREDITS_1:
	DB	"Code &", 0
TEXT_CREDITS_2:
	DB	"Graphics:", 0
TEXT_CREDITS_3:
	DB	" Zoran", 0
TEXT_CREDITS_4:
	DB	" Majcenic", 0
TEXT_CREDITS_5:
	DB	"Music:", 0
TEXT_CREDITS_6:
	DB	" Fenyx Kell", 0
TEXT_CREDITS_7:
	DB	"Sound Player:", 0
TEXT_CREDITS_8:
	DB	" ArkosTracker", 0
TEXT_CREDITS_9:
	DB	"Fonts:", 0
TEXT_CREDITS_10:
	DB	" Damien Guard", 0
TEXT_CREDITS_11:
	DB	"Year 2020", 0
; rutina za ispis instrukcija za igru
PRINT_CREDITS:
	; posakrivaj sprajtove za slucaj
	; da dolazimo iz ispisanih
	; uputa o igri
	CALL	HIDE_ALL_HW_SPRITES

	LD	HL, (GRPCGP)
	LD	DE, 2456 ;9*256+19*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_0
	LD	B, 12
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING

	LD	HL, (GRPCGP)
	LD	DE, 2712 ;10*256+19*8 ; pos(19,10)
	ADD	HL, DE
	PUSH	HL
	LD	DE, 256
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_1
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_2
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_3
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_4
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_5
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_6
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_7
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_8
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_9
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	PUSH	HL
	PUSH	DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_10
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	POP	DE
	POP	HL
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_CREDITS_11
	LD	B, 13
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING

	RET

; pomocna rutina za postavljanje znakova 0-255 u sve trecine ekrana
SETNAMTBL0_255:
	LD	HL, (GRPNAM)
	DI
	CALL	VRAM_POS
	EI
	XOR	A
	LD	B, 3
SETNAMTBL0_255_L1:
	PUSH	BC
	LD	B, 0
SETNAMTBL0_255_L2:
	OUT	(&98), A
	INC	A
	DJNZ	SETNAMTBL0_255_L2
	POP	BC
	DJNZ	SETNAMTBL0_255_L1
	RET

; rutina inicijalizira pocetni ekran
; nacrta sliku podmornice u prvoj trecini
; ubaci fontove i ispise stalne elemente
INIT_MAIN_SCREEN:
	CALL	DISSCR

	CALL	SETNAMTBL0_255	
	
	; prebaci sliku podmornice
	LD	BC, 2048
	LD	DE, (GRPCGP)
	LD	HL, Main_screen_graphics
	CALL	LDIRVM
	; ostalo popuni sa 0
	XOR	A
	LD	BC, 2048
	LD	HL, (GRPCGP)
	ADD	HL, BC
	LD	BC, 4096
	CALL	FILVRM

	; ispuni boju podmornice sa gradijentom
	LD	HL, (GRPCOL)
	LD	BC, 768
	ADD	HL, BC
	DI
	CALL	VRAM_POS
	EI
	LD	B, 4
INIT_MAIN_SCREEN_2:
	LD	A, 7
	SUB	B
	CALL	GET_ROW_COLOR
	PUSH	BC
	LD	B, 32
INIT_MAIN_SCREEN_3:
	PUSH	HL
	CALL	VRAM_8BYTE_COPY
	POP	HL
	DJNZ	INIT_MAIN_SCREEN_3
	POP	BC
	DJNZ	INIT_MAIN_SCREEN_2
	; prvih 3 retka oboji u zuto (10)
	LD	A, &1A
	LD	HL, (GRPCOL)
	LD	BC, 768
	CALL	FILVRM
	; zatim 4 retka 11
	;LD	A, &1B
	;LD	BC, 768
	;LD	HL, (GRPCOL)
	;ADD	HL, BC
	;LD	BC, 1024
	;CALL	FILVRM
	; zadnji redak oboji u plavo
	LD	A, &15
	LD	BC, 1792
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 256
	CALL	FILVRM
	; oboji SUB u crveno
	LD	A, &6A
	LD	BC, 312
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 40
	CALL	FILVRM
	LD	A, &6A
	LD	BC, 568
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 40
	CALL	FILVRM
	; oboji COMMANDER
	LD	A, &FA
	LD	BC, 136
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 120
	CALL	FILVRM
	LD	A, &FA
	LD	BC, 392
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 120
	CALL	FILVRM
	LD	A, &FA
	LD	BC, 648
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 120
	CALL	FILVRM

	; ispuni boju sa &F1
	LD	A, &F1
	LD	BC, 2048
	LD	HL, (GRPCOL)
	ADD	HL, BC
	LD	BC, 4096
	CALL	FILVRM

	; ispisi tekstove
	; pos (0, 9), tekst number of players
	LD	HL, (GRPCGP)
	LD	DE, 2304 ;9*256
	PUSH	DE
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, MAINSCREEN_TEXT_NUM_PLAYERS
	LD	B, 17
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING
	; oboji u plavo
	LD	HL, (GRPCOL)
	POP	DE
	ADD	HL, DE
	LD	BC, 17*8
	LD	A, &41
	CALL	FILVRM 
	
	; pos (0, 12)
	LD	HL, (GRPCGP)
	LD	DE, 3072 ;12*256
	PUSH	DE
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, MAINSCREEN_TEXT_PLY1_INPUT
	LD	B, 17
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING
	; oboji u plavo
	LD	HL, (GRPCOL)
	POP	DE
	ADD	HL, DE
	LD	BC, 17*8
	LD	A, &41
	CALL	FILVRM 

	; pos (0, 15)
	LD	HL, (GRPCGP)
	LD	DE, 3840 ;15*256
	PUSH	DE
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, MAINSCREEN_TEXT_PLY2_INPUT
	LD	B, 17
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING
	; oboji u plavo
	LD	HL, (GRPCOL)
	POP	DE
	ADD	HL, DE
	LD	BC, 17*8
	LD	A, &41
	CALL	FILVRM 	

	; pos (0, 18)
	LD	HL, (GRPCGP)
	LD	DE, 4608 ;18*256
	PUSH	DE
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, MAINSCREEN_TEXT_DURATION
	LD	B, 17
	LD	C, ' '
	LD	E, 128
	CALL	WRITE_STRING
	; oboji u plavo
	LD	HL, (GRPCOL)
	POP	DE
	ADD	HL, DE
	LD	BC, 17*8
	LD	A, &41
	CALL	FILVRM 	

	; pos (0, 23)
	LD	HL, (GRPCGP)
	LD	DE, 5888 ;23*256
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	LD	HL, MAINSCREEN_TEXT_GO
	LD	B, 17
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING
	EI
	; pos (6, 19)
	LD	HL, (GRPCGP)
	LD	DE, 4912 ;19*256+6*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	LD	HL, MAINSCREEN_TEXT_DURATION_MIN
	LD	B, 3
	LD	C, ' '
	LD	E, 0
	CALL	WRITE_STRING
	EI
	
	; pos (25, 23)
	LD	HL, (GRPCGP)
	LD	DE, 6088 ;23*256+25*8
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	LD	HL, MAINSCREEN_TEXT_DURATION_IH
	LD	B, 7
	LD	E, 128
	CALL	WRITE_STRING
	EI

	; oboji u crveno dio gdje pise high score/instructions
	LD	HL, (GRPCOL)
	LD	DE, 2448 ;9*256+18*8
	ADD	HL, DE
	LD	BC, 13*8
	LD	A, &91
	CALL	FILVRM 

	CALL	WRITE_NUMBER_OF_PLAYERS
	CALL	WRITE_INPUT_METHOD_PLAYER1
	CALL	WRITE_INPUT_METHOD_PLAYER2
	CALL	WRITE_GAME_DURATION

	CALL	PRINT_HIGH_SCORE_TABLE

	CALL	ENASCR
	RET

; rutina za ubacivanje u high score tabelu
; HL = input score
; vraca CF=1 ako ubacen, a HL je ptr na lokaciju imena koje treba popuniti
UBACI_U_HIGH_SCORE_TABELU:
	LD	IX, HIGH_SCORE_TABLE
	LD	B, 10
	LD	C, 72
UBACI_U_HIGH_SCORE_TABELU_L1:
	LD	E, (IX)
	LD	D, (IX + 1)
	PUSH	HL
	XOR	A
	SBC	HL, DE
	POP	HL
	JR	C, UBACI_U_HIGH_SCORE_TABELU_L5
	JR	Z, UBACI_U_HIGH_SCORE_TABELU_L5
	; HL > DE
	; sad pomakni n-ti zapis na n+1-i
	DEC	B
	JR	Z, UBACI_U_HIGH_SCORE_TABELU_L4
	PUSH	HL
UBACI_U_HIGH_SCORE_TABELU_L3:
	PUSH	BC
	LD	D, 0
	LD	E, C
	PUSH	IX
	POP	HL
	ADD	HL, DE
	LD	BC, 8
	LD	E, L
	LD	D, H
	XOR	A
	SBC	HL, BC
	LDIR
	POP	BC
	LD	A, C
	SUB	8
	LD	C, A
	DJNZ	UBACI_U_HIGH_SCORE_TABELU_L3
	POP	HL
UBACI_U_HIGH_SCORE_TABELU_L4:
	LD	(IX), L
	LD	(IX + 1), H
	PUSH	IX
	POP	HL
	INC	HL
	INC	HL
	SCF
	RET
UBACI_U_HIGH_SCORE_TABELU_L5:
	LD	DE, 8
	ADD	IX, DE
	LD	A, C
	SUB	8
	LD	C, A
	DJNZ	UBACI_U_HIGH_SCORE_TABELU_L1
	SCF
	CCF
	RET

; rutina za unos imena, 6 slova
; HL = ptr na buf gdje ce se upisati rezultat
ENTER_HIGH_SCORE:
	PUSH	HL
	; napuni tmp buf sa 6x -, i ispisi
	LD	HL, ENTER_HIGH_SCORE_TMPBUF
	LD	B, 6
	LD	A, '-'
ENTER_HIGH_SCORE_L1:
	LD	(HL), A
	INC	HL
	DJNZ	ENTER_HIGH_SCORE_L1
	LD	HL, (GRPCGP)
	LD	DE, 3688; (13,14)
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	E, 0
	LD	B, 6
	LD	HL, ENTER_HIGH_SCORE_TMPBUF
	CALL	WRITE_STRING
	; sad isprazni tmp buf
	LD	HL, ENTER_HIGH_SCORE_TMPBUF
	LD	B, 6
	LD	A, ' '
ENTER_HIGH_SCORE_L2:
	LD	(HL), A
	INC	HL
	DJNZ	ENTER_HIGH_SCORE_L2
	LD	D, 0; pos gdje je kursor
	LD	IX, ENTER_HIGH_SCORE_TMPBUF
ENTER_HIGH_SCORE_L3:
	LD	A, D
	CP	6
	JR	NC, ENTER_HIGH_SCORE_L4
	; simuliraj kursor, upisom inverznog space
	LD	(IX), 128+' '
ENTER_HIGH_SCORE_L4:
	PUSH	DE
	LD	DE, 3432; (13,13)
	LD	HL, (GRPCGP)
	ADD	HL, DE
	POP	DE
	DI
	CALL	VRAM_POS
	EI
	LD	E, 0
	LD	B, 6
	LD	HL, ENTER_HIGH_SCORE_TMPBUF
	CALL	WRITE_STRING
ENTER_HIGH_SCORE_L5:
	CALL	CHGET
	CP	13
	JR	Z, ENTER_HIGH_SCORE_EXIT
	CP	8; backspace
	JR	NZ, ENTER_HIGH_SCORE_L6
	LD	A, D
	OR	A
	JR	Z, ENTER_HIGH_SCORE_L5
	LD	(IX), ' '
	DEC	D
	DEC	IX
	JR	ENTER_HIGH_SCORE_L3
ENTER_HIGH_SCORE_L6:
	LD	E, A
	LD	A, D
	CP	6
	JR	Z, ENTER_HIGH_SCORE_L5
	LD	(IX), E
	INC	IX
	INC	D
	JR	ENTER_HIGH_SCORE_L3
ENTER_HIGH_SCORE_EXIT:
	LD	A, D
	CP	6
	JR	Z, ENTER_HIGH_SCORE_EXIT_L1
	RES	7, (IX)
ENTER_HIGH_SCORE_EXIT_L1:
	LD	HL, ENTER_HIGH_SCORE_TMPBUF
	POP	DE
	LD	BC, 6
	LDIR
	RET

; rutina zapise cijelu high score tabelu u SRAM
WRITE_HIGH_SCORE_TABLE_TO_SRAM:
	; zapisi header SC
	LD	HL, HBI55_BEGIN_ADDRESS
	LD	C, 'S'
	CALL	HBI55_WRITE
	INC	HL
	LD	C, 'C'
	CALL	HBI55_WRITE
	LD	B, 80
	INC	HL
	LD	IX, HIGH_SCORE_TABLE
WRITE_HIGH_SCORE_TABLE_TO_SRAM_L1:
	LD	C, (IX)
	CALL	HBI55_WRITE
	INC	IX
	INC	HL
	DJNZ	WRITE_HIGH_SCORE_TABLE_TO_SRAM_L1
	RET

; rutina ispise high score achieved
; player x enter your initials
; A = player num -1
TEXT_NEW_HIGH_SCORE:
DB	" NEW HIGH SCORE ENTRY ACHIEVED! "
TEXT_ENTER_INITIALS:
DB	"PLAYER   ENTER YOUR INITIALS"
PRINT_ENTER_HIGH_SCORE_TEXT:
	PUSH	AF
	; prvo oboji u crveno
	LD	A, &61
	LD	HL, (GRPCOL)
	LD	DE, 2048; (0,8)
	ADD	HL, DE
	LD	BC, 256
	CALL	FILVRM
	; ispisi new high score entry
	LD	HL, (GRPCGP)
	LD	DE, 2048; (0,8)
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	B, 32
	LD	E, 128
	LD	HL, TEXT_NEW_HIGH_SCORE
	CALL	WRITE_STRING
	; ispisi player x enter your initials
	LD	HL, (GRPCGP)
	LD	DE, 2576; (2,10)
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	B, 28
	LD	E, 0
	LD	HL, TEXT_ENTER_INITIALS
	CALL	WRITE_STRING
	LD	HL, (GRPCGP)
	LD	DE, 2632; (9,10)
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	POP	AF
	LD	D, 0
	LD	E, A
	LD	HL, MAINSCREEN_TEXT_PLAYER_NUMBER
	ADD	HL, DE
	LD	B, 1
	LD	E, 0
	JP	WRITE_STRING

; rutina posakriva sve hw sprajtove
HIDE_ALL_HW_SPRITES:
	LD	B, 32
	LD	HL, (GRPATR)
	LD	DE, 4
HIDE_ALL_HW_SPRITES_L1:
	DI
	CALL	VRAM_POS
	LD	A, HW_SPRITE_HIDE_Y - 1
	OUT	(&98), A
	EI
	ADD	HL, DE
	DJNZ	HIDE_ALL_HW_SPRITES_L1
	RET

; poziva se preko H.TIMI
IM1_PSG_PLAYER:
	PUSH	AF
	CALL	PSG_PLAYER_PLAY
	POP	AF
	RET

ENABLE_IM1_PSG_PLAYER:
	LD	IX, HTIMI
	LD	HL, IM1_PSG_PLAYER
	DI
	LD	(IX), &C3 ; JP
	LD	(IX + 1), L
	LD	(IX + 2), H
	EI
	RET

DISABLE_IM1_PSG_PLAYER:
	LD	IX, HTIMI
	DI
	LD	(IX), &C9; RET
	EI
	RET

TEXT_GAMEPLAY_ENDED:
DB	" GAMEPLAY ENDED "
TEXT_NO_HIGH_SCORE:
DB	"NO HIGH SCORE ACHIEVED"
; rutina za kraj pojedine igre
; unos high score-a prema potrebi
GAMEPLAY_END:
	CALL	DISSCR
	CALL	HIDE_ALL_HW_SPRITES

	CALL	SETNAMTBL0_255
	; pobrisi sve definicije karaktera
	XOR	A
	LD	HL, (GRPCGP)
	LD	BC, 6144
	CALL	FILVRM
	; postavi boje na bijelo-crno
	LD	A, &F1
	LD	HL, (GRPCOL)
	LD	BC, 6144
	CALL	FILVRM
	; ispisi gameplay ended
	LD	HL, 1088; (8,4)
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_GAMEPLAY_ENDED
	LD	B, 16
	LD	E, 128
	CALL	WRITE_STRING

	; ispisi scoreove
	LD	IX, PLAYER1_DISPLAY
	LD	(IX), 'P'
	LD	(IX + 1), '1'
	LD	(IX + 2), ':'
	LD	IX, PLAYER2_DISPLAY
	LD	(IX), 'P'
	LD	(IX + 1), '2'
	LD	(IX + 2), ':'

	LD	HL, 5728; (12,22)
	DI
	CALL	VRAM_POS
	EI
	LD	HL, PLAYER1_DISPLAY
	LD	B, 3
	LD	E, 0
	CALL	WRITE_STRING
	LD	HL, PLAYER1_DISPLAY + 3
	LD	B, 5
	LD	E, '0'-10
	CALL	WRITE_STRING

	LD	HL, 5984; (12,23)
	DI
	CALL	VRAM_POS
	EI
	LD	HL, PLAYER2_DISPLAY
	LD	B, 3
	LD	E, 0
	CALL	WRITE_STRING
	LD	HL, PLAYER2_DISPLAY + 3
	LD	B, 5
	LD	E, '0'-10
	CALL	WRITE_STRING

	CALL	ENASCR
	; empty kbd buf
	LD	HL, (PUTPNT)
	LD	(GETPNT), HL
	
	; usporedi p1.score i p2.score
	LD	HL, (PLAYER1_SCORE)
	LD	DE, (PLAYER2_SCORE)
	XOR	A
	SBC	HL, DE
	JR	C, GAMEPLAY_END_P2SCORE_VECI
	LD	HL, (PLAYER1_SCORE)
	CALL	UBACI_U_HIGH_SCORE_TABELU
	JR	NC, GAMEPLAY_END_NEMA_HIGH_SCOREA
	PUSH	HL ; sacuvaj ptr na buffer
	; ubacen p1.score, input player name
	; pusti glazbu
	;CALL	PSG_PLAYER_STOP
        LD	HL, MUSIC_HIGHSCORE
        XOR	A ;Subsong 0.
        CALL	PSG_PLAYER_INIT
	CALL	ENABLE_IM1_PSG_PLAYER

	XOR	A; player 1
	CALL	PRINT_ENTER_HIGH_SCORE_TEXT
	POP	HL
	CALL	ENTER_HIGH_SCORE
	LD	HL, (PLAYER2_SCORE)
	CALL	UBACI_U_HIGH_SCORE_TABELU
	JR	NC, GAMEPLAY_END_SRAM
	; i p2 ima high score
	LD	A, 1
	PUSH	HL
	CALL	PRINT_ENTER_HIGH_SCORE_TEXT
	POP	HL
	CALL	ENTER_HIGH_SCORE
	JR	GAMEPLAY_END_SRAM
GAMEPLAY_END_P2SCORE_VECI:
	LD	HL, (PLAYER2_SCORE)
	CALL	UBACI_U_HIGH_SCORE_TABELU
	JR	NC, GAMEPLAY_END_NEMA_HIGH_SCOREA
	PUSH	HL; sacuvaj ptr na buffer
	; pusti glazbu
	;CALL	PSG_PLAYER_STOP
        LD	HL, MUSIC_HIGHSCORE
        XOR	A ;Subsong 0.
        CALL	PSG_PLAYER_INIT
	CALL	ENABLE_IM1_PSG_PLAYER

	; ubacen p1.score, input player name
	LD	A, 1; player 2
	CALL	PRINT_ENTER_HIGH_SCORE_TEXT
	POP	HL
	CALL	ENTER_HIGH_SCORE
	LD	HL, (PLAYER1_SCORE)
	CALL	UBACI_U_HIGH_SCORE_TABELU
	JR	NC, GAMEPLAY_END_SRAM
	; i p1 ima high score
	XOR	A
	PUSH	HL
	CALL	PRINT_ENTER_HIGH_SCORE_TEXT
	POP	HL
	CALL	ENTER_HIGH_SCORE
	JR	GAMEPLAY_END_SRAM
GAMEPLAY_END_NEMA_HIGH_SCOREA:
	LD	HL, (GRPCGP)
	LD	DE, 1576; (5, 6)
	ADD	HL, DE
	DI
	CALL	VRAM_POS
	EI
	LD	HL, TEXT_NO_HIGH_SCORE
	LD	B, 22
	LD	E, 0
	CALL	WRITE_STRING
	; cekamo key press ili 5s za povrat
	DI
	LD	HL, (JIFFY)
	LD	(GAMEPLAY_END_TIMER), HL
	EI
GAMEPLAY_END_L1:
	HALT
	CALL	CHSNS
	JR	NZ, GAMEPLAY_END_L2 ; pritisnut key, izadji
	LD	HL, (JIFFY)
	LD	DE, (GAMEPLAY_END_TIMER)
	XOR	A
	SBC	HL, DE
	LD	A, L
	CP	250
	JR	C, GAMEPLAY_END_L1
GAMEPLAY_END_L2:
	CALL	DISABLE_IM1_PSG_PLAYER
	CALL	PSG_PLAYER_STOP
	RET
GAMEPLAY_END_SRAM:
	CALL	DISABLE_IM1_PSG_PLAYER
	CALL	PSG_PLAYER_STOP
	LD	A, (USE_SRAM_MODULE)
	OR	A
	RET	Z
	JP	WRITE_HIGH_SCORE_TABLE_TO_SRAM

ifdef BuildROM
;--------------------------------------------------------
; Which slot address is the cartridge placed?
;  Return A = slot address
GTMSLT:
        CALL	RSLREG      ; read primary slot register
        RRCA                    ; move it to bit 0,1 of A
        RRCA
        AND     3       	; get bit 1,0
        LD      C,A             ; set primary slot No.
        LD      B,0
        LD      HL,EXPTBL       ; see if the slot is expanded or not
        ADD     HL,BC
        OR      (HL)            ; set MSB if so
        LD      C,A
        INC     HL              ; point to SLTTBL entry
        INC     HL
        INC     HL
        INC     HL
        LD      A,(HL)          ; get what is currently output to
                                ; expansion slot register

        AND     &0C       	; get bits 3,2
        OR      C               ; finally form slot address

        RET                     ; return to main
endif

;rutina detektira SRAM modul te prema potrebi pita da li ga koristiti
; postavlja varijablu USE_SRAM_MODULE
SRAM_MODULE_MSG:
DB "SRAM module detected, do you want to use it for storing high score table ? (Y/N) ", 0
SRAM_MODULE_INIT:
	LD	HL, 0
	CALL	HBI55_READ
	CP	&53
	JR	NZ, SRAM_MODULE_INIT_L4
	; provjeri da li vec postoji header SC
	; ako da koristi modul
	LD	HL, HBI55_BEGIN_ADDRESS
	CALL	HBI55_READ
	CP	'S'
	JR	NZ, SRAM_MODULE_INIT_L0
	INC	HL
	CALL	HBI55_READ
	CP	'C'
	JR	Z, SRAM_MODULE_INIT_L3
SRAM_MODULE_INIT_L0:
	; SCREEN 0
	LD	A, 0
	CALL	CHGMOD
	LD	HL, SRAM_MODULE_MSG
SRAM_MODULE_INIT_L1:
	LD	A, (HL)
	OR	A
	JR	Z, SRAM_MODULE_INIT_L2
	CALL	CHPUT
	INC	HL
	JR	SRAM_MODULE_INIT_L1
SRAM_MODULE_INIT_L2:
	CALL	CHGET
	CP	'Y'
	JR	Z, SRAM_MODULE_INIT_L3
	CP	'y'
	JR	Z, SRAM_MODULE_INIT_L3
SRAM_MODULE_INIT_L4:
	XOR	A
	LD	(USE_SRAM_MODULE), A
	RET
SRAM_MODULE_INIT_L3:
	LD	A, 1
	LD	(USE_SRAM_MODULE), A
	RET

; rutina samo ispise warning ako je stroj 60hz i pauzira 3 sekunde
NTSC_MSG:
DB "Please play on a", 13, 10, "PAL/50Hz machine", 13, 10, "for optimal experience....", 0
NTSC_CHECK:
	LD	A, (&002B)
	BIT	7, A
	RET	NZ

	; SCREEN 0
	LD	A, 0
	CALL	CHGMOD
	LD	HL, NTSC_MSG
NTSC_CHECK_L1:
	LD	A, (HL)
	OR	A
	JR	Z, NTSC_CHECK_L2
	CALL	CHPUT
	INC	HL
	JR	NTSC_CHECK_L1
NTSC_CHECK_L2:
	LD	DE, (JIFFY)
NTSC_CHECK_L3:
	LD	HL, (JIFFY)
	XOR	A
	SBC	HL, DE
	LD	A, L
	CP	180
	JR	C, NTSC_CHECK_L3
	RET

INIT:
ifdef BuildROM
	; aktiviraj page 2
	CALL	GTMSLT
	LD	H, &80
	CALL	ENASLT

	; copy music player to RAM
	LD	HL, Player_begin
	LD	DE, &C000
	LD	BC, Player_end - Player_begin
	LDIR
endif
	; pobrisi funkcijske tipke
	LD	HL, FNKSTR
	XOR	A
	LD	B, 160
INIT_L1:
	LD	(HL), A
	INC	HL
	DJNZ	INIT_L1
	; color 15,1,1
	LD	A, 15
	LD	(FORCLR), A
	LD	A, 1
	LD	(BAKCLR), A
	LD	(BDRCLR), A
	CALL	CHGCLR

	CALL	NTSC_CHECK
	CALL	SRAM_MODULE_INIT

	; SCREEN 2
	LD	A, 2
	CALL	CHGMOD
	; 16x16 sprites
	DI
	LD	A, (RG1SAV)
	OR	&2
	LD	(RG1SAV), A
	OUT	(&99), A
	LD	A, &81
	OUT	(&99), A	
	EI
	; disable key click
	XOR	A
	LD	(CLIKSW), A

ifndef BuildROM
	LD	HL, HEAPBEGIN
	LD	(HEAPPTR), HL
endif
	LD	HL, 0
	LD	(RNDPTR), HL

	CALL	INIT_HIGH_SCORE_TABLE

ifndef BuildROM
	; pripremi interrupt vektor tabelu
	LD	HL, INTRVECTORTBL
	LD	(HL), INTRROUTHIADDR
	LD	D, H
	LD	E, L
	INC	DE
	LD	BC, 256
	LDIR
	; zapisi JP VBLANK
	LD	IX, INTRVECTORROUT
	LD	HL, VBLANK
	LD	(IX), &C3 ; JP instrukcija
	LD	(IX + 1), L
	LD	(IX + 2), H
endif

	; ubaci sprajtove u VRAM
	CALL	INIT_VDPSPRITES

	; zapisi neki poceni instance id
	; samo da nije 255
	LD	A, 1
	LD	(UNIQUE_INST_ID), A
	; raspakiraj brodove i pomake
ifdef BuildDisk
	CALL	INIT_BRODOVI
endif


	; --- tu smo odradili inicijalizacije koje su nezavisne ---
	; sad ide ono sto se podesava na pocetnom ekranu
	XOR	A
	LD	(TWO_PLAYER_GAME), A
	LD	A, CTRL_CURSORS
	LD	(PLAYER1_INPUT), A
	LD	A, CTRL_IPSHIFT
	LD	(PLAYER2_INPUT), A
	LD	HL, 180
	LD	(GAME_TIME), HL

INIT_L3:
	; pocetna paleta boja
	LD	HL, COLTBL
	LD	(COLOR_SCHEME), HL
	; nacrtaj pocetni ekran
	CALL	INIT_MAIN_SCREEN
	; empty kbd buf
	LD	HL, (PUTPNT)
	LD	(GETPNT), HL
INIT_L4:
	; cekaj da se pritisne tipka
	HALT
	CALL	CHSNS
	JR	Z, INIT_L4
	CALL	CHGET
	CP	'A'
	CALL	Z, MAIN_SCREEN_CHG_PLAYER_NUM
	CP	'a'
	CALL	Z, MAIN_SCREEN_CHG_PLAYER_NUM
	CP	'B'
	CALL	Z, MAIN_SCREEN_CHG_PLAYER1_INPUT
	CP	'b'
	CALL	Z, MAIN_SCREEN_CHG_PLAYER1_INPUT
	CP	'C'
	CALL	Z, MAIN_SCREEN_CHG_PLAYER2_INPUT
	CP	'c'
	CALL	Z, MAIN_SCREEN_CHG_PLAYER2_INPUT
	CP	'D'
	CALL	Z, MAIN_SCREEN_CHG_DURATION
	CP	'd'
	CALL	Z, MAIN_SCREEN_CHG_DURATION
	CP	'I'
	CALL	Z, PRINT_GAME_INSTRUCTIONS
	CP	'i'
	CALL	Z, PRINT_GAME_INSTRUCTIONS
	CP	'H'
	CALL	Z, PRINT_HIGH_SCORE_TABLE
	CP	'h'
	CALL	Z, PRINT_HIGH_SCORE_TABLE
	CP	'K'
	CALL	Z, PRINT_CREDITS
	CP	'k'
	CALL	Z, PRINT_CREDITS
	CP	' '
	JR	NZ, INIT_L4

	; sad inicijalizacija same igre

	CALL	INIT_GAMEPLAY

	; igra
	CALL	GAMEPLAY

	CALL	GAMEPLAY_END

	JR	INIT_L3

; rutina za obradu kad se pritisne A na glavnom ekranu
; mijenja broj igraca
MAIN_SCREEN_CHG_PLAYER_NUM:
	PUSH	AF
	LD	A, (TWO_PLAYER_GAME)
	XOR	1
	LD	(TWO_PLAYER_GAME), A
	CALL	WRITE_NUMBER_OF_PLAYERS
	POP	AF
	RET

; rutina za obradu kad se pritisne B na glavnom ekranu
; mijenja input metodu za igraca 1
MAIN_SCREEN_CHG_PLAYER1_INPUT:
	PUSH	AF
	LD	A, (PLAYER1_INPUT)
	CP	CTRL_IPSHIFT
	JR	Z, MAIN_SCREEN_CHG_PLAYER1_INPUT_L1
	INC	A
	JR	MAIN_SCREEN_CHG_PLAYER1_INPUT_L2
MAIN_SCREEN_CHG_PLAYER1_INPUT_L1:
	XOR	A
MAIN_SCREEN_CHG_PLAYER1_INPUT_L2:
	LD	(PLAYER1_INPUT), A
	CALL	WRITE_INPUT_METHOD_PLAYER1
	POP	AF
	RET

; rutina za obradu kad se pritisne C na glavnom ekranu
; mijenja input metodu za igraca 2
MAIN_SCREEN_CHG_PLAYER2_INPUT:
	PUSH	AF
	LD	A, (PLAYER2_INPUT)
	CP	CTRL_IPSHIFT
	JR	Z, MAIN_SCREEN_CHG_PLAYER2_INPUT_L1
	INC	A
	JR	MAIN_SCREEN_CHG_PLAYER2_INPUT_L2
MAIN_SCREEN_CHG_PLAYER2_INPUT_L1:
	XOR	A
MAIN_SCREEN_CHG_PLAYER2_INPUT_L2:
	LD	(PLAYER2_INPUT), A
	CALL	WRITE_INPUT_METHOD_PLAYER2
	POP	AF
	RET

; rutina za obradu kad se pritisne D na glavnom ekranu
; mijenja trajanje igre
MAIN_SCREEN_CHG_DURATION:
	PUSH	AF
	LD	HL, (GAME_TIME)
	LD	DE, 180
	ADD	HL, DE
	LD	A, H
	CP	2
	JR	C, MAIN_SCREEN_CHG_DURATION_L1
	LD	A, L
	CP	&D0
	JR	C, MAIN_SCREEN_CHG_DURATION_L1
	; prekrdasili smo, postavi 180 s
	PUSH	DE
	POP	HL
MAIN_SCREEN_CHG_DURATION_L1:
	LD	(GAME_TIME), HL
	CALL	WRITE_GAME_DURATION
	POP	AF
	RET

ifdef BuildROM
Player_begin:
incbin "PSG.bin"
Player_end:

endif

MAINSCREEN_TEXT_NUM_PLAYERS:
DB	' ', 'A', " PLAYER NUMBER", 0
MAINSCREEN_TEXT_PLY1_INPUT:
DB	' ', 'B', " PLAYER 1 INPUT", 0
MAINSCREEN_TEXT_PLY2_INPUT:
DB	' ', 'C', " PLAYER 2 INPUT", 0
MAINSCREEN_TEXT_DURATION:
DB	' ', 'D', " GAME DURATION", 0
MAINSCREEN_TEXT_GO:
DB	' '+128, 'S'+128, 'P'+128, 'A'+128, 'C'+128, 'E'+128, ' '+128, " GO !", 0
MAINSCREEN_TEXT_HIGH_SCORES:
DB	" HIGH SCORES", 0
MAINSCREEN_TEXT_PLAYER_NUMBER:
DB	"12"
MAINSCREEN_TEXT_INPUT_JOY_A:
DB	"joystick A", 0
MAINSCREEN_TEXT_INPUT_JOY_B:
DB	"joystick B", 0
MAINSCREEN_TEXT_INPUT_CURSORS:
DB	"cursors/space", 0
MAINSCREEN_TEXT_INPUT_ADCTRL:
DB	"a,d/ctrl", 0
MAINSCREEN_TEXT_INPUT_IPSHIFT:
DB	"i,p/shift", 0
MAINSCREEN_TEXT_DURATION_5:
DB	"3"
MAINSCREEN_TEXT_DURATION_10:
DB	"6"
MAINSCREEN_TEXT_DURATION_15:
DB	"9"
MAINSCREEN_TEXT_DURATION_MIN:
DB	"min"
MAINSCREEN_TEXT_DURATION_IH:
DB	" I/H/K "

ifdef BuildROM
	align	16384
	incbin	"2nd_bank.bin"
	align	16384
endif

FileEnd:
	close

; za .BIN file
ifdef BuildDisk
	org &80F9

	;zapisi .BIN header
	;byte 0   ID byte #FE
	;byte 1+2 start-address
	;byte 3+4 end-address
	;byte 5+6 execution-address
	write "SUBCMDR.BIN"
	db &FE
	dw ROM_DATA_BEGIN 
	dw LoaderEnd
	dw LoaderStart

ROM_DATA_BEGIN:
	incbin "disk_version.bin"
ROM_DATA_END:
Player_begin:
	incbin "psg.bin"
Player_end:
Main_screen_graphics_begin:
incbin "SUBMARINE_INV.RAW"
Main_screen_graphics_end:

Fonts_begin:
incbin "Labyrinth.ch8"
Fonts_end:

PSG_begin:
incbin "psg_data.bin"
PSG_end:

LoaderBegin:
	read "Find_ram.asm"
LoaderStart:
	LD	C, &40
	LD	A, (RAMAD1); slot + expansion slot
	CP	&FF
	JR	Z, LoaderStart_L0
	OR	A
	JR	NZ, LoaderStart_L1
LoaderStart_L0:
	CALL	FIND_RAM
	JR	C, NO_MEMORY
LoaderStart_L1:
	LD	H, &40; page
	CALL	ENASLT

	; prebaci kod igre na mjesto
	LD	HL, ROM_DATA_BEGIN
	LD	DE, &4000
	LD	BC, ROM_DATA_END - ROM_DATA_BEGIN
	LDIR

	; prebaci zvukove
	LD	HL, PSG_begin
	LD	DE, MUSIC_GAMEPLAY
	LD	BC, PSG_end - PSG_begin
	LDIR

	; prebaci font na mjesto
	LD	HL, Fonts_begin
	LD	DE, Fonts
	LD	BC, 768
	LDIR	

	; prebaci sliku podmornice na mjesto
	LD	HL, Main_screen_graphics_begin
	LD	DE, Main_screen_graphics
	LD	BC, 2048
	LDIR

	; prebaci music player na mjesto
	LD	HL, Player_begin
	LD	DE, &C000
	LD	BC, Player_end - Player_begin
	LDIR

	JP	INIT
NO_MEMORY:
	LD	HL, NO_MEMORY_MSG
PUT_CHAR:
	LD	A, (HL)
	OR	A
	RET	Z
	CALL	CHPUT
	INC	HL
	JR	PUT_CHAR

NO_MEMORY_MSG:    
DB "Could not find RAM in page 1: &h4000-&h7FFF",13,10,0

LoaderEnd:
	close
	
endif

ROT_I1 EQU	&C000 + Player_end - Player_begin
ROT_O1 EQU	ROT_I1 + 2
ROT_X  EQU	ROT_O1 + 2
ROT_I2 EQU	ROT_X + 1
ROT_O2 EQU	ROT_I2 + 2
ROT_Y2 EQU	ROT_O2 + 2
ROT_EX EQU	ROT_Y2 + 1

RNDPTR EQU	ROT_EX + 2

; pozadinske boje redaka
ROWCOLBUF EQU	RNDPTR + 2 ; DB [24 * 8]

HEAPPTR	EQU	ROWCOLBUF + 192;

; struktura sprite
; struct
;	DW x;
OFF_SPRITE_X	EQU 0
;	DB y;
OFF_SPRITE_Y	EQU 2
;	DB aktiv_flag;
OFF_SPRITE_AKTIV_FLAG	EQU 3
;
SIZEOF_SPRITE	EQU	4

; struktura za instancu broda u trecini ekrana
; struct
;	DB id; unique id, 0 = not in use
OFF_BROD_INST_ID	EQU 0
;	DB row;
OFF_BROD_INST_ROW	EQU 1
;	DB DIM_X;
OFF_BROD_INST_DIM_X	EQU 2
;	DB DIM_Y;
OFF_BROD_INST_DIM_Y	EQU 3
;	DW SMJER;
OFF_BROD_INST_SMJER	EQU 4
;	DW *BROD;
OFF_BROD_INST_BROD	EQU 6
;	DW *ZNPTR[8]
OFF_BROD_INST_ZNPTR	EQU 8
;	DB ZNAKOVI[] = max((DIM_X+1)*DIM_Y*8-DIM_Y) = 110
OFF_BROD_INST_ZNAKOVI	EQU 24
;	struct SPRITE[4]
OFF_BROD_INST_SPRITE	EQU 134

SIZEOF_BROD_INST	EQU 150 ; OFF_BROD_INST_SPRITE + 4*SIZEOF_SPRITE

ROW2_BROD_INST	EQU HEAPPTR + 2
ROW5_BROD_INST	EQU ROW2_BROD_INST + SIZEOF_BROD_INST
ROW8_BROD_INST	EQU ROW5_BROD_INST + SIZEOF_BROD_INST
ROW10_BROD_INST	EQU ROW8_BROD_INST + SIZEOF_BROD_INST
ROW13_BROD_INST	EQU ROW10_BROD_INST + SIZEOF_BROD_INST
ROW16_BROD_INST	EQU ROW13_BROD_INST + SIZEOF_BROD_INST
ROW22_BROD_INST	EQU ROW16_BROD_INST + SIZEOF_BROD_INST
ROW23_BROD_INST	EQU ROW22_BROD_INST + SIZEOF_BROD_INST

UNIQUE_INST_ID	EQU ROW23_BROD_INST + SIZEOF_BROD_INST

; struct trecina_ekrana
; struct
;	DB numfree; dinamicka vrijednost broja ne zauzetih znakova
OFF_TRECINA_EKRANA_NUMFREE	EQU 0
;	DB free_start; koji je zapravo prvi znak sa kojim pocinjemo
OFF_TRECINA_EKRANA_FREE_START	EQU 1
;	DW vram_begin; pozicija u VRAM-u na free_start definiciju znaka
OFF_TRECINA_EKRANA_VRAM_BEGIN	EQU 2
;	usage { DB id; DB row }
OFF_TRECINA_EKRANA_USAGE	EQU 4
; SIZEOF ide po trecini

PRVA_TRECINA_EKRANA_NUM_FREE	EQU 248
PRVA_TRECINA_EKRANA_FREE_START	EQU 20
PRVA_TRECINA_EKRANA_VRAM_BEGIN	EQU 160 ; u init rutini dodamo offset
SIZEOF_PRVA_TRECINA_EKRANA	EQU OFF_TRECINA_EKRANA_USAGE + 496 ; PRVA_TRECINA_EKRANA_NUM_FREE * 2

PRVA_TRECINA_EKRANA EQU UNIQUE_INST_ID + 1

DRUGA_TRECINA_EKRANA_NUM_FREE	EQU 248
DRUGA_TRECINA_EKRANA_FREE_START	EQU 8
DRUGA_TRECINA_EKRANA_VRAM_BEGIN	EQU 2048 + 64 ; u init rutini dodamo offset
SIZEOF_DRUGA_TRECINA_EKRANA	EQU OFF_TRECINA_EKRANA_USAGE + 496 ; DRUGA_TRECINA_EKRANA_NUM_FREE * 2

DRUGA_TRECINA_EKRANA EQU PRVA_TRECINA_EKRANA + SIZEOF_PRVA_TRECINA_EKRANA

TRECA_TRECINA_EKRANA_NUM_FREE	EQU 248
TRECA_TRECINA_EKRANA_FREE_START	EQU 8
TRECA_TRECINA_EKRANA_VRAM_BEGIN	EQU 4096 + 64 ; u init rutini dodamo offset
SIZEOF_TRECA_TRECINA_EKRANA	EQU OFF_TRECINA_EKRANA_USAGE + 496 ; DRUGA_TRECINA_EKRANA_NUM_FREE * 2

TRECA_TRECINA_EKRANA EQU DRUGA_TRECINA_EKRANA + SIZEOF_DRUGA_TRECINA_EKRANA

; tmp buffer za izradu boje znaka
COL_GEN_BUF	EQU TRECA_TRECINA_EKRANA + SIZEOF_TRECA_TRECINA_EKRANA

TIME	EQU COL_GEN_BUF + 8

DIS_VRAM_POS	EQU TIME + 2
DIS_EMPTY_CHAR	EQU DIS_VRAM_POS + 2
DIS_DIM_X	EQU DIS_EMPTY_CHAR + 1
DIS_POMAK	EQU DIS_DIM_X + 1
DIS_TMPX	EQU DIS_POMAK + 1

SEKUNDE		EQU DIS_TMPX + 2

ROW2_SPEED	EQU SEKUNDE + 2
ROW5_SPEED	EQU ROW2_SPEED + 1
ROW8_SPEED	EQU ROW5_SPEED + 1
ROW10_SPEED	EQU ROW8_SPEED + 1
ROW13_SPEED	EQU ROW10_SPEED + 1

; metode za kontrolu podmornica
CTRL_JOY1	EQU 0
CTRL_JOY2	EQU 1
CTRL_CURSORS	EQU 2
CTRL_ADCTRL	EQU 3
CTRL_IPSHIFT	EQU 4

PLAYER1_INPUT	EQU ROW13_SPEED + 1
PLAYER2_INPUT	EQU PLAYER1_INPUT + 1
TWO_PLAYER_GAME	EQU PLAYER2_INPUT + 1

PAUSED		EQU TWO_PLAYER_GAME + 1
GAME_ENDED	EQU PAUSED + 1

; struct hw_sprite
; DB y
OFF_HW_SPRITE_Y		EQU 0
; DW x
OFF_HW_SPRITE_X		EQU 1
; DB pattern
OFF_HW_SPRITE_PATTERN	EQU 3
; DB color
OFF_HW_SPRITE_COLOR	EQU 4

SIZEOF_HW_SPRITE	EQU 5
; sprajtovi za playere da pokazu stanje napunjenosti torpednih cijevi
HW_SPRITE_TORPEDO_STATUS_PLAYER1_INDEX	EQU 0
HW_SPRITE_TORPEDO_STATUS_PLAYER1	EQU GAME_ENDED + 1
HW_SPRITE_TORPEDO_STATUS_PLAYER2_INDEX	EQU 1
HW_SPRITE_TORPEDO_STATUS_PLAYER2	EQU HW_SPRITE_TORPEDO_STATUS_PLAYER1 + SIZEOF_HW_SPRITE
; sprajtovi za sama torpeda
HW_SPRITE_TORPEDO_PLAYER1_L1_INDEX	EQU 2
HW_SPRITE_TORPEDO_PLAYER1_L1		EQU HW_SPRITE_TORPEDO_STATUS_PLAYER2 + SIZEOF_HW_SPRITE
HW_SPRITE_TORPEDO_PLAYER1_L2_INDEX	EQU 3
HW_SPRITE_TORPEDO_PLAYER1_L2		EQU HW_SPRITE_TORPEDO_PLAYER1_L1 + SIZEOF_HW_SPRITE
HW_SPRITE_TORPEDO_PLAYER1_R1_INDEX	EQU 4
HW_SPRITE_TORPEDO_PLAYER1_R1		EQU HW_SPRITE_TORPEDO_PLAYER1_L2 + SIZEOF_HW_SPRITE
HW_SPRITE_TORPEDO_PLAYER1_R2_INDEX	EQU 5
HW_SPRITE_TORPEDO_PLAYER1_R2		EQU HW_SPRITE_TORPEDO_PLAYER1_R1 + SIZEOF_HW_SPRITE

HW_SPRITE_TORPEDO_PLAYER2_L1_INDEX	EQU 6
HW_SPRITE_TORPEDO_PLAYER2_L1		EQU HW_SPRITE_TORPEDO_PLAYER1_R2 + SIZEOF_HW_SPRITE
HW_SPRITE_TORPEDO_PLAYER2_L2_INDEX	EQU 7
HW_SPRITE_TORPEDO_PLAYER2_L2		EQU HW_SPRITE_TORPEDO_PLAYER2_L1 + SIZEOF_HW_SPRITE
HW_SPRITE_TORPEDO_PLAYER2_R1_INDEX	EQU 8
HW_SPRITE_TORPEDO_PLAYER2_R1		EQU HW_SPRITE_TORPEDO_PLAYER2_L2 + SIZEOF_HW_SPRITE
HW_SPRITE_TORPEDO_PLAYER2_R2_INDEX	EQU 9
HW_SPRITE_TORPEDO_PLAYER2_R2		EQU HW_SPRITE_TORPEDO_PLAYER2_R1 + SIZEOF_HW_SPRITE
; pauza izmedju dva ispucavanja torpeda
FIRE_PAUSE		EQU 16
TORPEDO_RELOAD_TIME	EQU 150
PLAYER1_FIRE_PAUSE	EQU HW_SPRITE_TORPEDO_PLAYER2_R2 + SIZEOF_HW_SPRITE
PLAYER2_FIRE_PAUSE	EQU PLAYER1_FIRE_PAUSE + 1

; struct torpedo
; DB status
OFF_TORPEDO_STATUS		EQU 0
; DW begin_time
OFF_TORPEDO_BEGIN_TIME		EQU 1
; DB hw_sprite_index;
OFF_TORPEDO_HW_SPRITE_INDEX	EQU 3
; DB brzina
OFF_TORPEDO_BRZINA		EQU 4
; DW brzina_decimal
OFF_TORPEDO_BRZINA_DECIMAL	EQU 5

SIZEOF_TORPEDO		EQU 7

TORPEDO_STATUS_LOADING	EQU 0
TORPEDO_STATUS_READY	EQU 1
TORPEDO_STATUS_FIRED	EQU 2

PLAYER1_TORPEDO_L1	EQU PLAYER2_FIRE_PAUSE + 1
PLAYER1_TORPEDO_L2	EQU PLAYER1_TORPEDO_L1 + SIZEOF_TORPEDO
PLAYER1_TORPEDO_R1	EQU PLAYER1_TORPEDO_L2 + SIZEOF_TORPEDO
PLAYER1_TORPEDO_R2	EQU PLAYER1_TORPEDO_R1 + SIZEOF_TORPEDO
PLAYER2_TORPEDO_L1	EQU PLAYER1_TORPEDO_R2 + SIZEOF_TORPEDO
PLAYER2_TORPEDO_L2	EQU PLAYER2_TORPEDO_L1 + SIZEOF_TORPEDO
PLAYER2_TORPEDO_R1	EQU PLAYER2_TORPEDO_L2 + SIZEOF_TORPEDO
PLAYER2_TORPEDO_R2	EQU PLAYER2_TORPEDO_R1 + SIZEOF_TORPEDO

; pomocni bufferi za ispis scorea i vremena igre
; P1<dvotocka>00000
PLAYER1_DISPLAY		EQU PLAYER2_TORPEDO_R2 + SIZEOF_TORPEDO
; P2<dvotocka>00000
PLAYER2_DISPLAY		EQU PLAYER1_DISPLAY + 8
; 00<dvotocka>00
TIMER_DISPLAY		EQU PLAYER2_DISPLAY + 8

GAME_TIME		EQU TIMER_DISPLAY + 5
LAST_SHOWN_GAME_TIME	EQU GAME_TIME + 2

; struct animacija_inst
; DB active
OFF_ANIMACIJA_INST_ACTIVE		EQU 0
; DB curr_iter
OFF_ANIMACIJA_INST_CURR_ITER		EQU 1
; DW time
OFF_ANIMACIJA_INST_TIME			EQU 2
; DW *animacija
OFF_ANIMACIJA_INST_ANIMACIJA		EQU 4
; DB hw_sprite_index;
OFF_ANIMACIJA_INST_HW_SPRITE_INDEX	EQU 6

SIZEOF_ANIMACIJA_INST	EQU 7

ANIMACIJA_INST_PLAYER1_TORPEDO_L1	EQU LAST_SHOWN_GAME_TIME + 2
ANIMACIJA_INST_PLAYER1_TORPEDO_L2	EQU ANIMACIJA_INST_PLAYER1_TORPEDO_L1 + SIZEOF_ANIMACIJA_INST
ANIMACIJA_INST_PLAYER1_TORPEDO_R1	EQU ANIMACIJA_INST_PLAYER1_TORPEDO_L2 + SIZEOF_ANIMACIJA_INST
ANIMACIJA_INST_PLAYER1_TORPEDO_R2	EQU ANIMACIJA_INST_PLAYER1_TORPEDO_R1 + SIZEOF_ANIMACIJA_INST
ANIMACIJA_INST_PLAYER2_TORPEDO_L1	EQU ANIMACIJA_INST_PLAYER1_TORPEDO_R2 + SIZEOF_ANIMACIJA_INST
ANIMACIJA_INST_PLAYER2_TORPEDO_L2	EQU ANIMACIJA_INST_PLAYER2_TORPEDO_L1 + SIZEOF_ANIMACIJA_INST
ANIMACIJA_INST_PLAYER2_TORPEDO_R1	EQU ANIMACIJA_INST_PLAYER2_TORPEDO_L2 + SIZEOF_ANIMACIJA_INST
ANIMACIJA_INST_PLAYER2_TORPEDO_R2	EQU ANIMACIJA_INST_PLAYER2_TORPEDO_R1 + SIZEOF_ANIMACIJA_INST

PLAYER1_SCORE		EQU ANIMACIJA_INST_PLAYER2_TORPEDO_R2 + SIZEOF_ANIMACIJA_INST
PLAYER2_SCORE		EQU PLAYER1_SCORE + 2
PLAYER1_SCORE_UPDATED	EQU PLAYER2_SCORE + 2
PLAYER2_SCORE_UPDATED	EQU PLAYER1_SCORE_UPDATED + 1

HIGH_PROFILE_TARGET_INST		EQU PLAYER2_SCORE_UPDATED + 1
HIGH_PROFILE_TARGET_SPRITE		EQU HIGH_PROFILE_TARGET_INST + 2
CIVILIAN_TARGET_INST			EQU HIGH_PROFILE_TARGET_SPRITE + 2
CIVILIAN_TARGET_SPRITE			EQU CIVILIAN_TARGET_INST + 2
HIGH_PROFILE_TARGET_HW_SPRITE		EQU CIVILIAN_TARGET_SPRITE + 2
HIGH_PROFILE_TARGET_HW_SPRITE_INDEX	EQU 10
CIVILIAN_TARGET_HW_SPRITE		EQU HIGH_PROFILE_TARGET_HW_SPRITE + SIZEOF_HW_SPRITE
CIVILIAN_TARGET_HW_SPRITE_INDEX		EQU 11
HIGH_PROFILE_TARGET_ANIMACIJA_INST	EQU CIVILIAN_TARGET_HW_SPRITE + SIZEOF_HW_SPRITE
CIVILIAN_TARGET_ANIMACIJA_INST		EQU HIGH_PROFILE_TARGET_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST

MINA1_ANIMACIJA_INST			EQU CIVILIAN_TARGET_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST
MINA2_ANIMACIJA_INST			EQU MINA1_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST
MINA1_HW_SPRITE				EQU MINA2_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST
MINA1_HW_SPRITE_INDEX			EQU 12
MINA2_HW_SPRITE				EQU MINA1_HW_SPRITE + SIZEOF_HW_SPRITE
MINA2_HW_SPRITE_INDEX			EQU 13

PLAYER1_DISABLED			EQU MINA2_HW_SPRITE + SIZEOF_HW_SPRITE
PLAYER2_DISABLED			EQU PLAYER1_DISABLED + 1
PLAYER1_DISABLED_BEGIN_TIME		EQU PLAYER2_DISABLED + 1
PLAYER2_DISABLED_BEGIN_TIME		EQU PLAYER1_DISABLED_BEGIN_TIME + 2

OSTECENA_PODMORNICA1_HW_SPRITE		EQU PLAYER2_DISABLED_BEGIN_TIME + 2
OSTECENA_PODMORNICA1_HW_SPRITE_INDEX	EQU 14
OSTECENA_PODMORNICA2_HW_SPRITE		EQU OSTECENA_PODMORNICA1_HW_SPRITE + SIZEOF_HW_SPRITE
OSTECENA_PODMORNICA2_HW_SPRITE_INDEX	EQU 15
OSTECENA_PODMORNICA1_ANIMACIJA_INST	EQU OSTECENA_PODMORNICA2_HW_SPRITE + SIZEOF_HW_SPRITE
OSTECENA_PODMORNICA2_ANIMACIJA_INST	EQU OSTECENA_PODMORNICA1_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST

MINA_POGODAK_MINUS_BODOVI_HW_SPRITE_INDEX	EQU 16
MINA_POGODAK_MINUS_BODOVI_HW_SPRITE		EQU OSTECENA_PODMORNICA2_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST
MINA_POGODAK_MINUS_BODOVI_ANIMACIJA_INST	EQU MINA_POGODAK_MINUS_BODOVI_HW_SPRITE + SIZEOF_HW_SPRITE

HIGH_SCORE_TABLE			EQU MINA_POGODAK_MINUS_BODOVI_ANIMACIJA_INST + SIZEOF_ANIMACIJA_INST

USE_SRAM_MODULE				EQU HIGH_SCORE_TABLE + 80

ENTER_HIGH_SCORE_TMPBUF			EQU USE_SRAM_MODULE + 1

GAMEPLAY_END_TIMER			EQU ENTER_HIGH_SCORE_TMPBUF + 6

COLOR_SCHEME				EQU GAMEPLAY_END_TIMER + 2

GAMETIMER_ENDED				EQU COLOR_SCHEME + 2
GAMETIMER_ENDED_BEGIN_TIME		EQU GAMETIMER_ENDED + 1

;PLY_LW_Channel1_SoundEffectData		EQU GAMETIMER_ENDED_BEGIN_TIME + 2


