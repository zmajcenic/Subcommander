; Song Untitled in Lightweight format (V1).
; Generated by Arkos Tracker 2.


highscore_Start
highscore_StartDisarkGenerateExternalLabel

highscore_DisarkByteRegionStart0
	db "ATLW"	; Format marker (LightWeight).
	db 1	; Format version.
highscore_DisarkByteRegionEnd0
highscore_DisarkPointerRegionStart1
	dw highscore_FmInstrumentTable
	dw highscore_ArpeggioTable
	dw highscore_PitchTable
; Table of the Subsongs.
	dw highscore_Subsong0
highscore_DisarkPointerRegionEnd1

; The Arpeggio table.
highscore_ArpeggioTable
highscore_DisarkWordRegionStart2
	dw 0
highscore_DisarkWordRegionEnd2
highscore_DisarkPointerRegionStart3
highscore_DisarkPointerRegionEnd3

; The Pitch table.
highscore_PitchTable
highscore_DisarkWordRegionStart4
	dw 0
highscore_DisarkWordRegionEnd4
highscore_DisarkPointerRegionStart5
highscore_DisarkPointerRegionEnd5

; The FM Instrument table.
highscore_FmInstrumentTable
highscore_DisarkPointerRegionStart6
	dw highscore_FmInstrument0
	dw highscore_FmInstrument1
	dw highscore_FmInstrument2
	dw highscore_FmInstrument3
	dw highscore_FmInstrument4
	dw highscore_FmInstrument5
	dw highscore_FmInstrument6
	dw highscore_FmInstrument7
	dw highscore_FmInstrument8
	dw highscore_FmInstrument9
highscore_DisarkPointerRegionEnd6

highscore_DisarkByteRegionStart7
highscore_FmInstrument0
	db 255	; Speed.

highscore_FmInstrument0Loop	db 0	; Volume 0.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart8
	dw highscore_FmInstrument0Loop	; Loops.
highscore_DisarkPointerRegionEnd8

highscore_FmInstrument1
	db 0	; Speed.

	db 189	; Volume 15.
	db 25	; Arpeggio 12.
	db 6	; Noise 6.

	db 189	; Volume 15.
	db 20	; Arpeggio 10.

	db 181	; Volume 13.
	db 18	; Arpeggio 9.

	db 181	; Volume 13.
	db 16	; Arpeggio 8.

	db 173	; Volume 11.
	db 10	; Arpeggio 5.

	db 173	; Volume 11.
	db 8	; Arpeggio 4.

	db 165	; Volume 9.
	db 6	; Arpeggio 3.

	db 157	; Volume 7.
	db 4	; Arpeggio 2.

	db 157	; Volume 7.
	db 2	; Arpeggio 1.

	db 153	; Volume 6.
	db 2	; Arpeggio 1.

	db 25	; Volume 6.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart9
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd9

highscore_FmInstrument2
	db 0	; Speed.

	db 61	; Volume 15.

	db 125	; Volume 15.
	dw -1	; Pitch -1.

	db 57	; Volume 14.

	db 121	; Volume 14.
	dw 1	; Pitch 1.

	db 53	; Volume 13.

	db 117	; Volume 13.
	dw -1	; Pitch -1.

	db 49	; Volume 12.

	db 113	; Volume 12.
	dw 1	; Pitch 1.

	db 45	; Volume 11.

	db 109	; Volume 11.
	dw -1	; Pitch -1.

	db 41	; Volume 10.

	db 105	; Volume 10.
	dw 1	; Pitch 1.

	db 37	; Volume 9.

	db 101	; Volume 9.
	dw -1	; Pitch -1.

	db 33	; Volume 8.

	db 93	; Volume 7.
	dw 1	; Pitch 1.

	db 25	; Volume 6.

	db 85	; Volume 5.
	dw -1	; Pitch -1.

	db 17	; Volume 4.

	db 77	; Volume 3.
	dw 1	; Pitch 1.

	db 9	; Volume 2.

	db 69	; Volume 1.
	dw -1	; Pitch -1.

	db 0	; Volume 0.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart10
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd10

highscore_FmInstrument3
	db 0	; Speed.

	db 189	; Volume 15.
	db 27	; Arpeggio 13.
	db 9	; Noise 9.

	db 189	; Volume 15.
	db 18	; Arpeggio 9.

	db 189	; Volume 15.
	db 12	; Arpeggio 6.

	db 181	; Volume 13.
	db 9	; Arpeggio 4.
	db 5	; Noise 5.

	db 173	; Volume 11.
	db 5	; Arpeggio 2.
	db 5	; Noise 5.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart11
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd11

