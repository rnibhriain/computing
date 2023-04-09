;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_A	EQU	0x412C0000
FP_B	EQU	0x3FA00000


	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	LDR	R0, =FP_B
	BL	fpexp
	MOV	R2, R0
	
	
	LDR	R0, =FP_B
	BL	fpfrac
	
	MOV	R1, R2
	BL	fpencode


stop	B	stop


;
; fpfrac
; decodes an IEEE 754 floating point value to the signed (2's complement)
; fraction
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - fraction (signed 2's complement word)
;
fpfrac
	PUSH	{LR, R4-R8}		; push the registers
	MOV	R4, R0			; move value to register 4
	MOVS	R4, R4, LSL#1		; check if negative
	BCC	notNegative		;
	MOV	R7, #1			; negative = true
notNegative
	MOV	R4, R4, LSL#8		; get rid of signed value and exponent
	MOV	R6, R4, LSR#9		; fraction
	CMP	R7, #0			; if (Negative = true) 
	BEQ	finish			; {
	LDR	R5, =0xFFFFFFFF
	EOR	R8,  R6, R5		; invert all bits
	MOV	R6, R8
	ADD	R6, R6, #1
finish
	MOV	R0, R6			; move fraction into R0
	POP	{LR, R4-R8}		; pop the registers
	BX	LR			; return
	


;
; fpexp
; decodes an IEEE 754 floating point value to the signed (2's complement)
; exponent
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - exponent (signed 2's complement word)
;
fpexp
	PUSH	{LR, R4-R8}		; push the registers
	MOV	R4, R0			; value
	MOV	R4, R4, LSL#1		; check if negative
	MOV	R4, R4, LSR#24
	MOV	R7, #0
	CMP	R4, #127		; if (exponent == 0) 
	BNE	nextCheck		; {
	MOV	R7, #0			; exponent =0;
	B	finish1			; }
nextCheck
	CMP	R4, #127		; else if (ex < 127)
	BHS	lastBit			; {
firstWhile
	CMP	R4, #127		; while (ex < 127)
	BEQ	finish1			; {
	ADD	R4, R4, #1		; ex++
	SUB	R7, R7, #1		;
	B	firstWhile		; }
lastBit					; }
	CMP	R4, #127		; while (ex > 127)
	BEQ	finish1			; {
	SUB	R4, R4, #1		; ex--
	ADD	R7, R7, #1		;
	B	lastBit			; }
finish1
	MOV	R0, R7
	POP	{LR, R4-R8}		; pop the registers
	BX	LR			; return


;
; fpencode
; encodes an IEEE 754 value using a specified fraction and exponent
; parameters:
;	r0 - fraction (signed 2's complement word)
;	r1 - exponent (signed 2's complement word)
; result:
;	r0 - ieee 754 float
;
fpencode

	PUSH	{LR, R4-R8}		; push the registers
	MOV	R4, R0			; fraction
	MOV	R5, R1			; exponent
	MOV	R0, #0			; float = 0
; sign bit
	MOVS	R6, R4, LSL#1		; check the sign
	BCC	noNegative		; if (s = true) {
	ADD	R0, R0, #1		; set the sign
; fraction bit
	SUB	R4, R4, #1		; take one away from fraction
	LDR	R6, =0xFFFFFFFF		;
	EOR	R4, R4, R6		; Invert all bits
noNegative
	MOV	R0, R0, LSL#8		; leave space for exponent
	LDR	R7, =127
	ADD	R5, R7, R5		; use the bias
next
	ADD	R0, R0, R5		; add the exponent
	MOV	R0, R0, LSL#23		; leave space for the fraction
	ADD	R0, R0, R4		; add the fraction
	POP	{LR, R4-R8}		; pop the registers
	BX	LR			; return


	END
