;
; CSU11021 Introduction to Computing I 2019/2020
; Proper Case
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr	; address of existing string
	LDR	R1, =0x40000000	; address for new string
	
	LDR	R3, ='a'	; 
	LDR	R4, ='z'	;
	LDR	R5, ='A'	;
	LDR	R6, ='Z'	;
			
	LDRB	R2, [R0]	; load character into R2
	BL	lowerCaseToUpperCase ; branch to change first letter to uppercase
	STRB	R2, [R1]	; store the character in address2
whileLoop			
	ADD	R0, R0, #1	; add one to address 1
	ADD	R1, R1, #1	; add one to address 2
	LDRB	R2, [R0]	; load character into R2 again
	CMP	R2, #0x00	; while (ch! = 0x00) 
	BEQ	finishWhileLoop	; {
	CMP	R2, #0x20	; if (ch==space)
	BNE	elseStatement	; {
	STRB	R2, [R1]	; store space into address 2
	ADD	R1, R1, #1	; add one to address 1
	ADD	R0, R0, #1	; add one to address 2
	LDRB	R2, [R0]	; load character into R2
	BL	lowerCaseToUpperCase ; branch to switch character to upperCase
	STRB	R2, [R1]	; store character into address 2
	B	finishIf	; branch past elseStatement
elseStatement			
	BL	upperCaseToLowerCase ; branch to make sure character is lowercase
	STRB	R2, [R1]	; store character into address 2
finishIf			
	B	whileLoop	; }
finishWhileLoop	

STOP	B	STOP

tststr	DCB	"hello WORLD",0



lowerCaseToUpperCase
	CMP	R2, R3		;
	BLO	endComparison	;
	CMP	R2, R4		;
	BHI	endComparison	;
	SUB	R2, R2, #0x20	;
endComparison			;
	BX	LR
	
	
upperCaseToLowerCase
	CMP	R2, R5		;
	BLO	finishComparison ; 
	CMP	R2, R6		;
	BHI	finishComparison;
	ADD	R2, R2, #0x20	;
finishComparison
	BX	LR		;

	END
