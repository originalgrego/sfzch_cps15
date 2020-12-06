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
	
	