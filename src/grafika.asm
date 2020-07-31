; ***********
; * GRAFIKA *
; ***********

; brodovi u ROM-u su opisani u slijecoj strukturi
; struct {
;	DB DIM_X
;	DB DIM_Y
;	DB [DIM_X*8*DIM_Y] DATA
;	DB [DIM_Y*8] ROW_COLORS

TEST_BROD:
DB	6
DB	2
; data
DB	&00, &00, &00, &00, &07, &0D, &1F, &3F
DB	&00, &60, &70, &70, &FF, &B6, &FF, &FF
DB	&00, &C3, &C3, &E3, &FF, &DB, &FF, &FF
DB	&00, &06, &86, &87, &FF, &6D, &FF, &FF
DB	&00, &00, &00, &00, &F8, &B4, &FC, &FE
DB	&00, &00, &00, &00, &00, &00, &00, &00

DB	&3F, &FF, &FF, &7F, &7F, &1F, &1F, &07
DB	&FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
DB	&FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
DB	&FF, &FF, &FF, &FF, &FF, &FF, &FF, &FF
DB	&FE, &FF, &FF, &FF, &FF, &FF, &FE, &FE
DB	&90, &FC, &F0, &C0, &80, &00, &00, &00
; colour
DB	&10, &60, &10, &60, &F0, &E0, &F0, &F0
DB	&E0, &10, &60, &60, &60, &10, &10, &10

DESTROYER_1:
DB	6
DB	2
; data
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &01, &03
DB	&00, &40, &40, &00, &C0, &C1, &CB, &FF
DB	&00, &00, &60, &60, &E0, &E0, &F0, &FE
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00

DB	&00, &0F, &7F, &7F, &3F, &00, &00, &00
DB	&3F, &7F, &FF, &FF, &FF, &00, &00, &00
DB	&FF, &FF, &FF, &FF, &FF, &00, &00, &00
DB	&FE, &FF, &FF, &FF, &FF, &00, &00, &00
DB	&0E, &FF, &FF, &FF, &FF, &00, &00, &00
DB	&2E, &FE, &FC, &F8, &F0, &00, &00, &00
; color
DB	&10, &F0, &F0, &F0, &10, &F0, &F0, &F0
DB	&E0, &10, &60, &60, &60, &60, &60, &60

SAILSHIP_1:
DB	3
DB	3
; data
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &40, &08, &08, &0C, &26, &2F, &67
DB	&00, &00, &00, &00, &00, &00, &00, &80
DB	&00, &00, &00, &01, &03, &00, &3E, &3E
DB	&6F, &C7, &EF, &CF, &EF, &08, &08, &5F
DB	&C0, &E0, &E0, &F0, &40, &00, &0E, &FC
;DB	&3F, &0F, &03, &00, &00, &00, &00, &00
DB	&3F, &3F, &3F, &1F, &00, &00, &00, &00
DB	&FF, &FF, &FF, &FF, &00, &00, &00, &00
DB	&F8, &E0, &C0, &80, &00, &00, &00, &00
;DB	&F8, &F8, &F8, &F0, &00, &00, &00, &00
; color
DB	&10, &10, &F0, &F0, &F0, &F0, &E0, &F0
DB	&F0, &F0, &F0, &F0, &E0, &C0, &C0, &60
DB	&10, &10, &10, &10, &B0, &B0, &B0, &B0

SAILSHIP_2:
DB	3
DB	3
; data
DB	&00, &07, &1C, &18, &00, &00, &00, &00
DB	&00, &00, &00, &00, &87, &CF, &D8, &E0
DB	&00, &00, &00, &00, &00, &00, &00, &C0
DB	&01, &00, &01, &00, &00, &01, &00, &01
DB	&70, &70, &78, &7C, &7E, &7E, &7F, &7F
DB	&60, &70, &70, &78, &7C, &7E, &7E, &7F
DB	&00, &F0, &F9, &7F, &3F, &3F, &1F, &00
DB	&FC, &F8, &E0, &01, &FF, &FF, &FF, &00
DB	&7E, &7C, &E0, &FF, &FC, &F0, &E0, &00
; color
DB	&00, &90, &90, &90, &F0, &F0, &F0, &F0
DB	&F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
DB	&E0, &E0, &10, &10, &40, &50, &40, &00

PASSENGER_1:
DB	5
DB	2
; data
DB	&00, &00, &00, &00, &03, &07, &0E, &1F
DB	&00, &60, &60, &FE, &FF, &FF, &31, &FF
DB	&00, &00, &00, &3F, &FF, &FF, &8C, &FF
DB	&00, &00, &00, &F0, &FF, &FF, &63, &FF
DB	&00, &00, &00, &00, &00, &80, &80, &C0
DB	&3E, &3F, &7F, &76, &7F, &7F, &3F, &1F
DB	&31, &FF, &FF, &DB, &FF, &FF, &FF, &FF
DB	&8C, &FF, &FF, &6D, &FF, &FF, &FF, &FF
DB	&63, &FF, &FF, &B6, &FF, &FF, &FF, &FF
DB	&E0, &E0, &F0, &FF, &FE, &FC, &F8, &F0
; color
DB	&10, &10, &10, &E0, &F0, &F0, &F0, &E0
DB	&F0, &F0, &10, &F0, &60, &60, &60, &10

CARGOSHIP_1:
DB	5
DB	2
; data
DB	&10, &10, &30, &1F, &15, &1F, &17, &1F
DB	&00, &00, &C0, &80, &80, &81, &81, &81
DB	&00, &00, &00, &00, &00, &F7, &F7, &F7
DB	&00, &00, &00, &00, &00, &DF, &DF, &DF
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&1F, &9F, &FF, &FF, &D5, &FF, &7F, &3F
DB	&80, &81, &81, &FF, &FF, &FF, &FF, &FF
DB	&00, &F7, &F7, &FF, &FF, &FF, &FF, &FF
DB	&00, &DF, &DF, &FF, &FF, &FF, &FF, &FF
DB	&08, &08, &3E, &FC, &B8, &F0, &E0, &C0
; color
DB	&20, &E0, &E0, &E0, &E0, &F0, &F0, &F0
DB	&10, &60, &60, &40, &40, &50, &10, &60

BROJ_BRODOVA	EQU 6

FLOATSOME_1:
DB	4
DB	2
; data
DB	&FF, &00, &3F, &00, &3C, &00, &07, &00
DB	&FE, &00, &8F, &00, &FE, &00, &CF, &00
DB	&7F, &00, &F1, &00, &6C, &00, &9F, &00
DB	&FF, &00, &FC, &00, &E0, &00, &00, &00
DB	&01, &00, &00, &00, &00, &00, &00, &00
DB	&F3, &00, &3E, &00, &00, &00, &00, &00
DB	&E7, &00, &7C, &00, &00, &00, &00, &00
DB	&80, &00, &00, &00, &00, &00, &00, &00
; color
DB	&30, &30, &30, &30, &30, &30, &30, &30
DB	&30, &30, &30, &30, &30, &30, &30, &30

PLAYER_1:
DB	3
DB	1
; data
DB	&00, &00, &00, &9C, &BF, &FF, &BF, &80
DB	&10, &10, &1C, &FF, &FF, &FF, &FF, &FF
DB	&00, &00, &00, &CC, &FF, &FF, &FE, &FC
; color
DB	&60, &E0, &E0, &50, &50, &50, &40, &40

PLAYER_2:
DB	3
DB	1
; data
DB	&00, &00, &00, &9C, &BF, &FF, &BF, &80
DB	&10, &10, &1C, &FF, &FF, &FF, &FF, &FF
DB	&00, &00, &00, &CC, &FF, &FF, &FE, &FC
; color
DB	&20, &E0, &E0, &60, &60, &60, &80, &80

HW_SPRITE_PATTERNS:
; player obje torpedne cijevi pune
PLAYER_BOTH_TORPEDO_TUBES_FULL		EQU 0
DB	&C0, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&0C, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; player lijeva torpedna cijev puna
PLAYER_LEFT_TORPEDO_TUBE_FULL		EQU 4
DB	&C0, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; player desna torpedna cijev puna
PLAYER_RIGHT_TORPEDO_TUBE_FULL		EQU 8
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&0C, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; player obje cijevi prazne, zapravo prazan sprite
PLAYER_BOTH_TORPEDO_TUBES_EMPTY		EQU 12
BLANK_HW_SPRITE_PATTERN			EQU PLAYER_BOTH_TORPEDO_TUBES_EMPTY
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; torpedo
TORPEDO_SPRITE_PATTERN			EQU 16
DB	&C0, &C0, &C0, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; eksplozija u floatsome - najsira
EXPLOSION_FLOATSOME_PATTERN_1		EQU 20
DB	&00, &3F, &00, &FF, &00, &3F, &00, &0C
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &C0, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; eksplozija u floatsome - srednja
EXPLOSION_FLOATSOME_PATTERN_2		EQU 24
DB	&00, &1E, &00, &7F, &00, &1E, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &80, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; eksplozija u floatsome - najuza
EXPLOSION_FLOATSOME_PATTERN_3		EQU 28
DB	&00, &0C, &00, &1C, &00, &0C, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; eksplozija broda - najveca
EXPLOSION_BROD_PATTERN_1		EQU 32
DB	&82, &48, &29, &D5, &B5, &BC, &19, &1B
DB	&0F, &0D, &04, &07, &03, &02, &01, &00
DB	&21, &54, &5F, &45, &75, &FA, &6C, &6C
DB	&50, &58, &88, &F0, &D0, &B0, &E0, &00
; eksplozija broda - druga do najvece
EXPLOSION_BROD_PATTERN_2		EQU 36
DB	&00, &00, &00, &01, &04, &14, &09, &0F
DB	&25, &09, &07, &03, &13, &03, &03, &00
DB	&00, &00, &20, &00, &26, &AA, &88, &C8
DB	&D0, &B8, &B0, &12, &60, &40, &E0, &00
; eksplozija broda - druga do najmanje
EXPLOSION_BROD_PATTERN_3		EQU 40
DB	&00, &00, &00, &00, &00, &04, &00, &08
DB	&32, &09, &08, &24, &06, &05, &0F, &00
DB	&00, &00, &00, &00, &00, &00, &10, &40
DB	&08, &B8, &A8, &B0, &E0, &80, &E0, &00
; eksplozija broda - najmanja
EXPLOSION_BROD_PATTERN_4		EQU 44
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &02, &00, &05, &02, &07, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &90, &40, &30, &E0, &00
; oznaka za high priority target - najveca
HIGH_PRIORITY_TARGET_PATTERN_1		EQU 48
DB	&FF, &FF, &C0, &C0, &C0, &C0, &C0, &C0
DB	&C0, &C0, &C0, &C0, &C0, &C0, &FF, &FF
DB	&FF, &FF, &03, &03, &03, &03, &03, &03
DB	&03, &03, &03, &03, &03, &03, &FF, &FF
; oznaka za high priority target - srednja
HIGH_PRIORITY_TARGET_PATTERN_2		EQU 52
DB	&00, &00, &3F, &3F, &30, &30, &30, &30
DB	&30, &30, &30, &30, &3F, &3F, &00, &00
DB	&00, &00, &FC, &FC, &0C, &0C, &0C, &0C
DB	&0C, &0C, &0C, &0C, &FC, &FC, &00, &00
; oznaka za high priority target - najmanja
HIGH_PRIORITY_TARGET_PATTERN_3		EQU 56
DB	&00, &00, &00, &00, &0F, &0F, &0C, &0C
DB	&0C, &0C, &0F, &0F, &00, &00, &00, &00
DB	&00, &00, &00, &00, &F0, &F0, &30, &30
DB	&30, &30, &F0, &F0, &00, &00, &00, &00
; oznaka za civilian target
CIVILIAN_TARGET_PATTERN			EQU 60
DB	&07, &1F, &3F, &7C, &7E, &FF, &EF, &E7
DB	&E3, &E1, &E0, &70, &78, &3E, &1F, &07
DB	&E0, &F8, &FC, &1E, &0E, &07, &87, &C7
DB	&E7, &F7, &FF, &7E, &3E, &7C, &F8, &E0
; mina gore
MINA_PATTERN_1				EQU 64
DB	&60, &D0, &F0, &F0, &60, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; mina ulijevo
MINA_PATTERN_2				EQU 68
DB	&60, &D0, &E8, &78, &30, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; mina ravno
MINA_PATTERN_3				EQU 72
DB	&70, &E8, &F8, &70, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; mina udesno
MINA_PATTERN_4				EQU 76
DB	&30, &68, &F8, &F0, &60, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; eksplozija mine - najveca
EKSPLOZIJA_MINE_1			EQU 80
DB	&0B, &1F, &3E, &77, &FF, &BF, &37, &FF
DB	&FF, &BF, &7F, &FF, &BF, &4B, &34, &0F
DB	&F0, &EC, &FA, &7E, &ED, &FF, &FA, &FF
DB	&FF, &FF, &FD, &EE, &BE, &FC, &E8, &F0
; eksplozija mine - prva do najvece
EKSPLOZIJA_MINE_2			EQU 84
DB	&00, &03, &1C, &2A, &1F, &2D, &3B, &5F
DB	&1F, &5F, &2F, &25, &1A, &46, &08, &00
DB	&00, &40, &38, &74, &CA, &5A, &E4, &F6
DB	&FC, &D4, &EC, &C8, &30, &A4, &40, &00
; eksplozija mine - prva do najmanje
EKSPLOZIJA_MINE_3			EQU 88
DB	&00, &00, &00, &04, &01, &0B, &26, &0F
DB	&1D, &0F, &27, &05, &11, &00, &00, &00
DB	&00, &00, &00, &40, &10, &A0, &E8, &E0
DB	&70, &C8, &A0, &40, &10, &00, &00, &00
; eksplozija mine - najmanja
EKSPLOZIJA_MINE_4			EQU 92
DB	&00, &00, &00, &02, &01, &00, &09, &01
DB	&0B, &00, &04, &01, &00, &00, &00, &00
DB	&00, &00, &00, &00, &40, &00, &10, &80
DB	&A0, &80, &50, &00, &00, &00, &00, &00
; ostecena podmornica 1
OSTECENA_PODMORNICA_1			EQU 96
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &80, &01, &81, &82, &42, &04, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &80, &00, &00, &00
; ostecena podmornica 2
OSTECENA_PODMORNICA_2			EQU 100
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&80, &01, &00, &81, &82, &42, &04, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &80, &00, &00, &00
; ostecena podmornica 3
OSTECENA_PODMORNICA_3			EQU 104
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &01, &00, &80, &82, &42, &04, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &80, &00, &00, &00
; -999
BODOVI_MINUS_999			EQU 108
DB	&1D, &15, &DD, &04, &1D, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&DC, &54, &DC, &44, &DC, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; -500
BODOVI_MINUS_555			EQU 112
DB	&1D, &11, &DD, &04, &1D, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&DC, &10, &DC, &44, &DC, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
; x2
BODOVI_X2				EQU 116
DB	&AE, &A2, &4E, &A8, &AE, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00
DB	&00, &00, &00, &00, &00, &00, &00, &00

TOTAL_HW_SPRITE_NUMBER	EQU 30

; brojevi
BROJEVI_PATTERN:
DB	&00, &7F, &41, &5D, &41, &5F, &5F, &7F ; P
DB	&00, &7F, &7F, &77, &7F, &7F, &77, &7F ; dvotocka
DB	&00, &7F, &63, &59, &55, &4D, &63, &7F ; 0
DB	&00, &7F, &77, &47, &77, &77, &41, &7F ; 1
DB	&00, &7F, &43, &7D, &63, &5F, &41, &7F ; 2
DB	&00, &7F, &43, &7D, &63, &7D, &43, &7F ; 3
DB	&00, &7F, &73, &6B, &5B, &41, &7B, &7F ; 4
DB	&00, &7F, &41, &5F, &43, &7D, &43, &7F ; 5
DB	&00, &7F, &61, &5F, &41, &5D, &63, &7F ; 6
DB	&00, &7F, &41, &7D, &7B, &77, &77, &7F ; 7
DB	&00, &7F, &63, &5D, &63, &5D, &63, &7F ; 8
DB	&00, &7F, &63, &5D, &61, &7D, &43, &7F ; 9

; struct animacija {
; DB num_iter
OFF_ANIMACIJA_NUM_ITER	EQU 0
; DB loop;
OFF_ANIMACIJA_LOOP	EQU 1
; DB pause [num_iter]
OFF_ANIMACIJA_PAUSE	EQU 2
; DB pattern [num_iter]
; DB color [num_iter]

ANIMACIJA_FLOATSOME_HIT:
DB	6
DB	0
DB	7, 7, 7, 7, 7, 7
DB	EXPLOSION_FLOATSOME_PATTERN_1, EXPLOSION_FLOATSOME_PATTERN_2, EXPLOSION_FLOATSOME_PATTERN_1, EXPLOSION_FLOATSOME_PATTERN_2, EXPLOSION_FLOATSOME_PATTERN_2, EXPLOSION_FLOATSOME_PATTERN_3
DB	15, 11, 15, 11, 6, 6

ANIMACIJA_BROD_HIT:
DB	4
DB	0
DB	7, 7, 7, 7
DB	EXPLOSION_BROD_PATTERN_1, EXPLOSION_BROD_PATTERN_2, EXPLOSION_BROD_PATTERN_3, EXPLOSION_BROD_PATTERN_4
DB	15, 15, 15, 15

ANIMACIJA_HIGH_PROFILE_TARGET:
DB	4
DB	1
DB	8, 8, 8, 8
DB	HIGH_PRIORITY_TARGET_PATTERN_1, HIGH_PRIORITY_TARGET_PATTERN_2, HIGH_PRIORITY_TARGET_PATTERN_3, BLANK_HW_SPRITE_PATTERN
DB	6, 8, 9, 9

ANIMACIJA_CIVILIAN_TARGET:
DB	2
DB	1
DB	30, 20
DB	CIVILIAN_TARGET_PATTERN, BLANK_HW_SPRITE_PATTERN
DB	12, 12

MINA_ANIMACIJA:
DB	4
DB	1
DB	3, 3, 3, 3
DB	MINA_PATTERN_1, MINA_PATTERN_2, MINA_PATTERN_3, MINA_PATTERN_4
DB	13, 13, 13, 13

ANIMACIJA_EKSPLOZIJA_MINE:
DB	8
DB	0
DB	6, 6, 6, 6, 6, 6, 6, 6
DB	EKSPLOZIJA_MINE_1, EKSPLOZIJA_MINE_1, EKSPLOZIJA_MINE_2, EKSPLOZIJA_MINE_2, EKSPLOZIJA_MINE_3, EKSPLOZIJA_MINE_3, EKSPLOZIJA_MINE_4, EKSPLOZIJA_MINE_4
DB	15, 14, 15, 14, 14, 4, 4, 5 

ANIMACIJA_OSTECENA_PODMORNICA:
DB	3
DB	1
DB	10, 10, 10
DB	OSTECENA_PODMORNICA_1, OSTECENA_PODMORNICA_2, OSTECENA_PODMORNICA_3
DB	10, 10, 10

ANIMACIJA_MINA_POGODAK_MINUS_BODOVI:
DB	6
DB	0
DB	20, 20, 20, 20, 20, 20
DB	BODOVI_MINUS_555, BODOVI_MINUS_555, BODOVI_MINUS_555, BODOVI_MINUS_555, BODOVI_MINUS_555, BODOVI_MINUS_555
DB	15, 14, 10, 15, 14, 10

ANIMACIJA_MINUS_BODOVI_ZA_CIVILIAN_TARGET:
DB	6
DB	0
DB	20, 20, 20, 20, 20, 20
DB	BODOVI_MINUS_999, BODOVI_MINUS_999, BODOVI_MINUS_999, BODOVI_MINUS_999, BODOVI_MINUS_999, BODOVI_MINUS_999
DB	15, 1, 15, 1, 15, 1

ANIMACIJA_DUPLI_BODOVI:
DB	6
DB	0
DB	20, 20, 20, 20, 20, 20
DB	BODOVI_X2, BODOVI_X2, BODOVI_X2, BODOVI_X2, BODOVI_X2, BODOVI_X2
DB	15, 1, 15, 1, 15, 1
