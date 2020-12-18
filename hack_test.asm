 org  0
   incbin  "build\sfzch.bin"
 
 include "sfzch_hack_attract.asm"

qsound_fifo_offset = $7000
qsound_fifo_head_offset = $6000
qsound_fifo_tail_offset = $6010
temp = $6020

 org $0211C2
	jmp Hijack_Sound_Test_Add_Audio

 org $000AA6
	jmp Do_Qsound_Test

 org $011380
	jmp Initialize_QSound_Fifo

 org $000ECA
	jmp Hijack_More_Init

 org $011322
	jmp Hijack_Upload_Audio_Commands

 org $011350
	jmp Hijack_Add_Audio_Command_To_Fifo
	
; service mode test
 org $179A
;	NOP

	
; ===========================
;
; 		REGION TEXT
;
;============================

 ; Region and version text pointers changed to only draw our new version
 org $C7C8
	dc.w	$E0, $E0, $E0, $E0, $E0, $E0
	
 ; Region warning text pointers
 org $C7D4
	dc.w	$29C, $29C, $29C, $29C, $29C, $29C
	


; header: X Y Z
; X = starting column
; Y = starting row (row * 4)
; Z = palette (in this case always 1)
;
; Strings are terminated by / character ($2F)
;
; Routine will continue drawing strings until terminated by word length zero instead of /


; ##################
; REGION AND VERSION
; ##################

 org $C8A8

	dc.b	$05		; x
	dc.b	$24		; y
	dc.b	$01		; palette
	dc.b	"S T R E E T   F I G H T E R   Z E R O/"
	
	dc.b	$12		; x
	dc.b	$30		; y
	dc.b	$01		; palette
	dc.b	"2 0 1 2 1 8/"
	
	dc.b	$0B		; x
	dc.b	$3C		; y
	dc.b	$01		; palette
	dc.b	"C P S  C H A N G E R  1 . 5"
	
	dc.w	$0		; end

; ##############
; REGION WARNING
; ##############

 org $CA64
	
	dc.b	$03
	dc.b	$10
	dc.b	$01
	dc.b	"                WARNING/"
	
	dc.b	$03
	dc.b	$20
	dc.b	$01
	dc.b	"This game has been unlawfully modified and/"
 	
	dc.b	$03
	dc.b	$28
	dc.b	$01
	dc.b	"is not permitted for use in any country or/"
	 	
	dc.b	$03
	dc.b	$30
	dc.b	$01
	dc.b	"territory./"
		 	
	dc.b	$03
	dc.b	$3C
	dc.b	$01
	dc.b	"Sales, export or operation of this game is/"
			 	
	dc.b	$03
	dc.b	$44
	dc.b	$01
	dc.b	"unquestionably a criminal offense./"
				 	
	dc.b	$03
	dc.b	$58
	dc.b	$03
	dc.b	"            INTERPOL NOTICE/"
	
	dc.b	$03
	dc.b	$64
	dc.b	$03
	dc.b	"Be on the lookout for these individuals:/"

	dc.b	$05
	dc.b	$6C
	dc.b	$02
	dc.b	"grego2d/"
	
	dc.b	$13
	dc.b	$6C
	dc.b	$00
	dc.b	" Rotwang/"
	
	dc.b	$22
	dc.b	$6C
	dc.b	$04
	dc.b	" bdlou"

	dc.w	$0
 
; ==========================
; ==========================

; Free space
 org $149A50
 
 include "sfzch_hack_attract_hijacks.asm"

;----------------

Do_Qsound_Test:
	cmpi.l  #$5642194, D0
	cmpi.b  #$77, $f19fff.l
	bne     Do_Qsound_Test ; Wait loop

	lea     $f18000.l, A0 ; QSound mem
	lea     ($1ffe,A0), A1 ; Length
	
	movea.l A0, A3
	move.w  #$1, D1
	moveq   #$0, D3

Do_Qsound_Test_Loop:
	move.w  tbl_qsound_test_data(PC,D3.w), D0
	lea     (A3), A0

