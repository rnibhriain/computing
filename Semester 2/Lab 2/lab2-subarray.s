;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Subarray
;

N	EQU	7
M	EQU	3		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	LDR	R0, =LARGE_A
	LDR	R1, =SMALL_A

	
	LDR	R2, =0				; row of Large Array
	LDR	R3, =0				; column of Large Array
forLoop1
	CMP	R3, #N				; for (int row = 0, int column;
	BHS	nextRow				; row < rowSize && column < columnSize;)
	LDR	R4, =0				; row of smallArray
	LDR	R5, =0				; column of smallArray
	LDR	R7, =N				;
	MUL	R6, R2, R7			; row by rowSize
	ADD	R6, R6, R3			; row by rowSize + column
	LDR	R8, [R0, R6, LSL#2]		; load element of largeArray
	LDR	R7, =M				;
	MUL	R6, R4, R7			; row by rowSize
	ADD	R6, R6, R5			; row by rowSize + column
	LDR	R9, [R1, R6, LSL#2]		; load element of smallArray
	CMP	R8, R9				; if (element of smallArray == element of largeArray)
	BEQ	checkMatrix			; branch to check if the matrix is there
	B	noChecking
checkMatrix	
	BL	checkMatrixArea
noChecking
	ADD	R3, R3, #1			; column++
	B	forLoop1
nextRow
	LDR	R3, =0				; start at first entry of the row
	ADD	R2, R2, #1			; row++
	CMP	R2, #N				; if  the last row is reached then there is no subarray
	BHS	endProgram			;
	B	forLoop1
subArrayConfirmed
	LDR	R0, =1				; confirm subarray
	B	finish	
endProgram
	LDR	R0, =0				; no subarray

finish

STOP	B	STOP


; checkMatrixArea subroutine
; checks to see if the small matrix is a sub matrix from a certain starting point
; R0 and R1 are the addresses of the matrices
; R2 is the current row of the large matrix
; R3 is the current column of the large matrix
; R4 is the current row of the small array
; R5 is the current column of the small array



checkMatrixArea
	PUSH	{LR, R2-R5}
nextElement
	ADD	R3, R3, #1			; add one to column of largeArray
	ADD	R5, R5, #1			; add one to column of smallArray
	CMP	R5, #M				; if (column == columnSize)
	BHS	nextRow1			; go to next row
	
	LDR	R7, =N	
	MUL	R6, R2, R7			; row by rowSize
	ADD	R6, R6, R3			; row by rowSize + column
	LDR	R8, [R0, R6, LSL#2]		; load element of largeArray
	LDR	R7, =M				;
	MUL	R6, R4, R7			; row by rowSize
	ADD	R6, R6, R5			; row by rowSize + column
	LDR	R9, [R1, R6, LSL#2]		; load element of smallArray
	CMP	R8, R9				; if (element of smallArray != element of largeArray)
	BNE	noMatrix			; there is no matrix
	B	nextElement
nextRow1
	ADD	R2, R2, #1			; add one to row of largeArray
	ADD	R4, R4, #1			; add one to row of smallArray
	SUB	R3, R3, #M			; set column back
	SUB	R5, R5, #M			; set column back
	SUB	R3, R3, #1
	SUB	R5, R5, #1
	CMP	R4, #M				; if (row == rowSize)
	BHS	subArrayConfirmed		; there is a subArray
	B	nextElement
noMatrix	
	POP	{LR, R2-R5}
	BX	LR

;
; test data
;

LARGE_A	DCD	 0, 1, 2, 44,  3, 17, 26
	DCD	  6,  4, 5, 18, 14, 33, 16
	DCD	 6, 7,  8, 22,  7, 48, 21
	DCD	 27, 19, 44, 49, 44, 18, 10
	DCD	 29, 17, 22,  4, 0, 1, 2
	DCD	 37, 35, 38, 34, 4, 4, 5
	DCD	 17,  0, 48, 15, 6, 7, 9

SMALL_A	DCD	 0, 1, 2
	DCD	  4, 4, 5
	DCD	 6, 7, 8

	END
