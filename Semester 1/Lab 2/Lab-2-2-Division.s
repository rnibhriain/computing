;
; CSU11021 Introduction to Computing I 2019/2020
; Division (inefficient!)
;

	AREA	RESET, CODE, READONLY
	ENTRY

	MOV	R2, #12		; a = 12
	MOV	R3, #6		; b = 6
	MOV	R0, #0		; Q = 0
	MOV	R1, R2		; R = a
while	
	CMP	R1, R3		; while (a > b)
	BLO	endWhile	; {
	SUB	R1, R1, R3	; R = a - b
	ADD	R0, R0, #1	; Q++
	B	while
endWhile


STOP	B	STOP

	END
