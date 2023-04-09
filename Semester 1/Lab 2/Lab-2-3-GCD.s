;
; CSU11021 Introduction to Computing I 2019/2020
; GCD
;

	AREA	RESET, CODE, READONLY
	ENTRY
	
	MOV	R2, #24		; a = 24
	MOV	R3, #32		; b = 32
startWhile
	CMP	R2, R3		; while (a != b)
	BEQ	finishWhile	; {
	CMP	R2, R3		; if (a > b)
	BLS	elseStatement	; {
	SUB	R2, R2, R3	; a = a - b
	B	startWhile	; else {
elseStatement
	SUB	R3, R3, R2	; b = b - a
	B	startWhile	; }
finishWhile			; }
	MOV	R0, R2		; R0 = GCD




STOP	B	STOP

	END