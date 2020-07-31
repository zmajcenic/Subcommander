;       Player of sound effects, for the Lightweight player.

        ;Is there a loaded Player Configuration source? If no, use a default configuration.
        IFNDEF PLY_CFG_ConfigurationIsPresent
		IFNDEF PLY_CFG_UseHardwareSounds
                	PLY_CFG_UseHardwareSounds EQU 1
		ENDIF
                PLY_CFG_SFX_LoopTo EQU 1
                PLY_CFG_SFX_NoSoftNoHard EQU 1
                PLY_CFG_SFX_NoSoftNoHard_Noise EQU 1
                PLY_CFG_SFX_SoftOnly EQU 1
                PLY_CFG_SFX_SoftOnly_Noise EQU 1
                PLY_CFG_SFX_HardOnly EQU 1
                PLY_CFG_SFX_HardOnly_Noise EQU 1
                PLY_CFG_SFX_HardOnly_Retrig EQU 1
                PLY_CFG_SFX_SoftAndHard EQU 1
                PLY_CFG_SFX_SoftAndHard_Noise EQU 1
                PLY_CFG_SFX_SoftAndHard_Retrig EQU 1
        ENDIF
        
;       Agglomerates some Player Configuration flags.
;       --------------------------------------------
;       Mixes the Hardware flags into one.
        IFDEF PLY_CFG_SFX_HardOnly
		ifndef PLY_LW_SE_HardwareSounds
                	PLY_LW_SE_HardwareSounds EQU 1
		endif
        ENDIF
        IFDEF PLY_CFG_SFX_SoftAndHard
		ifndef PLY_LW_SE_HardwareSounds
                	PLY_LW_SE_HardwareSounds EQU 1
		endif
        ENDIF
;       Mixes the Hardware Noise flags into one.
        IFDEF PLY_CFG_SFX_HardOnly_Noise
		ifndef PLY_LW_SE_HardwareNoise
                	PLY_LW_SE_HardwareNoise EQU 1
		endif
        ENDIF
        IFDEF PLY_CFG_SFX_SoftAndHard_Noise
		ifndef PLY_LW_SE_HardwareNoise
                	PLY_LW_SE_HardwareNoise EQU 1
		endif
        ENDIF
;       Mixes the Noise flags into one.
        IFDEF PLY_LW_SE_HardwareNoise
		ifndef PLY_LW_SE_Noise
                	PLY_LW_SE_Noise EQU 1
		endif
        ENDIF
        IFDEF PLY_CFG_SFX_NoSoftNoHard_Noise
		ifndef PLY_LW_SE_Noise
                	PLY_LW_SE_Noise EQU 1
		endif
        ENDIF
        IFDEF PLY_CFG_SFX_SoftOnly
		ifndef PLY_LW_SE_Noise
                	PLY_LW_SE_Noise EQU 1
		endif
        ENDIF
;       Noise in Sound Effects? Then noise register code must be compiled.
        IFDEF PLY_LW_SE_Noise
		ifndef PLY_LW_USE_NoiseRegister
                	PLY_LW_USE_NoiseRegister EQU 1
		endif
        ENDIF
;       Mixes the Software Volume flags into one.
        IFDEF PLY_CFG_SFX_NoSoftNoHard
		ifndef PLY_LW_SE_VolumeSoft
                	PLY_LW_SE_VolumeSoft EQU 1
		endif
		ifndef PLY_LW_SE_VolumeSoftOrHard
                	PLY_LW_SE_VolumeSoftOrHard EQU 1
		endif
        ENDIF
        IFDEF PLY_CFG_SFX_SoftOnly
		ifndef PLY_LW_SE_VolumeSoft
                	PLY_LW_SE_VolumeSoft EQU 1
		endif
		ifndef PLY_LW_SE_VolumeSoftOrHard
                	PLY_LW_SE_VolumeSoftOrHard EQU 1
		endif
        ENDIF
;       Mixes the volume (soft/hard) into one.
        IFDEF PLY_CFG_UseHardwareSounds
		ifndef PLY_LW_SE_VolumeSoftOrHard
                	PLY_LW_SE_VolumeSoftOrHard EQU 1
		endif
        ENDIF