Do_Qsound_Test_Loop_2:
	cmpi.l  #$5642194, D0
	move.w  D0, (A0)
	cmp.b   ($1,A0), D0
	;bne     $d6e

	lea     ($2,A0), A0
	cmpa.l  A1, A0
	bls     Do_Qsound_Test_Loop_2

	addq.w  #2, D3
	dbra    D1, Do_Qsound_Test_Loop 
	
Clear_Qsound_Ram:
	lea     $F18000.l, A0
	lea     $F19ff9.l, A1
	moveq   #-$1, D0
  
Clear_Qsound_Ram_Loop:
	cmpi.l  #$5642194, D0
	move.w  D0, (A0)+
	cmpa.l  A1, A0
	bls     Clear_Qsound_Ram_Loop

	jsr		draw_qsound_ramok

	lea     $ac0, A6
	jmp     (A6)

tbl_qsound_test_data:
	dc.w	$0000, $5555
;----------------

;----------------
Initialize_QSound_Fifo:
  move.w  #$ff, D6 ; Loop count
  lea     (qsound_fifo_offset,A5), A0

  moveq   #$0, D0
 
Initialize_QSound_Fifo_Loop:
  move.l  D0, (A0)+
  move.l  D0, (A0)+
  move.l  D0, (A0)+
  move.l  D0, (A0)+
  dbra    D6, Initialize_QSound_Fifo_Loop
 
  move.l  D0, (qsound_fifo_tail_offset,A5) ; Clear fifo tail
  move.l  D0, (qsound_fifo_head_offset,A5) ; Clear fifo head

  rts
;----------------

;----------------
Hijack_More_init:
	move.b  #$88, $f19ffb.l
	move.b  #$0, $f19ffd.l
	move.b  #$ff, $f19fff.l

	; Original code from 000ECA
	lea     $ff8000.l, A7
	lea     $ff8000.l, A5
	moveq   #$0, D0
	; Original code from 000ECA

	jmp $000ED8
;----------------

;----------------
Hijack_Upload_Audio_Commands:
;  moveq   #$0, D0 ; Ignore stereo on sounds
  
;  tst.b   ($19a,A5)
;  beq     Hijack_Upload_Audio_Commands_Continue

  moveq   #-$1, D0 ; Handle stereo
  
Hijack_Upload_Audio_Commands_Continue:
  move.b  D0, $F19ffd.l

  move.w  (qsound_fifo_head_offset,A5), D0 ; Fifo head
  cmp.w   (qsound_fifo_tail_offset,A5), D0 ; Compare against fifo tail
  beq     Hijack_Upload_Audio_Commands_Exit

  cmpi.b  #-$1, $F1801f.l
  bne     Hijack_Upload_Audio_Commands_Exit

  lea     (qsound_fifo_offset,A5), A4 ; Load fifo location
  move.w  (qsound_fifo_head_offset,A5), D0 ; Load fifo index
  move.b  (A4,D0.w), $F18007.l
  move.b  ($1,A4,D0.w), $F18009.l
  move.b  ($2,A4,D0.w), $F18001.l
  move.b  ($3,A4,D0.w), $F18003.l
  move.b  ($4,A4,D0.w), $F18005.l
  move.b  ($5,A4,D0.w), $F1800d.l
  move.b  ($6,A4,D0.w), $F1800f.l
  move.b  ($7,A4,D0.w), $F18011.l
  move.b  ($8,A4,D0.w), $F18017.l
  move.b  ($9,A4,D0.w), $F18019.l
  move.b  ($a,A4,D0.w), $F18013.l
  move.b  ($b,A4,D0.w), $F18015.l
  move.b  #$0, $F1801f.l
  addi.w  #$10, D0
  andi.w  #$ff0, D0
  move.w  D0, (qsound_fifo_head_offset,A5) ; Update fifo head
  
Hijack_Upload_Audio_Commands_Exit:
  rts
;----------------

;----------------
Stereo_Calculation:
	moveq   #$0, D0
	move.b  ($9,A6), D0
	beq     Stereo_Calculation_Cont2

	subq.w  #4, D0
	movea.l tbl_stereo_calc_table_1(PC,D0.w), A4
	move.w  ($10,A6), D0 ; Get players xpos!
	sub.w   (A4), D0
	bge     Stereo_Calculation_Cont

	moveq   #$0, D0
	bra     Stereo_Calculation_Cont3

