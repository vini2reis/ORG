	.data

numero1:	.word	5
numero2:	.word	7
numero3:	.word	3


	.text
	
main:
	
	lw	s0, numero1
	lw	s1, numero2
	lw	s2, numero3
	
	bge	s0, s1, maior1
	bge	s2, s1, maior3
	add	a0, s1, zero
	j	fim
	
maior1:

	bge	s2, s0, maior3
	add	a0, s0, zero
	j	fim
	
maior3:

	add	a0, s2, zero
	
fim:

	nop
	ebreak