;       Mixes the retrig flags into one.
        IFDEF PLY_CFG_SFX_HardOnly_Retrig
		ifndef PLY_LW_SE_Retrig
                	PLY_LW_SE_Retrig EQU 1
		endif
        ENDIF
        IFDEF PLY_CFG_SFX_SoftAndHard_Retrig
		ifndef PLY_LW_SE_Retrig
                	PLY_LW_SE_Retrig EQU 1
		endif
        ENDIF


;Initializes the sound effects. It MUST be called at any times before a first sound effect is triggered.
;It doesn't matter whether the song is playing or not, or if it has been initialized or not.
;IN    HL EQU Address to the sound effects data.
PLY_LW_InitSoundEffectsDisarkGenerateExternalLabel:
PLY_LW_InitSoundEffects:
        ld (PLY_LW_SE_PtSoundEffectTable + 1),hl
        ret


;Plays a sound effect. If a previous one was already playing on the same channel, it is replaced.
;This does not actually plays the sound effect, but programs its playing.
;The music player, when called, will call the PLY_LW_PlaySoundEffectsStream method below.
;IN    A EQU Sound effect number (>0!).
;       C EQU The channel where to play the sound effect (0, 1, 2).
;       B EQU Inverted volume (0 EQU full volume, 16 EQU no sound). Hardware sounds are also lowered.
PLY_LW_PlaySoundEffectDisarkGenerateExternalLabel:
PLY_LW_PlaySoundEffect:
        ;Gets the address to the sound effect.
        dec a                   ;The 0th is not encoded.
dknr3:
PLY_LW_SE_PtSoundEffectTable: ld hl,0
        ld e,a
        ld d,0
        add hl,de
        add hl,de
        ld e,(hl)
        inc hl
        ld d,(hl)
        ;Reads the header of the sound effect to get the speed.
        ld a,(de)
        inc de
        ex af,af'

        ld a,b

        ;Finds the pointer to the sound effect of the desired channel.
        ld hl,PLY_LW_Channel1_SoundEffectData
        ld b,0
        sla c
        sla c
        sla c
        add hl,bc
        ld (hl),e
        inc hl
        ld (hl),d
        inc hl        
        
        ;Now stores the inverted volume.
        ld (hl),a
        inc hl
        
        ;Resets the current speed, stores the instrument speed.
        ld (hl),0
        inc hl
        ex af,af'
        ld (hl),a
        
        ret

;Stops a sound effect. Nothing happens if there was no sound effect.
;IN    A EQU The channel where to stop the sound effect (0, 1, 2).
PLY_LW_StopSoundEffectFromChannelDisarkGenerateExternalLabel:
PLY_LW_StopSoundEffectFromChannel:
        ;Puts 0 to the pointer of the sound effect.
        add a,a
        add a,a
        add a,a
        ld e,a
        ld d,0
        ld hl,PLY_LW_Channel1_SoundEffectData
        add hl,de
        ld (hl),d               ;0 means "no sound".
        inc hl
        ld (hl),d
        ret

;Plays the sound effects, if any has been triggered by the user.
;This does not actually send registers to the PSG, it only overwrite the required values of the registers of the player.
;The sound effects initialization method must have been called before!
;As R7 is required, this must be called after the music has been played, but BEFORE the registers are sent to the PSG.
;IN    A EQU R7.
PLY_LW_PlaySoundEffectsStream:
        ;Shifts the R7 to the left twice, so that bit 2 and 5 only can be set for each track, below.
        rla
        rla

        ;Plays the sound effects on every track.
        ld ix,PLY_LW_Channel1_SoundEffectData
        ld iy,PLY_LW_Track1_Registers
        ld c,a
        call PLY_LW_PSES_Play
        ld ix,PLY_LW_Channel2_SoundEffectData
        ld iy,PLY_LW_Track2_Registers
        srl c                   ;Not RR, because we have to make sure the b6 is 0, else no more keyboard (on CPC)!
                                ;Also, on MSX, bit 6 must be 0.
        call PLY_LW_PSES_Play
        ld ix,PLY_LW_Channel3_SoundEffectData
        ld iy,PLY_LW_Track3_Registers
        IFDEF PLY_LW_HARDWARE_MSX
                scf             ;On MSX, bit 7 must be 1.
                rr c
        ELSE
                rr c            ;On other platforms, we don't care about b7.
        ENDIF
        call PLY_LW_PSES_Play

        ld a,c
        ld (PLY_LW_MixerRegister),a
        ret


