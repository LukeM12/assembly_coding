	org $800
bytearg1	equ	1
bytearg2	equ	2
wordarg1	equ	3
wordarg2	equ	4
ret_byte	equ	1
ret_word	equ	1
	org $4000
main
	lds #$3DFF ;load the stack pointer 
	ldab #bytearg1 ;load the parameter in register B
	jsr f1 ;pass B in the subroutine
	
	ldab #bytearg1
	jsr f2
	
	ldd #wordarg1 ;Load word in D
	pshd ;Push D on the stack
	jsr f3 ;Pass D to the subroutine with the stack
	puld ;Clear the stack of D
	
	ldaa #bytearg1;Load both bytes
	ldab #bytearg2
	pshb ;Push them as parameters on the stack
	psha
	jsr f4
	pula	
	pulb
	
	ldd #wordarg1
	pshd	;need to push the return value 
	ldd #wordarg2
	pshd	;need to push the return value 
	jsr f5 ;there are no arguments, but return the value in bx
	puld
	puld
	
	jsr f6
	
	ldab #bytearg1 ; pass b on the stack 
	pshb
	jsr f7
	puld ;pull return value
	pulb
	
	ldab #wordarg1 ;load word as an argument and pass return in a register 
	jsr f8
	
	ldaa #bytearg1 ;load 
	psha
	ldaa #bytearg2
	psha
	jsr f9
	pula
	pula
	
	ldd #wordarg1
	pshd
	ldd #wordarg2
	pshd
	jsr f10
	pulb
	puld
	puld
	
	ldd #wordarg1
	pshd
	ldd #wordarg2
	pshd
	jsr f11
	puld
	puld
	
	ldd #wordarg1
	pshd
	ldd #bytearg1
	pshd
	jsr f12
	puld
	puld
		

f1
	pshx	
	pshy
	puly
	pulx
	rts
f2
	pshx	
	pshy
	puly
	pulx
	rts

f3
	pshx	
	pshy
	puly
	pulx
	rti

f4
	pshx	
	pshy
	puly
	pulx
	rti

f5
	pshx	
	pshy
	puly
	pulx
	rti
f6
	pshx	
	pshy
	puly
	pulx
	ldab #ret_byte
	rti

f7
	pshx	
	pshy
	puly
	pulx
	ldd #ret_word ; return value 
	pshd 	;pass return value on the stack 
	rti
	
f8
	pshx	
	pshy
	puly
	pulx
	ldd #ret_byte
	rti

f9
	pshx	
	pshy
	puly
	pulx
	ldd #ret_word
	rti

f10
	pshx	
	pshy
	puly
	pulx
	ldab #ret_byte
	pshb
	rti

f11
	pshx	
	pshy
	puly
	pulx
	rti
	
f12
	pshx	
	pshy
	puly
	pulx
	ldab #ret_byte
	rti
