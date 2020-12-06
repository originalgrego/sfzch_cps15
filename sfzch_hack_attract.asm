 org $1966 ; attract_04. Should be qsound screen, instead it increments attract mode state to 08 and then goes right to 08's code.
 ; Replacing the increment (addq.w #4, ($0,A5)) with a branch to a jump that will overwrite the last instruction of attract_08. Another hijack in attract_08 will correct its course.
	bra $19CA
	
; ================================
; ================================

 org $19C2
	jmp hijack_attract_08

; ================================
; ================================

 org $19CA
	jmp hijack_attract_04
	
; ================================
;   Q SOUND JINGLE
; ================================

 org $11C16		; override pointer to QSound jingle queue code
	dc.w	$164

; I have no idea what this chunk of code does, but it's in the way
; of getting the QSound jingle to play and it's also small and easily
; relocatable. Adding redirect at its start so I can replace the rest
; of it with a hijack for playing the QSound jingle.
; The original QSound jingle queue code was replaced with just a RTS
; so it wasn't long enough to hijack in the conventional way.

 org $11D6E
	jmp hijack_attract_redirect		
	
 org $11D76
	jmp hijack_attract_qsmusic