;Plays the sound stream from the given pointer to the sound effect. If 0, no sound is played.
;The given R7 is given shift twice to the left, so that this code MUST set/reset the bit 2 (sound), and maybe reset bit 5 (noise).
;This code MUST overwrite these bits because sound effects have priority over the music.
;IN    IX EQU Points on the sound effect pointer. If the sound effect pointer is 0, nothing must be played.
;       IY EQU Points at the beginning of the register structure related to the channel.
;       C EQU R7, shifted twice to the left.
;OUT   The pointed pointer by IX may be modified as the sound advances.
;       C EQU R7, MUST be modified if there is a sound effect.
PLY_LW_PSES_Play:
        ;Reads the pointer pointed by IX.
        ld l,(ix + 0)
        ld h,(ix + 1)
        ld a,l
        or h
        ret z           ;No sound to be played? Returns immediately.

        ;Reads the first byte. What type of sound is it?
PLY_LW_PSES_ReadFirstByte:
        ld a,(hl)
        inc hl
        ld b,a
        rra
        jr c,PLY_LW_PSES_SoftwareOrSoftwareAndHardware
        rra
                        IFDEF PLY_CFG_SFX_HardOnly              ;CONFIG SPECIFIC
        jr c,PLY_LW_PSES_HardwareOnly
                        ENDIF ;PLY_CFG_SFX_HardOnly

        ;No software, no hardware, or end/loop.
        ;-------------------------------------------
        ;End or loop?
        rra
                        IFDEF PLY_CFG_SFX_NoSoftNoHard         ;CONFIG SPECIFIC. If not present, the jump is not needed, the method is just below.
        jr c,PLY_LW_PSES_S_EndOrLoop
                        
        ;No software, no hardware.
        ;-------------------------------------------
        ;Gets the volume.
        call PLY_LW_PSES_ManageVolumeFromA_Filter4Bits

        ;Noise?
                                IFDEF PLY_CFG_SFX_NoSoftNoHard_Noise                ;CONFIG SPECIFIC
        rl b
        call c,PLY_LW_PSES_ReadNoiseAndOpenNoiseChannel
                                ENDIF ;PLY_CFG_SFX_NoSoftNoHard_Noise

        jr PLY_LW_PSES_SavePointerAndExit
                        ENDIF ;PLY_CFG_SFX_NoSoftNoHard

        ;**Warning!** Do not put any instruction between EndOrLoop and NoSoftNoHard.

PLY_LW_PSES_S_EndOrLoop:
                        IFDEF PLY_CFG_SFX_LoopTo                ;CONFIG SPECIFIC. If no "loop to", the sounds always end, no need to test.
        ;Is it an end?
        rra
        jr c,PLY_LW_PSES_S_Loop
                        ENDIF ;PLY_CFG_SFX_LoopTo
        ;End of the sound. Marks the sound pointer with 0, meaning "no sound".
        xor a
        ld (ix + 0),a
        ld (ix + 1),a
        ret
                        IFDEF PLY_CFG_SFX_LoopTo                ;CONFIG SPECIFIC.
PLY_LW_PSES_S_Loop:
        ;Loops. Reads the pointer and directly uses it.
        ld a,(hl)
        inc hl
        ld h,(hl)
        ld l,a
        jr PLY_LW_PSES_ReadFirstByte
                        ENDIF ;PLY_CFG_SFX_LoopTo


;Saves HL into IX, and exits. This must be called at the end of each Cell.
;If the speed has not been reached, it is not saved.
PLY_LW_PSES_SavePointerAndExit:
        ;Speed reached?
        ld a,(ix + PLY_LW_SoundEffectData_OffsetCurrentStep)
        cp (ix + PLY_LW_SoundEffectData_OffsetSpeed)
        jr c,PLY_LW_PSES_NotReached
        ;The speed has been reached, so resets it and saves the pointer to the next cell to read.
        ld (ix + PLY_LW_SoundEffectData_OffsetCurrentStep),0
        ld (ix + 0),l
        ld (ix + 1),h
        ret
