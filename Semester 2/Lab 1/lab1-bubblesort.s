;
; CS1022 Introduction to Computing II 2019/2020
; Lab 1B - Bubble Sort
;

N	EQU	10

	AREA	globals, DATA, READWRITE

; N word-size values

SORTED	SPACE	N*4		; N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY


	;
	; copy the test data into RAM
	;



	LDR	R4, =SORTED
	LDR	R5, =UNSORT
	LDR	R6, =0
whInit	CMP	R6, #N
	BHS	eWhInit
	LDR	R7, [R5, R6, LSL #2]
	STR	R7, [R4, R6, LSL #2]
	ADD	R6, R6, #1
	B	whInit
eWhInit



	LDR	R4, =SORTED

	
	
	
	
doWhile
	LDR	R8, =0			; swapped =  false
	LDR	R9, =1			; for (int i = 1;
forLoop
	CMP	R9, #N			; i < N;
	BHS	endForLoop		; )
	SUB	R11, R9, #1		; i -1
	LDR	R1, [R4, R11, LSL#2]	; tmpSwap = array[i-1]
	LDR	R2, [R4, R9, LSL#2]	; array[i]
	CMP	R1, R2			; if (array[i-1] > array[i]
	BLS	finishIf		; {
	STR	R2, [R4, R11, LSL#2]	; array[i-1] = array[i]
  	STR	R1, [R4, R9, LSL#2]	; array[i] = tmpswap
	MOV	R8, #1			; swapped =  true
finishIf
	ADD	R9, R9, #1		; i++
	B	forLoop			; }
endForLoop
	
	CMP	R8, #0			; while (swapped)
	BNE	endDoWhile
	CMP	R9, #N
	BEQ	endProgram
	B	doWhile
endDoWhile
	B	checkAllNumbers
endProgram
	
STOP	B	STOP	
	
	
	

UNSORT	DCD	9,3,2,8,6,0,4,7,1,5
	
	
	
checkAllNumbers
	CMP	R3, #N			; for (int count = 0;  
	BHS	endProgram		; count < N;)
	ADD	R5, R3, #1		; count+1
	LDR	R1, [R4, R3, LSL#2]	; array[count]
	LDR	R2, [R4, R5, LSL#2]	; array[count+1]
	CMP	R2, R1			; if (array[count] < array[count+1] &&
	BLS	doWhile			;
	ADD	R3, R3, #1		; count++
	B	checkAllNumbers		;}
	
	

	END
