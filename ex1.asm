	.data
vetor:	.space 12
msg:	.string "Informe o valor: "


	.text

main:
	li 	a1, 3
	add	a2, zero, zero
	jal	le_vetor
	nop
	ebreak
	
le_vetor:
	la	a0, vetor
	beq	a1, zero, fim
	add	a3, a0, zero
	la	a0, msg		
	li	a7, 4		
	ecall
	li	a7, 5
	ecall
	add	s0, a0, zero
	add	a0, a3, zero
	add	a0, a0, a2
	sw	s0, (a0)
	addi	a2, a2, 4	
	addi 	a1, a1, -1 	
	j	le_vetor
fim:
	ret	
