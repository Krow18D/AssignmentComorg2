.data
val:
	LDR R3,[R2,#8]
	LDR R3,[R2,R5]!
	STR R3,[R2]
	STR R3,[R2,#8]
	STR R3,[R2],R4
	LDRB R3,[R5,#0]
	STRB R3,[R2,#0]
	LDR R3,[R6,R8,LSL #2]
	LDRH R3,[R5,#8]
	LDRSH R3,[R5,#8]
	STRH R3,[R5,#8]
	LDRSB R3,[R5,#8]
	LDRH R3,[R5],#8
	STRH R3,[R5,R6]
	LDRH R3,[R6,#4]!
	LDREQ R3,[R2,#8]
	LDRNE R3,[R2,#12]
	LDRGT R3,[R2,#11]
	LDRGE R3,[R2,#13]
	LDRLT R3,[R2,#26]
	LDRLE R3,[R2,#10]
	STRCS R3,[R2,#2]
	LDRCC R3,[R2,#17]
	LDRMI R3,[R2,#24]
	STRPL R3,[R2,#29]
	LDRAL R3,[R2,#8]
	LDRVS R3,[R2,#12]
	STRVC R3,[R2,#14]
	LDRHI R3,[R2,#21]
	LDRLS R3,[R2,#22]
	.word 0
	.balign 4
mes: .asciz "%x\n"
chr: .asciz "%c"
t_condi: .asciz "EQNECSCCMIPLVSVCHILSGELTGTLE"
t_ldr: .asciz "LDR"
t_str: .asciz "STR"
t_byte: .asciz "B"
t_half: .asciz "H"
t_sign: .asciz "S"
t_wb: .asciz "!"
t_r: .asciz "R%d"
t_opb: .asciz "["
t_clb: .asciz "]"
t_cma: .asciz ","
t_sq: .asciz "#%d"

t_shl: .asciz "LSL#%d"
t_shr: .asciz "LSR#%d"
t_space: .asciz " "
t_nl:.asciz "\n"
	.balign 4
return: .word 0

	.text
	.global main
	.global printf
	.global scanf
main:
	LDR r1, =return @ r1=&return
	STR lr, [r1] @ *r1=lr


@--------data-checker-----------------------------------
	@ ldr r0,=mes
	@ ldr r10,=val
	@ ldr r1,[r10,#60]
	@ @lsr r1,r1,#28
	@ push {r1,r2,r3,r4}
	@ bl printf
	@ pop {r1,r2,r3,r4}
@--------end-data-checker-------------------------------

@------------Start-Here---------------------------------
ldr r10,=val
_loop:
@-----------type-------------------------------
	
	ldr r5,[r10],#4
	cmp r5,#0
	beq _exit_program
	lsl r6,r5,#4
	lsr r6,r6,#30
	cmp r6,#1
	 beq _single
	 cmp r6,#0
	 beq _half
	@ cmp r6,#2
	@ beq _block
@-----------end-type---------------------------

@------------Print-str-ldr------------------------------
_single:

	lsl r6,r5,#11
	lsr r6,r6,#31
	cmp r6,#0
	beq _load_str
	ldr r0,=t_ldr
	b _printstrldr 
_load_str:
	ldr r0,=t_str
_printstrldr:
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@-------condition-------------------------------------
	lsr r6,r5,#28
	cmp r6,#14
	beq _checkbyte
	mov r11,#2
	mul r8,r6,r11
	ldr r9,=t_condi
	ldrb r1,[r9,r8]
	ldr r0,=chr
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	add r8,r8,#1
	ldrb r1,[r9,r8]
	ldr r0,=chr
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@-----------check-byte---------------------------------
_checkbyte:
	lsl r6,r5,#9
	lsr r6,r6,#31
	cmp r6,#0
	beq _space1 
	ldr r0,=t_byte
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@-----------print-space--------------------------------
_space1:	
	ldr r0,=t_space
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}

@----------print-Rd------------------------------------
_printRd:
	lsl r6,r5,#16
	lsr r6,r6,#28
	ldr r0,=t_r
	mov r1,r6
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	@bracket
	ldr r0,=t_opb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@------print-Rn---------------------------------------
	lsl r6,r5,#12
	lsr r6,r6,#28
	ldr r0,=t_r
	mov r1,r6
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@-------check-pre-post---------------------------------
	lsl r6,r5,#7
	lsr r6,r6,#31
	cmp r6,#1 @if pre
	beq pre_single
	bne post_single
pre_single:
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b checkI_single
post_single:
	@bracket
	ldr r0,=t_clb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b checkI_single
@--------check single-----------
checkI_single:
	lsl r6,r5,#6
	lsr r6,r6,#31
	@ 0 number || 1 register 
	cmp r6,#0
	beq print_im_single
	bne print_reg_single

print_im_single:
	lsl r6,r5,#20
	lsr r6,r6,#20
	ldr r0,=t_sq
	mov r1,r6
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b prepost2

print_reg_single:
	lsl r6,r5,#28
	lsr r6,r6,#28
	ldr r0,=t_r
	mov r1,r6
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@check shift
	lsl r6,r5,#20
	lsr r6,r6,#27
	mov r8,r6
	cmp r6,#0
	bgt leftright_single
	beq prepost2 	

leftright_single:
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	lsl r6,r5,#25
	lsr r6,r6,#30
	cmp r6,#0
	beq left_single
	bne right_single
left_single:
	mov r1,r8
	ldr r0,=t_shl
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b prepost2
right_single:
	mov r1,r8
	ldr r0,=t_shr
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b prepost2


prepost2:
	lsl r6,r5,#7
	lsr r6,r6,#31
	cmp r6,#1 @if pre
	bne check_writeback_single
	ldr r0,=t_clb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}

check_writeback_single:
	lsl r6,r5,#10
	lsr r6,r6,#31
	cmp r6,#0
	beq endof_
	ldr r0,=t_wb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b endof_
@-----------end-single----------------------------------

@-----------half----------------------------------------
_half:
	lsl r6,r5,#11
	lsr r6,r6,#31
	cmp r6,#0
	beq _load_str2
	ldr r0,=t_ldr
	b _printstrldr2
_load_str2:
	ldr r0,=t_str
_printstrldr2:
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}

@-----------check SHB-----------------------------------
	lsl r6,r5,#25
	lsr r6,r6,#30
	cmp r6,#0
	beq endof_
	cmp r6,#1
	beq unsigned_half
	cmp r6,#2
	beq sign_byte
	cmp r6,#3
	beq sign_half

unsigned_half:
	ldr r0,=t_half
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b _space2
sign_byte:
	ldr r0,=t_sign
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	ldr r0,=t_byte
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b _space2
sign_half:
	ldr r0,=t_sign
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	ldr r0,=t_half
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b _space2

@-----------print-space-----------------------
_space2:
	ldr r0,=t_space
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}

_printRd2:
	lsl r6,r5,#16
	lsr r6,r6,#28
	ldr r0,=t_r
	mov r1,r6
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	@bracket
	ldr r0,=t_opb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@---------print-Rn--------------------
	lsl r6,r5,#12
	lsr r6,r6,#28
	ldr r0,=t_r
	mov r1,r6
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
@-------check-pre-post---------------------------------
	lsl r6,r5,#7
	lsr r6,r6,#31
	cmp r6,#1 @if pre
	beq pre_half
	bne post_half
pre_half:
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b checkB_half
post_half:
	@bracket
	ldr r0,=t_clb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	@comma
	ldr r0,=t_cma
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b checkB_half

checkB_half:
	lsl r6,r5,#9
	lsr r6,r6,#31
	@ 0 register || 1 number 
	cmp r6,#0
	beq print_reg_half
	bne print_im_half

print_reg_half:
	lsl r6,r5,#28
	lsr r6,r6,#28
	mov r1,r6
	ldr r0,=t_r
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b prepost_half

print_im_half:
	@mix offset first
	lsl r8,r5,#20
	lsr r8,r6,#28
	lsl r8,r8,#4

	lsl r9,r5,#28
	lsr r9,r9,#28
	ORR r6,r8,r9
	mov r1,r6
	ldr r0,=t_sq
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b prepost_half

prepost_half:
	lsl r6,r5,#7
	lsr r6,r6,#31
	cmp r6,#1 @if pre
	bne check_writeback_half
	ldr r0,=t_clb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}

check_writeback_half:
	lsl r6,r5,#10
	lsr r6,r6,#31
	cmp r6,#0
	beq endof_
	ldr r0,=t_wb
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	b endof_
@---------------end-half------------------------------
endof_:	
	ldr r0,=t_nl
	push {r1,r2,r3,r4}
	bl printf
	pop {r1,r2,r3,r4}
	
	b _loop
@___________return______________________________________
_exit_program:	
	LDR lr,=return
	LDR lr, [lr]
	BX LR @ swap lr,pc



