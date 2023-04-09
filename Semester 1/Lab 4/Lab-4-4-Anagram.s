;
; CSU11021 Introduction to Computing I 2019/2020
; Anagrams
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr1	; first string
	LDR	R1, =tststr2	; second string
	
	BL	stringCopy	; copies string 2
	
	LDR	R5, ='A'
	LDR	R6, ='Z'
	LDR	R7, ='a'
	LDR	R8, ='z'

	LDR	R4, =0x7E	; R4 = ~
forLoop1
	LDRB	R2, [R0]	; load ch1
	CMP	R2, #0		; while (ch1 != 0)
	BEQ	finishForLoop1	; {
	CMP	R2, R5
	BLO	endLoop
	CMP	R2, R6
	BHI	nextCheck
nextCheck
	CMP	R2, R7
	BLO	forLoop2
	CMP	R2, R8
	BHI	endLoop
	LDR	R1, =0x40000000	; load addr of StringCopy
forLoop2
	LDRB	R3, [R1]	; load ch2
	CMP	R3, #0		; while (ch2 != 0)
	BEQ	finishForLoop2	; {
	CMP	R2, R3		; if (ch1 == ch2)
	BNE	nextCharacter	; {
	STRB	R4, [R1]	; store ~ in StringCopy
	B	endLoop		; }
nextCharacter			; }
	ADD	R1, R1, #1	; add one to the address
	B	forLoop2	; }
endLoop
	ADD	R0, R0, #1	; add one to addr1
	B	forLoop1	; }
finishForLoop2
	MOV	R0, #0		; strings are not anagrams
	B	endProgram
finishForLoop1
	MOV	R0, #1		; strings are anagrams
endProgram

STOP	B	STOP

stringCopy
	LDR	R1, =tststr2	; address of existing string
	LDR	R2, =0x40000000	; address for new string
while

	LDRB	R3, [R1]	; load with character from existing string
	CMP	R3, #0x00	; while (ch != 0x00) 
	BEQ	finish		; {
	STRB	R3, [R2]	;  Memory.byte[address] = char
	ADD	R1, R1, #1	; adds one to the address to check next character
	ADD	R2, R2, #1	; adds one to the address to store next character
	B	while
finish
	BX	LR

tststr1	DCB	"dirt!y room",0
tststr2	DCB	"dorm2itory",0


	END
