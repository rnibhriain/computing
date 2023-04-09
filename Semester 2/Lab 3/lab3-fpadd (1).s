;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_A	EQU	0xbfe00000
FP_B	EQU	0x3f800000
	
	


	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	LDR	R0, =FP_A
	BL	fpexp
	MOV	R2, R0
	
	
	LDR	R0, =FP_A
	BL	fpfrac
	
	MOV	R1, R2
	BL	fpencode
	
	LDR	R0, =FP_B
	LDR	R1, =FP_A
	BL	addValues
	



stop	B	stop

; switchFromTwosComplement
; switches a value from two's complement bsck if it is negative and ORRS it with the one bit and then switches it back to
; two's complement
; parameters:
; 	R0 - number to switch
; return
;	R0 - number switched
switchFromTwosComplement
	PUSH	{LR, R4-R5}		; push the registers
	SUB	R0, R0, #1		; take one away
	LDR	R4, =0xFFFFFFFF
	EOR	R0,  R0, R4		; invert all bits
	LDR	R5, =0x800000	
	ORR	R0, R0, R5		; add the one
	EOR	R0,  R0, R4		; invert all bits
	ADD	R0, R0, #1		; add the one
; should be back in two's complement now
	POP	{LR, R4-R5}		; pop the registers
	BX	LR			; return


; addValues
; adds two IEEE 754 floating point values and returns the result as an IEEE 754 value in R0
; parameters:
;	R0 - First IEEE 754 float
;	R1 - Second IEEE 754 float
; return:
;	R0 - Addition of Both Values as an IEEE 754 float

addValues
	PUSH	{LR, R4-R12}		; push the registers
	MOV	R4, R0			; move firstValue to R4
	MOV	R5, R1			; move SecondValue to R5

; firstValue setup

	BL	fpfrac			; get fraction of firstValue
	MOV	R6, R0			; fraction of firstValue
	MOV	R0, R4			; set R0 to firstValue
	BL	fpexp			; get exponent of firstValue
	MOV	R7, R0			; exponent of FirstValue

; secondValue setup
	
	MOV	R0, R5			; set R0 to secondValue
	BL	fpfrac			; get fraction of secondValue 
	MOV	R8, R0			; fraction of secondValue
	MOV	R0, R5			; set R0 to secondValue
	BL	fpexp			; get exponent of secondValue
	MOV	R9, R0			; exponent of secondValue
	

	LDR	R12, =0x800000	
	MOVS	R1, R4, LSL#1		; check if negative
	BCC	else1			; if (negative = true) { 
	MOV	R0, R6			; 	move fraction to R0
	BL	switchFromTwosComplement;	branch to orr the one with the signed value
	MOV	R6, R0			; 	move the fraction back
	B	nextFraction		; }
else1
	ORR	R6, R6, R12		; add the one
nextFraction
	MOVS	R1, R5, LSL#1		; check if negative
	BCC	else2			; if (negative = true) { 
	MOV	R0, R8			; 	move fraction to R0
	BL	switchFromTwosComplement;	branch to orr the one with the signed value
	MOV	R8, R0			; 	move the fraction back
	B	sort			; }
else2
	ORR	R8, R8, R12		; add the one
	
; sort exponents	
sort
	CMP	R7, R9			; while (fV.e != sV.e)
	BEQ	nextStep		; {
	CMP	R7, R9			; 	if (V.e < sV.e)
	BGT	nextTry			; 	{
	ADD	R7, R7, #1		; 		fV.e++
	MOVS	R2, R6, LSL#1		;		if (negative) 
	BCC	shift2			; 		{
	MOV	R6, R6, LSR#1		;			sV.f >> 1
	LDR	R2, =0x80000000		;			
	ORR	R6, R6, R2		;			add the sign bit
	B	sort			;		}
shift2
	MOV	R6, R6, LSR#1		;		fV.f >>	1
	B	sort			; 	}
nextTry					; 	else {
	ADD	R9, R9, #1		;		sV.e++
	MOVS	R2, R8, LSL#1		;		if (negative) 
	BCC	shift			; 		{
	MOV	R8, R8, LSR#1		;			sV.f >> 1
	LDR	R2, =0x80000000		;			
	ORR	R8, R8, R2		;			add the sign bit
	B	sort			;		}
shift					;	
	MOV	R8, R8, LSR#1		;		sV.f >> 1
	B	sort			; 	}
nextStep				; }

