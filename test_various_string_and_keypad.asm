	org $800
array 	db 	'1230'
	#include "ass2a.asm"
	org $4000
	;ldd #array
	;jsr convertToDecimal
	;Now 123 is in D register but in hexadecimal value (because HC12 shows it that way
	ldd #0
	pshd
	;ldaa #45
	;jsr convertToString
	ldaa #65	
	jsr getRowColumn
	puly
	pulx
	ldaa #0
end