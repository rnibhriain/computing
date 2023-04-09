;
; CSU11021 Introduction to Computing I 2019/2020
; Mode
;

	AREA	RESET, CODE, READONLY
	ENTRY


	LDR	R4, =tstN	; load address of tstN
	LDR	R1, [R4]	; load value of tstN

	LDR	R2, =tstvals	; load address of numbers
	
	
whileLoop1
	CMP	R1, #0		; while (N!=0) 
	BEQ	endWhileLoop1	; {
	LDRB	R3, [R2]	; load byte into register
	LDR	R5, =0x40000000	; load with start address
	ADD	R5, R5, R3	; add number to the address
	LDRB	R6, [R5]	; load byte at the address 
	ADD	R6, R6, #1	; add one to the count for this number
	STRB	R6, [R5]	; store the number into the address
	SUB	R1, R1, #1	; N--
	ADD	R2, R2, #4	; add four to get to the location of the next number
	B	whileLoop1	; }
endWhileLoop1			;

	LDR	R5, =0x40000000	; load start address into R5
	
whileLoop2			;
	CMP	R1, #9		; while (count <= 9)
	BHI	finishWhileLoop2; {
	LDRB	R6, [R5]	; load number count into R6
	CMP	R6, R7		; compare number count with last number count
	BLO	noIf		; if (numCount >= lastNumCount) {
	MOV	R8, R5		; address into R8
	MOV	R7, R6		; lastNumCount = numCount
noIf				; }
	ADD	R1, R1, #1	; count++
	ADD	R5, R5, #1	; add one to the address
	B	whileLoop2	; } 
finishWhileLoop2		;
	LDR	R6, =0x40000000	;
	SUB	R0, R8, R6	; take start of address away from address of highest numCount
	

STOP	B	STOP

tstN	DCD	8			; N (number of numbers)
tstvals	DCD	5, 3, 7, 5, 3, 5, 1, 9	; numbers

	END
