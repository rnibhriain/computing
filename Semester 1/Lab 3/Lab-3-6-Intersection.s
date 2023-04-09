;
; CSU11021 Introduction to Computing I 2019/2020
; Intersection
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; address of sizeC
	LDR	R1, =0x40000004	; address of elemsC
	
	LDR	R6, =sizeA	; address of sizeA
	LDR	R2, [R6]	; load sizeA
	LDR	R3, =elemsA	; address of elemsA
	
	LDR	R6, =sizeB	; address of sizeB
	LDR	R4, [R6]	; load sizeB
	LDR	R5, =elemsB	; address of elemsB

	MOV	R7, #0		; for (int firstSetElement;
forLoop1
	CMP	R7, R2		; firstSetElement < setSize1;
	BHS	endForLoop1	; ) {
	MOV	R8, #0		; for (int secondSetElement = 0;
	LDR	R5, =elemsB	; address of elemsB
forLoop2
	CMP	R8, R4		; secondSetElement <  setSize2;
	BHS	endForLoop2	; ) {
	LDRB	R9, [R3]	; load character into R9
	LDRB	R10, [R5]	; load second character into R10
	CMP	R9, R10		; if (ch1 == ch2)
	BNE	finishIf	; {
	STRB	R9, [R1]	; store character into addr3
	ADD	R1, R1, #1	; add one to addr3
	B	endForLoop2	; end second for loop
finishIf		
	ADD	R8, R8, #1	; secondSetElement++
	ADD	R5, R5, #4	; go to next addr2
	B	forLoop2	; }
endForLoop2
	ADD	R7, R7, #1	; firstSetElement++
	ADD	R3, R3, #4	; go to next addr3
	B	forLoop1	; }
endForLoop1

STOP	B	STOP

sizeA	DCD	5
elemsA	DCD	7, 14, 6, 3, 7

sizeB	DCD	9
elemsB	DCD	20, 3, 14, 5, 7, 2, 9, 12, 17

	END