highscore_FmInstrument4
	db 0	; Speed.

	db 189	; Volume 15.
	db 25	; Arpeggio 12.
	db 11	; Noise 11.

	db 185	; Volume 14.
	db 27	; Arpeggio 13.
	db 10	; Noise 10.

	db 181	; Volume 13.
	db 33	; Arpeggio 16.
	db 9	; Noise 9.

	db 177	; Volume 12.
	db 19	; Arpeggio 9.
	db 8	; Noise 8.

	db 173	; Volume 11.
	db 1	; Arpeggio 0.
	db 7	; Noise 7.

	db 165	; Volume 9.
	db 19	; Arpeggio 9.
	db 6	; Noise 6.

	db 157	; Volume 7.
	db 29	; Arpeggio 14.
	db 5	; Noise 5.

	db 149	; Volume 5.
	db 1	; Arpeggio 0.
	db 4	; Noise 4.

	db 141	; Volume 3.
	db 1	; Arpeggio 0.
	db 3	; Noise 3.

	db 133	; Volume 1.
	db 1	; Arpeggio 0.
	db 2	; Noise 2.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart12
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd12

highscore_FmInstrument5
	db 0	; Speed.

	db 61	; Volume 15.

	db 189	; Volume 15.
	db 8	; Arpeggio 4.

	db 185	; Volume 14.
	db 14	; Arpeggio 7.

	db 57	; Volume 14.

	db 181	; Volume 13.
	db 8	; Arpeggio 4.

	db 181	; Volume 13.
	db 14	; Arpeggio 7.

	db 49	; Volume 12.

	db 177	; Volume 12.
	db 8	; Arpeggio 4.

	db 173	; Volume 11.
	db 14	; Arpeggio 7.

	db 45	; Volume 11.

	db 169	; Volume 10.
	db 8	; Arpeggio 4.

	db 169	; Volume 10.
	db 14	; Arpeggio 7.

	db 37	; Volume 9.

	db 165	; Volume 9.
	db 8	; Arpeggio 4.

	db 161	; Volume 8.
	db 14	; Arpeggio 7.

	db 33	; Volume 8.

	db 157	; Volume 7.
	db 8	; Arpeggio 4.

	db 157	; Volume 7.
	db 14	; Arpeggio 7.

	db 25	; Volume 6.

	db 153	; Volume 6.
	db 8	; Arpeggio 4.

	db 149	; Volume 5.
	db 14	; Arpeggio 7.

	db 21	; Volume 5.

	db 145	; Volume 4.
	db 8	; Arpeggio 4.

	db 145	; Volume 4.
	db 14	; Arpeggio 7.

	db 13	; Volume 3.

	db 141	; Volume 3.
	db 8	; Arpeggio 4.

	db 137	; Volume 2.
	db 14	; Arpeggio 7.

	db 9	; Volume 2.

	db 133	; Volume 1.
	db 8	; Arpeggio 4.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart13
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd13

highscore_FmInstrument6
	db 0	; Speed.

	db 189	; Volume 15.
	db 14	; Arpeggio 7.

	db 189	; Volume 15.
	db 24	; Arpeggio 12.

	db 185	; Volume 14.
	db 32	; Arpeggio 16.

	db 185	; Volume 14.
	db 14	; Arpeggio 7.

	db 181	; Volume 13.
	db 24	; Arpeggio 12.

	db 181	; Volume 13.
	db 32	; Arpeggio 16.

	db 177	; Volume 12.
	db 14	; Arpeggio 7.

	db 177	; Volume 12.
	db 24	; Arpeggio 12.

	db 173	; Volume 11.
	db 32	; Arpeggio 16.

	db 173	; Volume 11.
	db 14	; Arpeggio 7.

	db 169	; Volume 10.
	db 24	; Arpeggio 12.

	db 169	; Volume 10.
	db 32	; Arpeggio 16.

	db 165	; Volume 9.
	db 14	; Arpeggio 7.

	db 165	; Volume 9.
	db 24	; Arpeggio 12.

	db 161	; Volume 8.
	db 32	; Arpeggio 16.

	db 161	; Volume 8.
	db 14	; Arpeggio 7.

	db 157	; Volume 7.
	db 24	; Arpeggio 12.

	db 157	; Volume 7.
	db 32	; Arpeggio 16.

	db 153	; Volume 6.
	db 14	; Arpeggio 7.

	db 153	; Volume 6.
	db 24	; Arpeggio 12.

	db 149	; Volume 5.
	db 32	; Arpeggio 16.

	db 149	; Volume 5.
	db 14	; Arpeggio 7.

	db 145	; Volume 4.
	db 24	; Arpeggio 12.

	db 145	; Volume 4.
	db 32	; Arpeggio 16.

	db 141	; Volume 3.
	db 14	; Arpeggio 7.

	db 141	; Volume 3.
	db 24	; Arpeggio 12.

	db 137	; Volume 2.
	db 32	; Arpeggio 16.

	db 137	; Volume 2.
	db 14	; Arpeggio 7.

	db 133	; Volume 1.
	db 24	; Arpeggio 12.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart14
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd14

