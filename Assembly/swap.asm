	.data
	
vetor:	.word	8, -3, 5, 2, 7
espaco:	.string	" "
	
	
	.text
	
main:
	 
	addi	s0,zero,0 #recebe indice para trocar
	addi	s1,zero,3 #recebe indice para trocar
	addi	a4,zero,0 #indicie
	addi	a5,zero,5 #controle do fim do vetor
	jal	swap
	jal	imprime
	nop 
	ebreak

	
swap:	
	
	add	a0,zero,s0 #a0 recebe indice 1
	add	a1,zero,s1 #a1 recebe indice 2
	la	a2,vetor
	addi	sp, sp, -8
	sw	a0, 4(sp)
	sw	ra, 0(sp)
	jal	percorre1
	
	lw	a0, 4(sp)
	lw	ra, 0(sp)
	addi	sp, sp, 8
	
	sw	t1,(a2)#coloca o valor que estava no indicie 2 no lugar do indicie 1	
	sw	t0,(t2)#coloca o valor que estava no indicie 1 no lugar do indicie 2
	
	ret
	
	
percorre1:
	
	beq	a4,a5,fim #veririfica se chegou ao fim do vetor
	lw	t0,0(a2) #carregar o valor do vetor em uma variavel
	beq	a4,a0 achou1 #verifica se esta no indicie desejado do vetor
	addi	a2,a2,4 #soma 4 bits para andar no vetor
	addi	a4,a4,1 #soam 1 na variavel do indicie do vetor e do for
	j	percorre1
	
achou1:
	
	addi	t1,t0,0 #salva o valor que foi achado no indicie desejado
	addi	t2,a2,0 #salva o endereco em que se encontra tal valor
	la	a2,vetor
	addi	a4,zero,0
	
percorre2:

	beq	a4,a5,fim
	lw	t0,0(a2)
	beq	a4,a1,achou2 #verifica se encontrou o segundo valor desejado
	addi	a2,a2,4 
	addi	a4,a4,1
	j	percorre2
	
		
achou2:
	
	ret
	
	
	
imprime:
	
	la	a0,vetor
	add	a1,zero,a5 #tamanho do vetor
	add	a2, zero, zero #indice
	add	a3, zero, zero
	addi	sp, sp, -8
	sw	a0, 4(sp)
	sw	ra, 0(sp)
	jal	laco
	
	lw	a0, 4(sp)
	lw	ra, 0(sp)
	addi	sp, sp, 8
	ret
	
laco:
	
	beq	a2,a1,fim #veririfica se chegou ao fim do vetor
	add	a6, a0, a3 #armazena endereço da posição atual
	add	a4, zero, a0 #armazena valor de a0
	lw	a0, (a6) #armazena valor da posição atual
	li	a7, 1
	ecall
	la	a0, espaco
	li	a7, 4
	ecall
	addi	a3, a3, 4
	addi	a2, a2, 1
	add	a0, a4, zero
	j	laco
	
	
	
fim:

	ret
