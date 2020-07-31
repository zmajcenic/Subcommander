; stvori binarni oblik playera za izvodjenje iz RAM-a
; postavke rucno uskladjene iz _playerconfig fajlova

ORG	&C000

PLY_LW_MANAGE_SOUND_EFFECTS 		EQU 1

PLY_CFG_ConfigurationIsPresent		EQU 1
PLY_CFG_UseTranspositions 		EQU 1
PLY_CFG_UseEffects 			EQU 1
PLY_CFG_NoSoftNoHard 			EQU 1
PLY_CFG_SoftOnly 			EQU 1
PLY_CFG_SoftOnly_Noise 			EQU 1
PLY_CFG_SoftOnly_SoftwareArpeggio 	EQU 1
PLY_CFG_SoftOnly_SoftwarePitch		EQU 1
PLY_CFG_UseEffect_SetVolume 		EQU 1
PLY_CFG_SoftOnly_ForcedSoftwarePeriod	EQU 1


PLY_CFG_SFX_SoftOnly 			EQU 1
PLY_CFG_SFX_SoftOnly_Noise 		EQU 1

write "PSG.bin"

read "PlayerLightweight_MSX.asm"

close

MUSIC_PLAYER_INIT 	EQU PLY_LW_Init
MUSIC_PLAYER_PLAY 	EQU PLY_LW_Play
MUSIC_PLAYER_STOP 	EQU PLY_LW_Stop
SOUNDS_PLAYER_INIT   	EQU PLY_LW_InitSoundEffects
SOUNDS_PLAYER_PLAY   	EQU PLY_LW_PlaySoundEffect	
SOUNDS_PLAYER_STOP   	EQU PLY_LW_StopSoundEffectFromChannel