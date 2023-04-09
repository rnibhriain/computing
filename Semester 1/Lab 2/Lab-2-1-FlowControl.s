;
; CSU11021 Introduction to Computing I 2019/2020
; Flow Control
;

	AREA	RESET, CODE, READONLY
	ENTRY

; (i) 
; i f ( h >= 1 3 )
; }
; 	h = h - 12;
; }

	MOV	R1, #15		; h = 15
	CMP	R1, #13		; if (h >= 13)
	BLO	finish_first_if	; {
	SUB	R1, R1, #12	; h = h - 12
finish_first_if			; }
	
; (ii)
; if (a > b) {
;	i = i + 1;
; } else {
;	i = i - 1;
; }

	MOV	R0, #0		; i = 0
	MOV	R1, #13		; a = 13
	MOV	R2, #10		; b = 10
	CMP	R1, R2		; If (a > b)
	BLS	elseOption	; {
	ADD	R0, R0, #1	; i = i + 1
	B	endCmp		; }
elseOption			; else {
	SUB	R0, R0, #1	; i = i - 1
endCmp				; }

; (iii)
; if (v < 10) {
; 	a = 1;
; }
; else if (v < 100) {
; 	a = 10;
; }
; else if (v < 1000) {
; 	a = 100;
; }
; else {
; 	a = 0;
; }

	MOV	R1, #18		; v = 18
	CMP	R1, #10		; if (v < 10)
	BHS	finishFirstComparison ;	{
	MOV	R0, #1		; a = 1
	B	endiii		; }
finishFirstComparison
	CMP	R1, #100	; else if (v < 100) 
	BHS	finishSecondComparison ; {
	MOV	R0, #10		; a = 10
	B	endiii		; }
finishSecondComparison		
	CMP	R1, #1000	; else if (v < 1000)
	BHS	finishThirdComparison ; {
	MOV	R0, #100	; a = 100
	B	endiii		; }
finishThirdComparison		; else {
	MOV	R0, #0		; a = 0
endiii

; (iv)
; i = 3;
; while (i < 1000) {
; 	a = a + i;
; 	i = i + 3;
; }
	
	MOV	R0, #0		; a = 0
	MOV	R1, #3		; i = 3
startWhile
	CMP 	R1, #1000	; while (i < 1000)
	BHS	endWhile	; {
	ADD	R0, R0, R1	; a = a + i
	ADD	R1, R1, #3	; i = i + 3
	B	startWhile	; }
endWhile

; (v) 
; for (int i = 3; i < 1000; i = i + 3) {
; 	a = a + i;
; }

	MOV	R0, #0		; a = 0
	MOV	R1, #3		; i = 3
forLoop
	CMP	R1, #1000	; for (int i = 3; i <1000; i = i +3)
	BHS	endForLoop	; {
	ADD	R0, R0, R1	; a = a + i
	ADD	R1, R1, #3	; i = i + 3
	B	forLoop		; }
endForLoop

; (vi)
; p = 1;
; do {
; 	p = p * 10;
; } while (v < p);

	MOV	R0, #0 		; v = 0
	MOV	R1, #1		; p = 1
	MOV	R2, #10		; R2 = 10
doWhile
	MUL	R1, R2, R1	; p = p *10
	CMP 	R0, R1		; while (v < p)
	BHS	endDoWhile	;
	B	doWhile		;
endDoWhile


; (vii)
; if (ch >= 'A' && ch <= 'Z') {
; 	upper = upper + 1;
; }
	
	MOV	R0, #0		; upper = 0
	LDR	R1, ='R'	; ch = 'R'
	LDR	R2, ='A'	; R2 = 'A'
	LDR	R3, ='Z'	; R3 = 'Z'
	CMP	R1, R2		; if (ch >= 'A')
	BLO	endvii		; &&
	CMP	R1, R3		; if (ch <= 'Z')
	BHI	endvii		; {
	ADD	R0,R0, #1	; upper = upper + 1
endvii				; }
	

; (viii)
; if (ch=='a' || ch=='e' || ch=='i' || ch=='o' || ch=='u')
; {
; 	v = v + 1;
; }

	MOV	R0, #0		; v = 0
	LDR	R1, ='e'	; ch = 'e'
	LDR	R2, ='a'	; R2 = 'a'
	LDR	R3, ='e'	; R3 = 'e'
	LDR	R4, ='i'	; R4 = 'i'
	LDR	R5, ='o'	; R5 = 'o'
	LDR	R6, ='u'	; R6 = 'u'
	CMP	R1, R2		; if (ch == 'a'
	BEQ	startIf		; ||
	CMP	R1, R3		; ch == 'e'
	BEQ	startIf		; ||
	CMP	R1, R4		; ch == 'i'
	BEQ	startIf		; ||
	CMP	R1, R5		; ch == 'o'
	BEQ	startIf		; ||
	CMP	R1, R6		; ch == 'u'
	BEQ	startIf		; )
	B	endviii		; {
startIf
	ADD	R0, R0, #1	; v = v + 1
endviii				; }

STOP	B	STOP

	END
