;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Upper Triangular
;

N	EQU	4		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; write your program here to determine whether ARR_A
	;   (below) is a matrix in Upper Triangular form.
	;
	; Store 1 in R0 if the matrix is in Upper Triangular form
	;   and zero otherwise.
	;

	LDR	R0, =0
	LDR	R1, =ARR_A
	
	LDR	R2, =0			; for(int row = 0;
ForLoop1
	CMP	R2, #N			; row < N;)
	BHS	endForLoop1		; {
	LDR	R3, =0			; for (int column = 0;
ForLoop2
	CMP	R3, R2			; column < row;)
	BHS	endForLoop2		; {
	MOV	R5, #4
	MUL	R4, R5, R2		; row * rowSize
	ADD	R4, R4, R3		; (row*rowSize) + column
	LDR	R6, [R1, R4, LSL#2]	; load element
	CMP	R6, #0			; if (element != 0)
	BNE	notUpperTriangular	; finish
	LDR	R0, =1			; still could be upper triangular
	ADD	R3, R3, #1		; column++
	B	ForLoop2		; }
endForLoop2
	ADD	R2, R2, #1		; row ++
	B	ForLoop1		; }
notUpperTriangular
	LDR	R0, =0			; it is not an upperTriangular matrix
endForLoop1



STOP	B	STOP


;
; test data
;

ARR_A	DCD	 1,  2,  3,  4
	DCD	 0,  6,  0,  8
	DCD	 0,  0, 11, 12
	DCD	 0,  0,  0, 16

	END
