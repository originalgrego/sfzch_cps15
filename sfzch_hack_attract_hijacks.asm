hijack_attract_04:
	move.w  ($4,A5), D0
	move.w  ($6,PC,D0.w), D1
	jmp     ($2,PC,D1.w)

jtl_hijack_attract_04:
	dc.w	hijack_attract_04_00-jtl_hijack_attract_04
	dc.w	hijack_attract_04_02-jtl_hijack_attract_04
	
hijack_attract_04_00:
	addq.w  #2, ($4,A5)
	move.w  #$f0, ($6,A5)
	moveq   #$2d, D0
	lea     $90c000.l, A1
	jsr     $19EF2.l
	moveq   #$2e, D0
	lea     $90c400.l, A1
	jsr     $19EF2.l
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