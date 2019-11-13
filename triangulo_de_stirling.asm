.data

informa_N:	.string "Informe N maior ou igual a 1: "
informa_K:	.string "Informe K menor ou igual a N e maior ou igual a 1: "
msg_Result:	.string "Resultado: "

	.text
	

N:		
		addi s0, zero, 0	#s0 = N
		addi t0, zero, 1    	#t0 = 1
		li   a7, 4
		la   a0, informa_N
		ecall
		
		li a7, 5
		ecall
		
		blt a0, t0, N		#N é menor que 1?
		add s0, zero, a0

K:		
		addi s1, zero, 0	#s1 = K
		li 	a7, 4
		la	a0, informa_K
		ecall
		
		li a7, 5 
		ecall
		
		blt a0, t0, K	#K menor que 1?
		blt s0, a0, K	#N  menor que K?
		add s1, zero, a0
		beq s0, t0, n_eh_1 	#N = 1
		
		
main:
		addi s2, zero, 0	#s2 = resultado
		jal funcao
		
		li   a7, 4
		la   a0, msg_Result
		ecall
		
		addi a0, s2, 0
		li   a7, 1
		ecall
		
		nop 
		ebreak
				
funcao:	
		beq s0, t0, retorno_0	#N igual de 1?
		beq s1, t0, retorno_1	#K igual de 1?
		beq s1, zero, retorno_0	#K igual a 0?
		beq s1, s0, retorno_1	#K igual N?
		
		addi sp, sp, -4
		sw s0, 0(sp)		#Salva N
		addi sp, sp, -4
		sw s1, 0(sp)		#Salva K
		addi sp, sp, -4
		sw ra, 0(sp)		#Salva endereco
		addi s0, s0, -1		#N-1
		
		jal funcao
		
		
		lw s0, 8(sp)		#busca N
		lw s1, 4(sp)		#busca K
		lw ra, 0(sp)		#busca endereco																																				
		
		mul s2, s1, s2		#Multiplica K pelo resultado retornado
		
		addi sp, sp, -4
		sw s2, 0(sp)		#Salva resultado
		
		addi s0, s0, -1		#N-1	
		addi s1, s1, -1		#K-1
		
		jal funcao
	
		
		lw a0, 0(sp)		#busca retorno multiplicado																																				
		lw ra, 4(sp)		#busca registrador de retorno
		lw s1, 8(sp)		#busca K
		lw s0, 12(sp)		#busca N
		add s2, a0, s2		#Soma resultado multiplição (primeira parte) com a segunda metade
		addi sp, sp, 16
		ret					
		

retorno_0:
		beq s0, zero, retorno_1	#N igual a 0?
		addi s2, zero, 0
		ret
		
		

		
retorno_1:		
		addi s2, zero, 1
		ret
		

n_eh_1:
		beq s1, t0, k_eh_1 	#K = 1?
		

k_eh_1:	
		addi s2, zero, 1
		li   a7, 4
		la   a0, msg_Result
		ecall

		add a0, zero, s2
		li   a7, 1
		ecall
		
		nop 
		ebreak
