;
; CSU11021 Introduction to Computing I 2019/2020
; 64-bit Shift
;

	AREA	RESET, CODE, READONLY
	ENTRY


	LDR	R1, =0xD9448A9B		; most significaint 32 bits (63 ... 32)
	LDR	R0, =0xB8AA9D3B		; least significant 32 bits (31 ... 0)
	LDR	R2, =-2			; shift count
	LDR	R3, =0x01
	LDR	R4, =0x80000000

while	
	CMP	R2, #0			; while (count != 0)
	BEQ	finishWhile		; {
	
	CMP	R2, #0			; if (count > 0)
	BLE	noIf1			; {
	MOV	R0, R0, LSR #1		; right shift leastsignificant bits
	MOVS	R1, R1, LSR #1		; right shift mostsignificant bits
	BCC	noSet			;
	ORR	R0, R0, R4		; 
noSet
	SUB	R2, R2, #1		; count--
noIf1					; }
	CMP	R2, #0			; else if (count < 0)
	BGE	noIf2			; {
	MOV	R1, R1, LSL #1		; left shift most significant bits
	MOVS	R0, R0, LSL #1		; left shift least significant bits
	BCC	noSet2			;
	ORR	R1, R1, R3		;
noSet2
	ADD	R2, R2, #1		; count++
noIf2					; }
	B	while			; }
finishWhile
	
	
	
		
STOP	B	STOP

	END
