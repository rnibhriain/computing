;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Matrix Multiplication
;

N	EQU	4		

	AREA	globals, DATA, READWRITE

; result array
ARR_R	SPACE	N*N*4		; N*N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40000000
	LDR	R10, =ARR_A
	LDR	R11, =ARR_B
	
	
	LDR	R2, =0		; for (i = 0;
ForLoop1
	CMP	R2, #N		; i < N;)
	BHS	endForLoop1	;  {
	LDR	R3, =0		; for (j = 0;
ForLoop2
	CMP	R3, #N		; j < N;)
	BHS	endForLoop2	; {
	LDR	R4, = 0		; r = 0
	LDR	R5, = 0		;  for (k =0;
ForLoop3
	CMP	R5, #N		; k <N; )
	BHS	endForLoop3	; {
	MOV	R0, #4
	MUL	R12, R2, R0	; row * row size
	ADD	R7, R12, R5	; i + k
	LDR	R8, [R10, R7, LSL#2]	; R8 = A[i, k]
 	MUL	R12, R5, R0	; row * row size
	ADD	R7, R12, R3	; k + j
	LDR	R9, [R11, R7, LSL#2]	; R9 = B[k, j]
	MUL	R7, R8, R9	; A[i, k] * B[k, j]
	ADD	R4, R4, R7	; r = r + (A[i, k] * B[k, j])
	ADD	R5, R5, #1	; k++
	B	ForLoop3
endForLoop3
	MUL	R12, R2, R0
	ADD	R6, R12, R3	; i + j
	LDR	R0, =0x40000000
	STR	R4, [R0, R6, LSL#2]		; R[i, j
	ADD	R3, R3, #1	; j++
	B	ForLoop2	; }
endForLoop2	
	ADD	R2, R2, #1	; i++
	B	ForLoop1	; }
endForLoop1


STOP	B	STOP


ARR_A	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

ARR_B	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

	END
