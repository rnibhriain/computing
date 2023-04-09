;
; CSU11021 Introduction to Computing I 2019/2020
; Convert a sequence of ASCII digits to the value they represent
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R1, ='2'	; Load R1 with ASCII code for symbol '2'
	LDR	R2, ='0'	; Load R2 with ASCII code for symbol '0'
	LDR	R3, ='3'	; Load R3 with ASCII code for symbol '3'
	LDR	R4, ='4'	; Load R4 with ASCII code for symbol '4'

	MOV	R5, #0x30	; 
	SUB	R1, R1, R5	; converts number 2 to decimal
	SUB	R2, R2, R5	; converts number 0 to decimal
	SUB	R3, R3, R5	; converts number 3 to decimal
	SUB	R4, R4, R5	; converts number 4 to decimal
	MOV	R6, #1000	; 
	MUL	R0, R1, R6	; converts 2 to 2000
	MOV	R6, #100	; 
	MUL	R6, R2, R6	; converts 0 to 0
	ADD	R0, R0, R6	; R0 = 2000
	MOV	R6, #10		; 
	MUL	R6, R3, R6	; converts 3 to 30
	ADD	R0, R0, R6	; R0 = 2030
	ADD	R0, R0, R4	; R0 = 2034 / 0x7F2
	
	
STOP	B	STOP

	END
