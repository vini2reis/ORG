	.data
vetor:	.space 12
msg:	.string "Informe o valor: "


	.text

main:
	la	a0, vetor
	li 	a1, 3
	add	a2, zero, a0
	jal	le_vetor
	nop
	ebreak
	
le_vetor:
	beq	a1, zero, fim
	la	a0, msg		
	li	a7, 4		
	ecall
	li	a7, 5
	ecall
	addi	a2, a2, 4	
	addi 	a1, a1, -1 	
	j	le_vetor
fim:
	ret	