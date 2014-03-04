	org $800
result 		rmw 	 1
range 		rmw 	 1

value		equ	 4
test1low	equ	 0
test1high	equ	 5
test2low	equ	 5
test2high	equ	 25
test3low	equ	 1
test3high	equ	 10
		
	org $4000
	ldx #65535 	;16 bit minus one	
	ldaa #test1high
	ldab #test1low
	sba
	ldab #value
	mul
	idiv		;now x is set up
	stx range
	ldd #test1low
	addd range
	std result
	
	
	