highscore_FmInstrument7
	db 0	; Speed.

	db 61	; Volume 15.

	db 181	; Volume 13.
	db 8	; Arpeggio 4.

	db 173	; Volume 11.
	db 14	; Arpeggio 7.

	db 169	; Volume 10.
	db 8	; Arpeggio 4.

	db 37	; Volume 9.

	db 161	; Volume 8.
	db 8	; Arpeggio 4.

	db 57	; Volume 14.

	db 177	; Volume 12.
	db 8	; Arpeggio 4.

	db 169	; Volume 10.
	db 14	; Arpeggio 7.

	db 165	; Volume 9.
	db 8	; Arpeggio 4.

	db 33	; Volume 8.

	db 157	; Volume 7.
	db 8	; Arpeggio 4.

	db 53	; Volume 13.

	db 173	; Volume 11.
	db 8	; Arpeggio 4.

	db 165	; Volume 9.
	db 14	; Arpeggio 7.

	db 161	; Volume 8.
	db 8	; Arpeggio 4.

	db 29	; Volume 7.

	db 153	; Volume 6.
	db 8	; Arpeggio 4.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart15
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd15

highscore_FmInstrument8
	db 0	; Speed.

	db 189	; Volume 15.
	db 24	; Arpeggio 12.

	db 53	; Volume 13.

	db 49	; Volume 12.

	db 45	; Volume 11.

	db 41	; Volume 10.

	db 37	; Volume 9.

	db 33	; Volume 8.

	db 29	; Volume 7.

	db 25	; Volume 6.

	db 21	; Volume 5.

	db 17	; Volume 4.

	db 13	; Volume 3.

	db 9	; Volume 2.

	db 5	; Volume 1.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart16
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd16

highscore_FmInstrument9
	db 0	; Speed.

	db 189	; Volume 15.
	db 14	; Arpeggio 7.

	db 181	; Volume 13.
	db 24	; Arpeggio 12.

	db 173	; Volume 11.
	db 32	; Arpeggio 16.

	db 169	; Volume 10.
	db 24	; Arpeggio 12.

	db 165	; Volume 9.
	db 14	; Arpeggio 7.

	db 161	; Volume 8.
	db 24	; Arpeggio 12.

	db 185	; Volume 14.
	db 14	; Arpeggio 7.

	db 177	; Volume 12.
	db 24	; Arpeggio 12.

	db 169	; Volume 10.
	db 32	; Arpeggio 16.

	db 165	; Volume 9.
	db 24	; Arpeggio 12.

	db 161	; Volume 8.
	db 14	; Arpeggio 7.

	db 157	; Volume 7.
	db 24	; Arpeggio 12.

	db 181	; Volume 13.
	db 14	; Arpeggio 7.

	db 173	; Volume 11.
	db 24	; Arpeggio 12.

	db 165	; Volume 9.
	db 32	; Arpeggio 16.

	db 161	; Volume 8.
	db 24	; Arpeggio 12.

	db 157	; Volume 7.
	db 14	; Arpeggio 7.

	db 153	; Volume 6.
	db 24	; Arpeggio 12.

	db 4	; End the instrument.
highscore_DisarkPointerRegionStart17
	dw highscore_FmInstrument0Loop	; Loop to silence.
highscore_DisarkPointerRegionEnd17

highscore_DisarkByteRegionEnd7
highscore_Subsong0DisarkByteRegionStart0
; Song Untitled, Subsong 0 - Main - in Lightweight format (V1).
; Generated by Arkos Tracker 2.

highscore_Subsong0
	db 6	; Initial speed.

; The Linker.
; Pattern 0
highscore_Subsong0loop
	db 5	; State byte.
	db 63	; New height.
highscore_Subsong0DisarkPointerRegionStart1
	dw highscore_Subsong0_Track1, highscore_Subsong0_Track2, highscore_Subsong0_Track0