; Add the fractions
	ADD	R10, R6, R8		; firstValue.fraction + secondValue.fraction
	
; Normalize the result
	MOVS	R1, R10, LSL#1
	BCC 	keepGoing
	SUB	R10, R10, #1		; take one away
	LDR	R4, =0xFFFFFFFF
	EOR	R10,  R10, R4		; invert all bits
	LDR	R3, =1
keepGoing
	MOV	R11, R10, LSR#23	; 
normalize
	CMP	R11, #1			; while (notNormalised) 
	BEQ	finishAlgorithm		; {
	CMP	R11, #1			; 	if ( normalisedBit > 1)
	BLO	higherThan		;	{
	MOV	R11, R11, LSR#1		; 		normalisedBit >> 1
	MOV	R10, R10, LSR#1		;		fraction >> 1
	ADD	R9, R9, #1		;		exponenent++
	B	normalize		;	}
higherThan				; 	else {
	AND	R2, R10, R12		; 		find the normalizedBit
	CMP	R2, #0			;		if (normalizedBit == 0)
	BNE	finishAlgorithm		;		{						
	MOV	R10, R10, LSL#1		;			fraction << 1
	SUB	R9, R9, #1		;			exponent--
					;		}
	B	normalize		;	}
finishAlgorithm				; }
	MOV	R0, R10			; fraction
	CMP	R3, #1
	BNE	continue
	LDR	R4, =0xFFFFFFFF
	EOR	R0,  R0, R4		; invert all bits
	ADD	R0, R0, #1
continue
	MOVS	R1, R0, LSL#1		;
	BCC	nextBit			;
	PUSH	{R4-R5}			; push the registers
	SUB	R0, R0, #1		; take one away
	LDR	R4, =0xFFFFFFFF
	EOR	R0,  R0, R4		; invert all bits
	LDR	R5, =0x800000	
	BIC	R0, R0, R5		; add the one
	EOR	R0,  R0, R4		; invert all bits
	ADD	R0, R0, #1		; add the one
; should be back in two's complement now
	POP	{R4-R5}		; pop the registers
	B	lastPart
nextBit
	BIC	R0, R0, R12
lastPart
	
	MOV	R1, R9			; exponent
	BL	fpencode		; encode the value
	POP	{LR, R4-R12}		; pop the registers
	BX	LR			; return
	
	
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
	LDR	R7, =0
	MOVS	R4, R4, LSL#1		; check if negative
	BCC	notNegative		;
	MOV	R7, #1			; negative = true
notNegative
	MOV	R4, R4, LSL#8		; get rid of signed value and exponent
	MOV	R6, R4, LSR#9		; fraction
	CMP	R7, #0			; if (Negative = true) 
	BEQ	finish			; {
	LDR	R5, =0xFFFFFFFF
	EOR	R8,  R6, R5		; 	invert all bits
	MOV	R6, R8
	ADD	R6, R6, #1		;	
finish				; }
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
	LDR	R7, =0
	CMP	R4, #127		; if (exponent == 0) 
	BNE	nextCheck		; {
	MOV	R7, #0			; 	exponent =0;
	B	finish1			; }
nextCheck
	CMP	R4, #127		; else if (ex < 127)
	BHS	lastBit			; {
firstWhile
	CMP	R4, #127		; 	while (ex < 127)
	BEQ	finish1			; 	{
	ADD	R4, R4, #1		; 		ex++
	SUB	R7, R7, #1		;		exp--
	B	firstWhile		;	 }
lastBit					; }
	CMP	R4, #127		; else { while (ex > 127)
	BEQ	finish1			; 	{
	SUB	R4, R4, #1		; 		ex--
	ADD	R7, R7, #1		;		exp++	
	B	lastBit			; 	}
finish1					; }
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
	ADD	R0, R0, #1		; 	set the sign
; fraction bit
	SUB	R4, R4, #1		; 	take one away from fraction
	LDR	R6, =0xFFFFFFFF		;
	EOR	R4, R4, R6		; 	Invert all bits
noNegative				; }
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