PLY_LW_PSES_NotReached:
        ;Speed not reached. Increases it, that's all. The same cell will be read next time.
        inc (ix + PLY_LW_SoundEffectData_OffsetCurrentStep)
        ret

                        IFDEF PLY_CFG_SFX_HardOnly         ;CONFIG SPECIFIC
        ;Hardware only.
        ;-------------------------------------------
PLY_LW_PSES_HardwareOnly:
        ;Calls the shared code that manages everything.
        call PLY_LW_PSES_Shared_ReadRetrigHardwareEnvPeriodNoise
        ;Cuts the sound.
        set 2,c

        jr PLY_LW_PSES_SavePointerAndExit
                        ENDIF ;PLY_CFG_SFX_HardOnly



PLY_LW_PSES_SoftwareOrSoftwareAndHardware:
        ;Software only?
        rra
                        IFDEF PLY_CFG_SFX_SoftAndHard         ;CONFIG SPECIFIC
        jr c,PLY_LW_PSES_SoftwareAndHardware
                        ENDIF ;PLY_CFG_SFX_SoftAndHard

        ;Software.
        ;-------------------------------------------
                        IFDEF PLY_CFG_SFX_SoftOnly          ;CONFIG SPECIFIC
        ;Volume.
        call PLY_LW_PSES_ManageVolumeFromA_Filter4Bits

        ;Noise?
        rl b
                                IFDEF PLY_CFG_SFX_SoftOnly_Noise                ;CONFIG SPECIFIC
        call c,PLY_LW_PSES_ReadNoiseAndOpenNoiseChannel
                                ENDIF ;PLY_CFG_SFX_SoftOnly_Noise

        ;Opens the "sound" channel.
        res 2,c

        ;Reads the software period.
        call PLY_LW_PSES_ReadSoftwarePeriod

        jr PLY_LW_PSES_SavePointerAndExit
                        ENDIF ;PLY_CFG_SFX_SoftOnly


        ;Software and Hardware.
        ;-------------------------------------------
                        IFDEF PLY_LW_SE_HardwareSounds         ;CONFIG SPECIFIC
PLY_LW_PSES_SoftwareAndHardware:
        ;Calls the shared code that manages everything.
        call PLY_LW_PSES_Shared_ReadRetrigHardwareEnvPeriodNoise

        ;Reads the software period.
        call PLY_LW_PSES_ReadSoftwarePeriod

        ;Opens the sound.
        res 2,c

        jr PLY_LW_PSES_SavePointerAndExit
                        ENDIF ;PLY_LW_SE_HardwareSounds


                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
        ;Shared code used by the "hardware only" and "software and hardware" part.
        ;Reads the Retrig flag, the Hardware Envelope, the possible noise, the hardware period,
        ;and sets the volume to 16. The R7 sound channel is NOT modified.
PLY_LW_PSES_Shared_ReadRetrigHardwareEnvPeriodNoise:
        ;Retrig?
        rra
                                IFDEF PLY_LW_SE_Retrig                  ;CONFIG SPECIFIC
        jr nc,PLY_LW_PSES_H_AfterRetrig
        ld d,a
        ld a,255
        ld (PLY_LW_SetReg13Old + 1),a
        ld a,d
PLY_LW_PSES_H_AfterRetrig:
                                ENDIF ;PLY_LW_SE_Retrig

        ;The hardware envelope can be set (8-15).
        and %111
        add a,8
        ld (PLY_LW_SetReg13 + 1),a

        ;Noise?
                                IFDEF PLY_LW_SE_HardwareNoise           ;CONFIG SPECIFIC. B not needed after, we can put it in the condition too.
        rl b
        call c,PLY_LW_PSES_ReadNoiseAndOpenNoiseChannel
                                ENDIF ;PLY_LW_SE_HardwareNoise

        ;Reads the hardware period.
        call PLY_LW_PSES_ReadHardwarePeriod

        ;Sets the volume to "hardware". It still may be decreased.
        ld a,16
        jp PLY_LW_PSES_ManageVolumeFromA_Hard
                        ENDIF ;PLY_CFG_UseHardwareSounds


                        IFDEF PLY_LW_SE_Noise
