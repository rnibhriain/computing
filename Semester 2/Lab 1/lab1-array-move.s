;
; CS1022 Introduction to Computing II 2018/2019
; Lab 1 - Array Move
;

N	EQU	16		; number of elements

	AREA	globals, DATA, READWRITE

; N word-size values

ARRAY	SPACE	N*4		; N words


	AREA	RESET, CODE, READONLY
	ENTRY

	; for convenience, let's initialise test array [0, 1, 2, ... , N-1]

	LDR	R0, =ARRAY
	LDR	R1, =0
L1	CMP	R1, #N
	BHS	L2
	STR	R1, [R0, R1, LSL #2]
	ADD	R1, R1, #1
	B	L1
L2
	; initialise registers for your program

	LDR	R0, =ARRAY
	LDR	R1, =3
	LDR	R2, =6
	LDR	R3, =N


	LDR	R5, [R0, R1, LSL#2]		; load element
	CMP	R1, R2			; if (oldIndex < newIndex) 
	BHS	finishFirstIf		; {
	MOV	R4, R1			; for (int count = oldIndex; 
forLoop1
	CMP	R4, R2			; count < newIndex;)
	BHS	finishForLoop1		; 
	ADD	R7, R4, #1		; count+1
	LDR	R6, [R0, R7, LSL#2]		; array [count+1] 
	STR	R6, [R0, R4, LSL#2]		; array [count] = array [count+1]
	ADD	R4, R4, #1		; count++
	B	forLoop1
finishForLoop1
	STR	R5, [R0, R2, LSL#2]		;
finishFirstIf
	CMP	R1, R2			; if (oldIndex < newIndex) 
	BLS	finishSecondIf		; {
	MOV	R4, R1			; for (int count = oldIndex; 
forLoop2
	CMP	R4, R2			; count > newIndex;)
	BLS	finishForLoop2		; 
	SUB	R7, R4, #1		; count-1
	LDR	R6, [R0, R7, LSL#2]	; array [count-1] 
	STR	R6, [R0, R4, LSL#2]	; array [count] = array [count-1]
	SUB	R4, R4, #1		; count--
	B	forLoop2
finishForLoop2
	STR	R5, [R0, R2, LSL#2]		;
finishSecondIf
	


STOP	B	STOP

	END