Stereo_Calculation_Cont:
	cmpi.w  #$17f, D0
	bls     Stereo_Calculation_Cont3

	move.w  #$17f, D0
	bra     Stereo_Calculation_Cont3

Stereo_Calculation_Cont2:
	move.w  ($10,A6), D0 ; Get players xpos!

Stereo_Calculation_Cont3:
	andi.w  #$1fe, D0
	move.w  tbl_stereo_calc_table_2(PC,D0.w), D0
	andi.l  #$ff00, D0
	andi.l  #$ff00ff, D2
	or.l    D0, D2
	rts
;----------------

tbl_stereo_calc_table_1:
	incbin "stereo_calc_table_1.bin"

tbl_stereo_calc_table_2:
	incbin "stereo_calc_table_2.bin"

;----------------
Hijack_Add_Audio_Command_To_Fifo:
	move.l D1, (temp, A5)

	lsl.l   #$1, D1
	move.w  tbl_sound_mappings(PC,D1.w), D1	
	beq Hijack_Add_Audio_Command_To_Fifo_Exit

	moveq   #$0, D2
	moveq   #$0, D3

	bsr Add_Audio_Command_To_Fifo

	bsr Add_Secondary_Audio_Command

Hijack_Add_Audio_Command_To_Fifo_Exit:
	rts
;----------------

;----------------
Hijack_Sound_Test_Add_Audio:
	lsl.l   #$1, D1
	move.w  tbl_sound_mappings(PC,D1.w), D1	

	bsr Add_Audio_Command_To_Fifo_Continue

	rts
;----------------

tbl_sound_mappings:
	incbin "sound_mappings.bin"

;----------------
Add_Secondary_Audio_Command:
	move.l (temp, A5), D1

	lsl.l   #$1, D1
	move.w  tbl_secondary_sound_mappings(PC,D1.w), D1	
	beq Add_Secondary_Audio_Command_Exit

	moveq   #$0, D2
	moveq   #$0, D3

	bsr Add_Audio_Command_To_Fifo

Add_Secondary_Audio_Command_Exit:
	rts
;----------------

tbl_secondary_sound_mappings:
	incbin "secondary_sound_mappings.bin"

;----------------
Add_Audio_Command_To_Fifo:
	cmpi.w #$100, D1
	blt	Add_Audio_Command_To_Fifo_No_Stereo

	bsr Stereo_Calculation

Add_Audio_Command_To_Fifo_No_Stereo
	tst.b   ($199,A5)
	bne     Add_Audio_Command_To_Fifo_Continue

	tst.b   ($181,A5)
	bne     Add_Audio_Command_To_Fifo_Exit

Add_Audio_Command_To_Fifo_Continue:
	lea     (qsound_fifo_offset,A5), A4 ; Load fifo address
	move.w  (qsound_fifo_tail_offset,A5), D0 ; Fifo tail
	move.l  D1, (A4,D0.w)
	move.l  D2, ($4,A4,D0.w)
	move.l  D3, ($8,A4,D0.w)
	addi.w  #$10, D0
	andi.w  #$ff0, D0
	move.w  D0, (qsound_fifo_tail_offset,A5) ; Udate Fifo tail

Add_Audio_Command_To_Fifo_Exit:
	rts
;----------------

draw_qsound_ramok:
	movea.l		#$9088D0, A1
	movea.l		#$EAD, A0
	moveq		#0, D0
;	moveq		#0, D1
	move.b		#6, D0
	
draw_qsound_ramok_loop:
	move.b		(A0)+, D1
;	andi.b		#$FF, D1
	move.b		D1, ($1,A1)
	lea			($80,A1), A1
	dbf			D0, draw_qsound_ramok_loop
	
	lea			($100,A1), A1
	movea.l		#$EC2, A0
	moveq		#0, D0
	move.b		#5, D0
	
draw_qsound_ramok_loop2:
	move.b		(A0)+, D1
;	andi.b		#$FF, D1
	move.b		D1, ($1,A1)
	lea			($80,A1), A1
	dbf			D0, draw_qsound_ramok_loop2
	
	rts
	