highscore_Subsong0DisarkPointerRegionEnd1
; The tracks.

	db 0	; End of the subsong.
highscore_Subsong0DisarkPointerRegionStart2
	dw highscore_Subsong0loop
highscore_Subsong0DisarkPointerRegionEnd2

; The Tracks.
highscore_Subsong0_Track0
	db 218	; Note 50.
	db 14	; New instrument 7.
	db 129	; Volume + possible Pitch up/down.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 10	; New instrument 5.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 12	; New instrument 6.
	db 62	; Short wait 1.

	db 154	; Note 50.
	db 14	; New instrument 7.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 10	; New instrument 5.
	db 254	; Short wait 4.

	db 154	; Note 50.
	db 14	; New instrument 7.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 10	; New instrument 5.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 12	; New instrument 6.
	db 62	; Short wait 1.

	db 154	; Note 50.
	db 14	; New instrument 7.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 10	; New instrument 5.
	db 254	; Short wait 4.

	db 147	; Note 43.
	db 18	; New instrument 9.
	db 126	; Short wait 2.

	db 147	; Note 43.
	db 12	; New instrument 6.
	db 126	; Short wait 2.

	db 31	; Note 55.
	db 62	; Short wait 1.

	db 147	; Note 43.
	db 18	; New instrument 9.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 10	; New instrument 5.
	db 254	; Short wait 4.

	db 149	; Note 45.
	db 14	; New instrument 7.
	db 126	; Short wait 2.

	db 149	; Note 45.
	db 10	; New instrument 5.
	db 126	; Short wait 2.

	db 149	; Note 45.
	db 18	; New instrument 9.
	db 126	; Short wait 2.

	db 154	; Note 50.
	db 12	; New instrument 6.
	db 62	; Short wait 1.

	db 154	; Note 50.
	db 10	; New instrument 5.
	db 254	; Short wait 4.


highscore_Subsong0_Track1
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 128	; Volume + possible Pitch up/down.
	db 191, 14	; Escaped note 14.
	db 16	; New instrument 8.
	db 2	; Note 26.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 128	; Volume + possible Pitch up/down.
	db 142	; Note 38.
	db 16	; New instrument 8.
	db 26	; Note 50.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 129	; Volume + possible Pitch up/down.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 128	; Volume + possible Pitch up/down.
	db 130	; Note 26.
	db 16	; New instrument 8.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 255, 14	; Escaped note 14.
	db 16	; New instrument 8.
	db 128	; Volume + possible Pitch up/down.
	db 140	; Note 36.
	db 6	; New instrument 3.
	db 142	; Note 38.
	db 16	; New instrument 8.
	db 128	; Note 24.
	db 2	; New instrument 1.
	db 140	; Note 36.
	db 6	; New instrument 3.
	db 128	; Note 24.
	db 2	; New instrument 1.
	db 191, 14	; Escaped note 14.
	db 16	; New instrument 8.
	db 2	; Note 26.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 128	; Volume + possible Pitch up/down.
	db 142	; Note 38.
	db 16	; New instrument 8.
	db 26	; Note 50.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 129	; Volume + possible Pitch up/down.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 128	; Volume + possible Pitch up/down.
	db 130	; Note 26.
	db 16	; New instrument 8.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 255, 14	; Escaped note 14.
	db 16	; New instrument 8.
	db 128	; Volume + possible Pitch up/down.
	db 140	; Note 36.
	db 6	; New instrument 3.
	db 142	; Note 38.
	db 16	; New instrument 8.
	db 128	; Note 24.
	db 2	; New instrument 1.
	db 140	; Note 36.
	db 6	; New instrument 3.
	db 128	; Note 24.
	db 2	; New instrument 1.
	db 191, 19	; Escaped note 19.
	db 16	; New instrument 8.
	db 7	; Note 31.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 128	; Volume + possible Pitch up/down.
	db 147	; Note 43.
	db 16	; New instrument 8.
	db 31	; Note 55.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 129	; Volume + possible Pitch up/down.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 128	; Volume + possible Pitch up/down.
	db 135	; Note 31.
	db 16	; New instrument 8.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 255, 19	; Escaped note 19.
	db 16	; New instrument 8.
	db 128	; Volume + possible Pitch up/down.
	db 140	; Note 36.
	db 6	; New instrument 3.
	db 142	; Note 38.
	db 16	; New instrument 8.
	db 128	; Note 24.
	db 2	; New instrument 1.
	db 140	; Note 36.
	db 6	; New instrument 3.
	db 128	; Note 24.
	db 2	; New instrument 1.
	db 191, 9	; Escaped note 9.
	db 16	; New instrument 8.
	db 63, 21	; Escaped note 21.
	db 192	; Note 24.
	db 2	; New instrument 1.
	db 129	; Volume + possible Pitch up/down.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 128	; Volume + possible Pitch up/down.
	db 137	; Note 33.
	db 16	; New instrument 8.
	db 21	; Note 45.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 129	; Volume + possible Pitch up/down.
	db 204	; Note 36.
	db 2	; New instrument 1.
	db 128	; Volume + possible Pitch up/down.
	db 191, 21	; Escaped note 21.
	db 16	; New instrument 8.
	db 204	; Note 36.
	db 6	; New instrument 3.
	db 129	; Volume + possible Pitch up/down.
	db 255, 9	; Escaped note 9.
	db 16	; New instrument 8.
	db 128	; Volume + possible Pitch up/down.
	db 145	; Note 41.
	db 8	; New instrument 4.
	db 142	; Note 38.
	db 16	; New instrument 8.
	db 145	; Note 41.
	db 8	; New instrument 4.
	db 17	; Note 41.

