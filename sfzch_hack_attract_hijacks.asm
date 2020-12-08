hijack_attract_04:
	move.w  ($4,A5), D0
	move.w  (jtl_hijack_attract_04,PC,D0.w), D1
	jmp     (jtl_hijack_attract_04,PC,D1.w)

jtl_hijack_attract_04:
	dc.w	hijack_attract_04_00-jtl_hijack_attract_04
	dc.w	hijack_attract_04_02-jtl_hijack_attract_04
	
hijack_attract_04_00:
	addq.w  #2, ($4,A5)
	move.w  #$F0, ($6,A5) ; default #$F0
	
	moveq   #$2d, D0
	lea     $90c000.l, A1
	jsr     $19B3E.l
	moveq   #$2e, D0	; 2e
	lea     $90c400.l, A1
	jsr     $19B3E.l

;;;;	jsr		draw_qsound_logo

	moveq   #$55, D0
	jsr     $F1CA.l
	lea     $908864.l, A1
	jsr     $1CE8.l	
	moveq   #$0, D0
	move.w  D0, ($2a,A5)
	move.w  D0, ($2c,A5)
	move.w  D0, ($2e,A5)
	move.w  #$300, ($30,A5)
	move.w  #$0, ($2e28,A5)
	jsr     $F754.l
	moveq   #$4, D0
	jsr     $11BFC.l
	
	jsr 	copy_qsound_palette
	
	move.w  #$2, D0
	move.w  #$1, D1
	jmp     $1720.l

hijack_attract_04_02:
	subq.w  #1, ($6,A5)
	bpl     hijack_attract_04_02_return
	addq.w  #2, ($0,A5)
	clr.l   ($4,A5)

hijack_attract_04_02_return:
	rts
 
; ================================
; ================================

hijack_attract_08:
	move.w	#2, D0
	move.w	#1, D1
	jmp		$1720.l
	
; ================================
; ================================

hijack_attract_redirect:
	jsr 	$11450
	moveq	#$30, D1
	jmp		$114B4

; ================================
; ================================

hijack_attract_qsmusic:
	moveq   #$22, D1
	moveq   #$0, D2
	moveq   #$0, D3
	jsr     Hijack_Add_Audio_Command_To_Fifo
	moveq   #$23, D1
	move.l  #$11000, D2
	move.l  #$80, D3
	jmp     $114B4.l
	
; ================================
; ================================

;;;;draw_qsound_logo:
;;;;	
;;;;	moveq	#0, D0
;;;;	move.w	#$180, D0
;;;;	movea.l	#qsound_logo, A0
;;;;	movea.l #$90C000, A1
;;;;	
;;;;draw_qsound_logo_loop:
;;;;	move.l (A0)+, (A1)+
;;;;	dbf		D0, draw_qsound_logo_loop
;;;;	
;;;;	rts
;;;;	
; ================================
; ================================
	
copy_qsound_palette:
	moveq	#0, D0
	move.b	#$60, D0
	movea.l	#qsound_logo_palette, A0
	movea.l #$914800, A1
	
copy_qsound_logo_palette_loop:
	move.l (A0)+, (A1)+
	dbf		D0, copy_qsound_logo_palette_loop
	
	rts
	
; ================================
	
;;;;qsound_logo:
;;;; incbin "scroll2_qsoundlogo.bin"
 
qsound_logo_palette:
; incbin "palette_qsoundlogo.bin"
 incbin "palette_qsoundlogo_dark.bin"