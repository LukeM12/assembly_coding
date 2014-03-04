; SYSC-2003 Winter 2007 Supplied code.
; 
	org $2000
TRUE	EQU 1
FALSE	EQU 0

	
; void printHex (char hexNumber)
;   D (in B) is hexNumber, a number from 0..15
;
printHex:
       andb  #$0f      ; mask off bits
       cmpb  #$09      ; compare to number
       bhi   above9    ; branch if a thru f
       addb  #$30      ; add standard offset
       bra hex
above9:
       addb  #$37      ; change a-f to ascii
hex:
       jsr   printChar
       rts
	   
REGBS  EQU $0000 
SC0SR1 EQU REGBS+$CC
SC0DRL EQU REGBS+$CF

; void printChar( char character)
;    D (in B) is character.
printChar:
 	pshd
here:   
   	;brCLR  SC0SR1,#$80,here
	;LDAB	SC0SR1	; read status
	;BITB	#$80  	; test Transmit Data Register Empty bit
	;BEQ	OUTSCI2	; loop if TDRE=1
	;ANDA	#$7F   	; mask parity
	;STAB	SC0DRL	; send character
	;puld
    rts
		 
; void printStr( char* string)
;    D contains address of null-terminated string.
printStr:
     pshd
     pshy
	 xgdy
nextCharInStr:
	 ldab 1,y+
	 cmpb #0x00
	 beq printStrDone
	 jsr printChar	
	bra nextCharInStr
printStrDone:
    puly
	puld
    rts


;* Returns the numeric equivalent of the decimal string.
;* @param string A null-terminated string denoting a valid positive decimal number, eg '1234' = 1234d
;* @return	 An unsigned int containing the decimal value equivalent to string in D (shows as HEX)
;*/
convertToDecimal: 
	pshx
	pshy 
	ldy #0 ;future return value 
	xgdx 	;point X reg to array 
	ldd #0	;initialize D to zero
	

loop:	ldab 1, x+ ;get value
	subb #$30 ;offset decimal
	aby      ;add the value to Y!!!!!	
	ldab 0, x ;peek if it is a zero
	subb #$30
	cmpb #0
	beq finish
	bra mult10
mult10
	ldd #10
	emul
	xgdy	
	bra loop
finish:
	xgdy
	puly
	pulx 
	rts
;/* Returns the decimal string equivalent of num, with leading zeros in 
 ;* the hundreds and tens columns (so that the returned string is always three digits long)
 ;* @param num	An unsigned byte number (maximum value = 255)
 ;* @param string A pointer to a null-terminated string of at least 4 bytes (3 digits+1terminator)
 ;*		 in which the subroutine will store the string equivalent of num
 ;*/	void convertToString(char num, char *string);	
convertToString: ; has the string value 
	pshb
	ldy #4 ;counter 

loop2:	ldx #10
	ediv 
	pshb ;push the remainder
	cmpa #0
	beq zeropad
	dbeq y, finish2
zeropad:
	ldaa #0
	psha
	dbeq y, finish2
finish2:
	rts
;/* Extracts and returns the row and column information from the code, returning true
; * if the code contains valid row/column values. Return false (-1) if not.
; * 
; * boolean getRowColumn( unsigned byte code, &unsigned byte row, & unsigned byte column)
; * @param  code is a byte divided up into two nibbles, 
; *		the high nibble being the column identifier
; *		the low nibble being the row identifier
; *     Both identifiers are not numbers but are instead bit masks with a one in the bit
; *     position corresponding to the row/column, and all other bit positions zero.
; *           eg. A nibble 0001 has a one in bit position 0 and therefore identifies row/column 0
; *	     eg. A nibble 1000 has a one in bit position 3 and therefore identifies row/column 3
; * @param row  A pointer to an unsigned byte in which the subroutine will return the row, 0..3
; * @param column A pointer to an unsigned byte in which the subroutine will return the column, 0..3
; * @return  0 if the code had two valid identifiers (one 1 and rest zero).
; *	    -1 if either row/column identifier had an invalid format (eg. more than one 1 or no 1's at all)
; */	
;char getRowColumn(char code, char *row, char *column);
;
;How it works!
;This program uses essentially the X register as a 0/1 boolean flag if it is a bad array
;With logic

;cpy #1 checks if it has already a one in that nibbet;
;cpy #0 checks before entering another loop if they were all zeros
;cpy #3 is just sanity checking to only check 4 bits 
;If we were to check a 64 bit register for nibbels, than it would be the same thing, 
;Just more code.
getRowColumn: ;
	ldy #0 		;temp count
	ldx #0 		;FLAG	
loop3:	
	lsra   		;logical shift right a
	bcs ret_row 	;branch if carry set 
	cpy #3		;see if we looked at all of the values 
	beq midpoint_check ;If we get here, we are "almost" halfway done
	iny
	bra loop3	

midpoint_check:	
	cpx #0		;Out flag shout be SET
	beq bad_array	;If it is not set, we did not get a zero and we need to exit 
	ldx #0		;If we get here, reset flag
	ldy #0		;Reset the count

loop4:
	lsra   		;logical shift right a
	bcs ret_col 	;branch if carry set
	cpy #3
	beq done
	iny
	bra loop4	;cpy #4

ret_row:
	cpx #1 		;compare to see if our flag is set
	beq bad_array ;if it is, we have a bad array, we need to return immediately -1
	pshy	       ;if it is not, we push the Y RETURN value and move on
	ldx #1		;set the flag
	iny		;incremement y
	cpy #3 	   	;If we have looked at all the nibbles
	beq loop4	;If we looked all the elements, go to the next loop
	bra loop3	;Otherwise, keep on looping

ret_col:
	cpx #1 		;compare to see if our flag is set
	beq bad_array ;if it is, we have a bad array, we need to return immediately -1
	pshy	       ;if it is not, we push the Y RETURN value and move on
	ldx #1		;set the flag
	iny		;incremement y
	cpy #3 	   	;If we have looked at all the nibbles
	beq done	;If we looked all the elements, go to the next loop
	bra loop4	;Otherwise, keep on looping

bad_array:
	puly 
	puly 
	ldab #-1

done:
	cpx #0		;out flag shout be SET
	beq bad_array	; if it is not set, we did not get a zero and we need to exit
	ldaa #0		;Yes, we did have a success in this case  
	rts

