highscore_Subsong0_Track2
	db 222	; Note 54.
	db 4	; New instrument 2.
	db 128	; Volume + possible Pitch up/down.
	db 82	; Note 42.
	db 134	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 129	; Volume + possible Pitch up/down.
	db 78	; Note 38.
	db 133	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 130	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 132	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 128	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 134	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 129	; Volume + possible Pitch up/down.
	db 106	; Note 66.
	db 133	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 130	; Volume + possible Pitch up/down.
	db 102	; Note 62.
	db 132	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 128	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 134	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 129	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 133	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 130	; Volume + possible Pitch up/down.
	db 82	; Note 42.
	db 132	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 128	; Volume + possible Pitch up/down.
	db 78	; Note 38.
	db 134	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 129	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 133	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 130	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 132	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 128	; Volume + possible Pitch up/down.
	db 106	; Note 66.
	db 134	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 129	; Volume + possible Pitch up/down.
	db 102	; Note 62.
	db 133	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 130	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 132	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 128	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 134	; Volume + possible Pitch up/down.
	db 97	; Note 57.
	db 129	; Volume + possible Pitch up/down.
	db 85	; Note 45.
	db 133	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 130	; Volume + possible Pitch up/down.
	db 78	; Note 38.
	db 132	; Volume + possible Pitch up/down.
	db 99	; Note 59.
	db 128	; Volume + possible Pitch up/down.
	db 99	; Note 59.
	db 134	; Volume + possible Pitch up/down.
	db 95	; Note 55.
	db 129	; Volume + possible Pitch up/down.
	db 95	; Note 55.
	db 133	; Volume + possible Pitch up/down.
	db 101	; Note 61.
	db 130	; Volume + possible Pitch up/down.
	db 127, 73	; Escaped note 73.
	db 132	; Volume + possible Pitch up/down.
	db 102	; Note 62.
	db 128	; Volume + possible Pitch up/down.
	db 127, 74	; Escaped note 74.
	db 134	; Volume + possible Pitch up/down.
	db 97	; Note 57.
	db 129	; Volume + possible Pitch up/down.
	db 97	; Note 57.
	db 133	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 130	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 132	; Volume + possible Pitch up/down.
	db 92	; Note 52.
	db 128	; Volume + possible Pitch up/down.
	db 80	; Note 40.
	db 134	; Volume + possible Pitch up/down.
	db 89	; Note 49.
	db 129	; Volume + possible Pitch up/down.
	db 77	; Note 37.
	db 133	; Volume + possible Pitch up/down.
	db 92	; Note 52.
	db 130	; Volume + possible Pitch up/down.
	db 92	; Note 52.
	db 132	; Volume + possible Pitch up/down.
	db 89	; Note 49.
	db 128	; Volume + possible Pitch up/down.
	db 89	; Note 49.
	db 134	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 129	; Volume + possible Pitch up/down.
	db 106	; Note 66.
	db 133	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 130	; Volume + possible Pitch up/down.
	db 102	; Note 62.
	db 132	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 128	; Volume + possible Pitch up/down.
	db 94	; Note 54.
	db 134	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 129	; Volume + possible Pitch up/down.
	db 90	; Note 50.
	db 133	; Volume + possible Pitch up/down.

highscore_Subsong0DisarkByteRegionEnd0
