;
; CSU11021 Introduction to Computing I 2019/2020
; Adding the values represented by ASCII digit symbols
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R1, ='2'	; Load R1 with ASCII code for symbol '2'
	LDR	R2, ='4'	; Load R2 with ASCII code for symbol '4'

	MOV	R3, #0x30	
	SUB	R4, R1, R3	; converts number 1 to decimal
	SUB	R5, R2, R3	; converts number 2 to decimal
	ADD	R0, R4, R5	; adds two numbers
	ADD	R0, R0, R3	; converts back to hex

STOP	B	STOP

	END
