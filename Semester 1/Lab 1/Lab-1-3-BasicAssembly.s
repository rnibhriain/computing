;
; CSU11021 Introduction to Computing I 2019/2020
; Basic ARM Assembly Language
;

	AREA	RESET, CODE, READONLY
	ENTRY

; Write your solution for all parts (i) to (iv) below.

; Tip: Right-click on any instruction and select 'Run to cursor' to
; "fast forward" the processor to that instruction.

; (i) 3x+y

	LDR	R1, =2		; x = 2
	LDR	R2, =3		; y = 3
	
	MOV	R0, #3		; R0 = 3
	MUL	R0, R1, R0	; R0 = 3x
	ADD	R0, R0, R2	; R0 = 3x + y 
	


; (ii) 3x^2+5x

	LDR	R1, =2		; x = 2
	
	MUL	R0, R1, R1	; R0 = x*x
	MOV	R2, #3		; R2 = 3
	MUL	R0, R2, R0	; R0 = 3*x*x
	MOV	R2, #5		; R2 = 5
	MUL	R2, R1, R2	; R2 = 5*x
	ADD	R0, R0, R2	; R0 = (3*x*x) + (5*x)

	


; (iii) 2x^2+6xy+3y^2

	LDR	R1, =2		; x = 2
	LDR	R2, =3		; y = 3
	
	MUL	R0, R1, R1	; R0 = x*x
	MOV	R3, #2		; R3 = 2
	MUL	R0, R3, R0	; R0 = 2*x*x
	MOV	R3, #6		; R3 = 6
	MUL	R3, R1, R3	; R3 = 6*x
	MUL	R3, R2, R3	; R3 = 6*x*y
	ADD	R0, R0, R3	; R0 = (2*x*x) + (6*x*y)
	MOV	R3, #3		; R3 = 3
	MUL	R3, R2, R3	; R3 = 3*y
	MUL	R3, R2, R3	; R3 = 3*y*y
	ADD	R0, R0, R3	; R0 = (2*x*x) + (6*x*y) + (3*y*y)


; (iv) x^3-4x^2+3x+8

	LDR	R1, =2		; x = 2
	LDR	R2, =3		; y = 3

	MUL	R0, R1, R1	; R0 = x*x
	MOV	R3, #4		; R3 = 4
	MUL	R3, R0, R3	; R3 = 4*x*z
	MUL 	R0, R1, R0	; R0 = x*x*x
	SUB	R0, R0, R3	; R0 = (x*x*x) - (4*x*x)
	MOV	R3, #3		; R3 = 3
	MUL	R3, R1, R3	; R3 = 3*x
	ADD	R0, R0, R3	; R0 = (x*x*x) - (4*x*x) + (3*x)
	ADD	R0, R0, #8	; R0 = (x*x*x) - (4*x*x) + (3*x) + 8


STOP	B	STOP

	END
