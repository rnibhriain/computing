;
; CS1022 Introduction to Computing II 2019/2020
; Polling Example
;

; TIMER0 registers
T0TCR		EQU	0xE0004004
T0TC		EQU	0xE0004008
T0MR0		EQU	0xE0004018
T0MCR		EQU	0xE0004014

; Pin Control Block registers
PINSEL4		EQU	0xE002C010

; GPIO registers
FIO2DIR1	EQU	0x3FFFC041
FIO2PIN1	EQU	0x3FFFC055

	AREA	RESET, CODE, READONLY
	ENTRY

whLoop
	LDR	R0, =1		; winner = TRUE

	; Enable P2.10 for GPIO
	LDR	R4, =PINSEL4	; load address of PINSEL4
	LDR	R5, [R4]	; read current PINSEL4 value
	BIC	R5, #(0x3 << 20); modify bits 20 and 21 to 00
	STR	R5, [R4]	; write new PINSEL4 value

	; Set P2.10 for input
	LDR	R4, =FIO2DIR1	; load address of FIO2DIR1

	NOP			; on "real" hardware, we cannot place
				; an instruction at address 0x00000014
	LDRB	R5, [R4]	; read current FIO2DIR1 value
	BIC	R5, #(0x1 << 2)	; modify bit 2 to 0 for input, leaving other bits unmodified
	STRB	R5, [R4]	; write new FIO2DIR1
	
	
	LDR	R1, =500000	; min time
	LDR	R2, =800000	; max time
	

	BL	waitBtnDn
	; Reset TIMER0 using Timer Control Register
	;   Set bit 0 of TCR to 0 to stop TIMER
	;   Set bit 1 of TCR to 1 to reset TIMER
	LDR	R5, =T0TCR
	LDR	R6, =0x2
	STRB	R6, [R5]
	
	; There appears to be a bug in the uVision simulation
	;   of the TIMER peripherals. Setting the RESET bit of
	;   the TCR (above) should reset the TImer Counter (TC)
	;   but does not appear to do so. We can force it back
	;   to zero here.
	LDR	R5, =T0TCR
	LDR	R6, =0x0
	STR	R6, [R5]
	
	; Start TIMER0 using the Timer Control Register
	;   Set bit 0 of TCR to enable the timer
	LDR	R4, =T0TCR
	LDR	R5, =0x01
	STRB	R5, [R4]
	BL	waitBtnDn
	
	; stop the timer
	LDR	R5, =T0TCR
	LDR	R6, =0x1
	STRB	R6, [R5]
	
	
	LDR 	R10, =T0TC	; elapsed_time = TOTC
	LDR	R3, [R10]
	
	CMP	R3, R1		; if (elapsed_time < min_time 
	BLO	setWinner	; ||
	CMP	R3, R2		; elapsed_time > max_time)
	BLS	noWin		; {
setWinner
	LDR	R0, =0		;	winner = FALSE;
				; }
noWin	
	CMP	R0, #1		; if (!winner)
	BEQ	whLoop		; {
	
	
	; Enable P2.10 for GPIO
	LDR	R5, =PINSEL4	; load address of PINSEL4
	LDR	R6, [R5]	; read current PINSEL4 value
	BIC	R6, #(0x3 << 20); modify bits 20 and 21 to 00
	STR	R6, [R5]	; write new PINSEL4 value

	; Set P2.10 for output
	LDR	R5, =FIO2DIR1	; load address of FIO2DIR1
	NOP
	LDRB	R6, [R5]	; read current FIO2DIR1 value
	ORR	R6, #(0x1 << 2)	; modify bit 2 to 1 for output, leaving other bits unmodified
	STRB	R6, [R5]	; write new FIO2DIR1
	; read current P2.10 output value
	;   0 or 1 in bit 2 of FIO2PIN1
	LDR	R4, =0x04		;   setup bit mask for P2.10 bit in FIO2PIN1
	LDR	R5, =FIO2PIN1		;
	LDRB	R6, [R5]		;   read FIO2PIN1

	; modify P2.10 output (leaving other pin outputs controlled by
	;   FIO2PIN1 with their original value)
	TST	R6, R4			;   if (LED off)  TST Ry, Rz
	BNE	elsOff			;   {
	ORR	R6, R6, R4		;     set bit 2 (turn LED on)
	B	endIf			;   }
elsOff					;   else {
	BIC	R6, R6, R4		;     clear bit 2 (turn LED on)
endIf					;   }

	; write new FIO2PIN1 value
	STRB	R6, [R5]

	
	
	B	whLoop		; }
	

STOP	B	STOP
		
waitBtnDn
	PUSH	{LR, R4-R8}
	LDR	R4, =FIO2PIN1	; load address of FIO2PIN1

whRepeat			; while (forever) {
	LDRB	R6, [R4]	;   lastState = FIO2PIN1 & 0x4

	AND	R6, R6, #0x4	;

	; keep testing pin state until it changes

whPoll				;   do {
	LDRB	R5, [R4]	;     currentState = FIO2PIN1 & 0x4
	AND	R5, R5, #0x4	;
	CMP	R5, R6		;
	BEQ	whPoll		;   } while (currentState == lastState)

	; pin state has changed ... but has it changed to 0?

	CMP	R5, #0		;   if (currentState == 0) {
	BNE	eIf		;

	B	whBtnDn		; branch to next Part
eIf
	B	whRepeat	; }
whBtnDn	
	MOV R8 , R5 		; lastState = currentState ;
 	LDRB R5 , [ R4 ] 	; currentState = FIO2PIN1 ;
 	TST R5 , #0x04 		; } while (currentState & 0x04 != 0x00
 	BNE whBtnDn 		;
 	TST R8 , #0x04 		; || lastState & 0x04 == 0x00 ) ;
 	BEQ whBtnDn 		;

	POP {LR, R4-R8}		;
	BX	LR		; 
	
	END