;Reads the noise pointed by HL, increases HL, and opens the noise channel.
PLY_LW_PSES_ReadNoiseAndOpenNoiseChannel:
        ;Reads the noise.
        ld a,(hl)
        ld (PLY_LW_NoiseRegister),a
        inc hl

        ;Opens noise channel.
        res 5,c
        ret
                        ENDIF ;PLY_LW_SE_Noise

                        IFDEF PLY_CFG_UseHardwareSounds         ;CONFIG SPECIFIC
;Reads the hardware period from HL and sets the R11/R12 registers. HL is incremented of 2.
PLY_LW_PSES_ReadHardwarePeriod:
        ld a,(hl)
        ld (PLY_LW_Reg11),a
        inc hl
        ld a,(hl)
        ld (PLY_LW_Reg12),a
        inc hl
        ret
                        ENDIF ;PLY_CFG_UseHardwareSounds

;Reads the software period from HL and sets the period registers thanks to IY. HL is incremented of 2.
PLY_LW_PSES_ReadSoftwarePeriod:
        ld a,(hl)
        ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodLSB),a
        inc hl
        ld a,(hl)
        ld (iy + PLY_LW_Registers_OffsetSoftwarePeriodMSB),a
        inc hl
        ret

                        IFDEF PLY_LW_SE_VolumeSoft      ;CONFIG SPECIFIC
;Reads the volume in A, decreases it from the inverted volume of the channel, and sets the volume via IY.
;IN    A EQU volume, from 0 to 15 (no hardware envelope).
PLY_LW_PSES_ManageVolumeFromA_Filter4Bits:
        and %1111
                        ENDIF ;PLY_LW_SE_VolumeSoft
                        IFDEF PLY_LW_SE_VolumeSoftOrHard        ;CONFIG SPECIFIC
;After the filtering. Useful for hardware sound (volume has been forced to 16).
PLY_LW_PSES_ManageVolumeFromA_Hard:
        ;Decreases the volume, checks the limit.
        sub (ix + PLY_LW_SoundEffectData_OffsetInvertedVolume)
        jr nc,PLY_LW_PSES_MVFA_NoOverflow
        xor a
PLY_LW_PSES_MVFA_NoOverflow:
        ld (iy + PLY_LW_Registers_OffsetVolume),a
        ret
                        ENDIF ;PLY_LW_SE_VolumeSoftOrHard


;The data of the Channels MUST be consecutive.
PLY_LW_Channel1_SoundEffectData:
;dkws
        dw 0                                            ;Points to the sound effect for the track 1, or 0 if not playing.
PLY_LW_Channel1_SoundEffectInvertedVolume:
;dkwe
;dkbs
        db 0                                            ;Inverted volume.
PLY_LW_Channel1_SoundEffectCurrentStep:
        db 0                                            ;Current step (>EQU0).
PLY_LW_Channel1_SoundEffectSpeed:
        db 0                                            ;Speed (>EQU0).
        ds 3,0                                          ;Padding.
;dkbe
PLY_LW_Channel_SoundEffectDataSize equ $ - PLY_LW_Channel1_SoundEffectData
        
;dkbs
PLY_LW_Channel2_SoundEffectData:
        ds PLY_LW_Channel_SoundEffectDataSize, 0
PLY_LW_Channel3_SoundEffectData:
        ds PLY_LW_Channel_SoundEffectDataSize, 0
;dkbe

;Offset from the beginning of the data, to reach the inverted volume.
PLY_LW_SoundEffectData_OffsetInvertedVolume equ PLY_LW_Channel1_SoundEffectInvertedVolume - PLY_LW_Channel1_SoundEffectData
PLY_LW_SoundEffectData_OffsetCurrentStep equ PLY_LW_Channel1_SoundEffectCurrentStep - PLY_LW_Channel1_SoundEffectData
PLY_LW_SoundEffectData_OffsetSpeed equ PLY_LW_Channel1_SoundEffectSpeed - PLY_LW_Channel1_SoundEffectData

        ;Checks that the pointers are consecutive.
        ;assert (PLY_LW_Channel1_SoundEffectData + PLY_LW_Channel_SoundEffectDataSize) EQUEQU PLY_LW_Channel2_SoundEffectData
        ;assert (PLY_LW_Channel2_SoundEffectData + PLY_LW_Channel_SoundEffectDataSize) EQUEQU PLY_LW_Channel3_SoundEffectData

