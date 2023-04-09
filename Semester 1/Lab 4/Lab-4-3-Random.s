;
; CSU11021 Introduction to Computing I 2019/2020
; Pseudo-random number generator
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; start address for pseudo-random sequence
	LDR	R1, =64		; number of pseudo-random values to generate
	LDR	R2, =13		; m = 13 modulus
	LDR	R3, =7		; a = 7  multiplier
	LDR	R4, =9		; c = 9  increment
	LDR	R5, =12		; x0 = 12 start value
while
	CMP	R1, #0		; while (N!=0) 
	BEQ	finishWhile	; {
	MUL	R5, R3, R5	; a*Xn
	ADD	R5, R5, R4	; a*Xn + c
	BL	getModulus	; (a*Xn + c ) mod m
	STR	R5, [R0]	; store random number in address
	ADD	R0, R0, #4	; go to next address
	SUB	R1, R1, #1	; N--
	B	while		; }
finishWhile



;Xn+1 = (aXn + c) mod m
;where X is the sequence of pseudo-random values
;m, 0 < m  - modulus 
;a, 0 < a < m  - multiplier
;c, 0 = c < m  - increment
;x0, 0 = x0 < m  - the seed or start value

STOP	B	STOP

getModulus
	MOV	R6, R2
	PUSH	{R0, R1, R2, R3, R4}
	MOV	R0, R5		; Xn
	MOV	R1, R6		; m
	LDR	R2, =0		; quotient = 0;
	LDR	R3, =0		; remainder = 0;
	LDR	R4, =0x80000000 ; mask = 0x80000000
while1	
	CMP	R4, #0		; while (mask != 0)
	BEQ	endWhile	; {
	LSL	R3, R3, #1	; remainder = remainder << 1
	AND	R5, R0, R4	; a & mask
	CMP	R5, #0		; if ((a&mask) !=0)
	BEQ	noIf1		; {
	ORR	R3, R3, #1	; remainder = remainder | 1
noIf1				; }
	CMP	R3, R1		; if (remainder >= b)
	BLO	noIf2		; {
	SUB	R3, R3, R1	; remainder = remainder - b
	ORR	R2, R2, R4	; quotient = quotient | mask
noIf2				; }
	LSR	R4, R4, #1	; mask = mask >> 1
	B	while1		; }
endWhile
	MOV	R5, R3		; Xn+1 = (aXn + c) mod m 
	POP	{R0, R1, R2, R3, R4}
	BX	LR

	END
