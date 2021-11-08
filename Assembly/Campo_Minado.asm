#CAMPO MINADO
#Vinicius dos Reis	1711100011
#Rafaelle Arruda	1721101029


	.data
	
	
usuario:                    # matriz visualizada pelo usuário
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1
	.word   -1,-1,-1,-1,-1,-1,-1,-1

campo:			.space		256   # esta versão suporta campo de até 9 x 9 posições de memória
salva_S0:		.word		0
salva_ra:		.word		0
salva_ra1:		.word		0

abrir:			.string		"\n1 - Abrir Posição"
ins_flag:		.string		"\n2 - Inserir/Remover Bandeira\n"
opcao:			.string		"\nEscolha uma opção: "
op_invalida:		.string		"\nOpção Inválida!\n"
coordena:		.string		"\nDigite a posição do campo minado (linha/coluna)(de 0 a 7):\n"
fim_jogo:		.string		"\nA BOMBA EXPLODIU! VOCE PERDEU!\n\n"
campomin:		.string		"\nCAMPO MINADO\n\n"
coordinv:		.string		"\nJOGADA INVALIDA. TENTE NOVAMENTE!\n"
band:			.string		"\nPOSIÇÃO COM BANDEIRA\n"
n_band:			.string		"\nBandeiras disponíveis: "
semflag:		.string		"\nSem Bandeiras disponíveis\n"
aberto:			.string		"\nPOSIÇÃO JÁ ABERTA!\n"
novalinh:		.string		"\n"
novbarra:		.string		"|"
novespac:		.string		" "
imprnove:		.string		" 9 "
imprflag:		.string		" F "
fechado:		.string		" - "
win:			.string		"\nVOCÊ VENCEU!!!\n\n"




	.text
	
	
main:

	addi a1, zero, 8	#numero de linhas e colunas 8x8
	addi a4, zero, 1
	addi s5, zero, 9
	addi s6, zero, -1
	addi s7, zero, 2
	addi s9, zero, 15	#total de bandeiras

	add a3, zero, zero	#controle do gameover

	la a0, campo		# parâmetro da matriz campo
	add a1, a1, zero	# parâmetro do tamanho da matriz campo
	jal insere_bombas	# chama função para inserir as bombas na matriz campo
	
	addi a1, zero, 8
	la a0, campo           # parâmetro da matriz campo
	add a1, a1, zero     # parâmetro do tamanho da matriz campo
	jal calcula_bombas      # chama função para calcular todas as bombas ao redor de todas as posições

continua_main:
        la a0, campo           # parâmetro da matriz campo
        add a1, a1, zero     # parâmetro do tamanho da matriz campo
        la a2, usuario         # parâmetro da matriz usuario
        add a3, a3, zero     # parâmetro da variável de gameover
        jal mostra_campo        # printa campo minado
        
        #verifica vitoria
        beq s8, zero, vitoria #se s8 = 0 sinaliza vitoria
        
        #Menu: abrir posição ou inserir\remover bandeira
        la  a0, abrir     
        li  a7, 4              
        ecall           
        
        la  a0, ins_flag
        li  a7, 4
        ecall    

        
	la  a0, opcao
        li  a7, 4
        ecall
        
        li  a7, 5
        ecall
        add t5, zero, a0
        
        #verifica opção
        beq a0, a4, continua_main2
        beq a0, s7, continua_main2
        
        la  a0, op_invalida       
        li  a7, 4              
        ecall
        
        j continua_main
        


continua_main2:
        la  a0, coordena       # imprime mensagem para inserir posição
        li  a7, 4
        ecall

        li  a7, 5
        ecall
        add t1, zero, a0     #salva linha em t1
        

        li  a7, 5
        ecall
        add t0, zero, a0     #salva coluna em t0
        

        slt t4, t0, a1		#verifica se a coordenada coluna digitada é maior que o numero de colunas
        beq t4, a4, linha_maior	#se coordenada for menor realiza o salto
        la  a0, coordinv
        li  a7, 4
        ecall
        j continua_main2        # volta para continua_main2 para escolher novamente a coordenada da matriz

linha_maior:
        slt t4, t1, a1		# verifica se a coordenada linha é maior que o numero de linhas
        beq t4, a4, coluna_menor	#se coordenada for menor realiza o salto
        la  a0, coordinv
        li  a7, 4
        ecall
        j continua_main2        # volta para continua_main2 para escolher novamente a coordenada da matriz

coluna_menor:
        sltz t4, t0		# verifica se a coordenada coluna digitada é menor que 0
        beq t4, zero, linha_menor	#se coordenada for maior ou igual a 0 realiza salto
        la  a0, coordinv
        li  a7, 4
        ecall
        j continua_main2        # volta para continua_main2 para escolher novamente a coordenada da matriz

linha_menor:
        sltz t4, t1		# verifica se a coordenada linha digitada é menor que 0
        beq t4, zero, executa	#se coordenada for maior ou igual a 0 realiza salto
        la  a0, coordinv
        li  a7, 4
        ecall
        j continua_main2        # volta para continua_main2 para escolher novamente a coordenada da matriz 
        
executa:

	#verificar se é abrir posição ou bandeira
	beq t5, s7, bandeira
	
	
        #(linha * numero de colunas) + coluna
        mul s1, t1, a1         # posição_matriz = linha * 8
        add s1, s1, t0       # posição_matriz += coluna
        addi a5, zero, 4
        mul s1, s1, a5         # posição_matriz *= 4 (para calcular posição)
        
        la a0, campo
        add a5, a0, s1

        lw  s3, (a5)     # salva endereço da posição campo
        
        la a2, usuario
        add a5, a2, s1
        sw  s3, (a5)   # salva valor encontrado na matiz campo na matriz usuario
        
        
        
        
        #verifica se tem uma bandeira na posição    
        bgt s3, s5, tem_flag
        
        
        
        # verifica se tem bomba na posição para finalizar o jogo
        bne s3, s5, continua
        addi a3, zero, 1      # seta variável de fim de jogo para 1
        la  a0, fim_jogo
        li  a7, 4
        ecall
        
        la a0, campo
        add a1, a1, zero
        la a2, usuario
        add a3, a3, zero     #variável de gameover
        jal mostra_campo
        j final                 # finaliza o jogo
        


bandeira:
	
	mul s1, t1, a1         # posição_matriz = linha * 8
        add s1, s1, t0       # posição_matriz += coluna
        addi a5, zero, 4
        mul s1, s1, a5         # posição_matriz *= 4 (para calcular posição)
        
        la a0, campo
        add a5, a0, s1

        lw  s3, (a5)     # salva endereço da posição campo
        
	#verifica se tem uma bandeira na posição
	bgt s3, s5, tira_flag	#se tiver flag salta para retirar
	
	
	la a2, usuario
        add a5, a2, s1
        lw  s3, (a5)
        
        bgt s3, s6, ja_aberto	#verifica se a posição já foi aberta
        
        
	beq s9, zero, zero_flag	#verifica se ainda tem bandeiras disponíveis
	
	
	la a0, campo
        add a5, a0, s1

        lw  s3, (a5) 
	
	addi s3, s3, 10 	#adiciona bandeira (soma 10 no valor presente na posição)
	addi s9, s9, -1		#dimunui o numero de bandeiras disponiveis
	
	sw s3, (a5)		#salva novo valor na matriz campo
	
	la a2, usuario
        add a5, a2, s1
        sw  s3, (a5)		#salva o valor na matriz usuario
        
        
        la  a0, n_band
        li  a7, 4              
        ecall
        
        li a7, 1               
        add a0, s9, zero    
        ecall
        
        la  a0, novalinh       
        li  a7, 4              
        ecall
	
	j	continua
	
	
tira_flag:
	
	addi s3, s3, -10	#retira bandeira (subtrai 10 no valor presente na posição)
	addi s9, s9, 1		#aumenta o numero de bandeiras disponiveis
	
	sw s3, (a5)		#salva novo valor na matriz campo
	
	la a2, usuario
        add a5, a2, s1
        sw  s6, (a5)		#salva o valor na matriz usuario
        
        
        la  a0, n_band       
        li  a7, 4              
        ecall
        
        li a7, 1               
        add a0, s9, zero    
        ecall
        
        la  a0, novalinh       
        li  a7, 4              
        ecall
	
	j	continua
	



ja_aberto:
	
	la  a0, aberto       
        li  a7, 4              
        ecall
	
	j	continua


zero_flag:
	
	la  a0, semflag       
        li  a7, 4              
        ecall
	
	
	j	continua
	
	
	      
tem_flag:
	
	la  a0, band       
        li  a7, 4              
        ecall     
	j	continua
        

        
continua:
        j continua_main        # continua o jogo printando o campo minado e pedindo outra coordenada
        


mostra_campo:                   # void mostra_campo(int * campo[], int num_linhas, int * usuario[], int fim_jogo);
        # essa função imprimirá a matriz usuario, mas necessita da matriz campo e da variável fim_jogo para saber
        # se será impresso uma bomba ou não
        
        add s4, a0, zero     # salva endereço da matriz campo
        
        add s8, zero, zero	#variavel para verificar vitoria (adiciona 1 a cada -1 encontrado na matriz usuario)

	la  a0, campomin
        li  a7, 4
        ecall

        add t2, zero, zero   #variável que percorre as linhas

for:
        addi t3, zero, -1	# reseta variável do laço que percorre as colunas; é setado com valor -1 
        			# pelo fato de haver um "continue" na função, necessitando de um ++ no início do laço para
       				# ignorar a posição da matriz que o chamou e para começar da posição 0 e não da posição 1
        beq t2, a1, exit      # verifica fim do for

for2:
        addi t3, t3, 1        # aumenta contador de colunas
        beq t3, a1, exit1     # verifica fim do for2

        mul s1, t2, a1         # posição_matriz = linhas * 8
        add s1, s1, t3       # posição_matriz += coluna
        addi a5, zero, 4
        mul s1, s1, a5         # posição_matriz *= 4 (para calcular posição)
        add s3, s1, a2       # calcula endereço da posição da matriz usuario
        lw  s3, 0(s3)         # salva posição da matriz usuario
        add t5, s1, s4       # calcula endereço da matriz campo
        lw  t5, 0(t5)         # salva posição da matriz campo
        
        # imprime uma barra
        la a0, novbarra
        li a7, 4
        ecall
        
        # verifica variável de fim de jogo para saber o que imprimir; se a posição é bomba entao 
        # imprime a bomba e não a posição da matriz usuario, depois retorna, como um "continue",
        # para o laço continuar a imprimir as demais posições
        
        bne a3, a4, imprime_valor  	#verifica gameover    
        bne t5, s5, imprime_valor        # verifica se a posição da matriz campo é igual a 9
        # imprime valor 9
        la a0, imprnove
        li a7, 4
        ecall
        j for2                  # volta para for2 porque o valor é bomba

imprime_valor:
	
        beq s3, s6, imprime_fechado 	#verifica se o valor é -1 para imprimir " - "
        bgt s3, s5, imprime_bandeira	#verifica se tem uma bandeira
        
        # imprime um espaço
        la a0, novespac
        li a7, 4
        ecall
        
        li a7, 1
        add a0, s3, zero     # salva valor de s3 em a0 para ser impresso
        ecall
        
        la a0, novespac
        li a7, 4
        ecall

        j for2  

imprime_fechado:

        # imprime as posições
        la a0, fechado
        li a7, 4               # seta valor de operação para integer
        ecall                 # imprime string
        
        addi s8, s8, 1

        j for2                  # volta para for2
        
        
imprime_bandeira:
	
        la a0, imprflag
        li a7, 4
        ecall

        j for2                  # volta para for2

exit1:
        # imprime uma barra
        la a0, novbarra
        li a7, 4
        ecall
        
        # imprime nova linha
        la a0, novalinh
        li a7, 4
        ecall
        addi t2, t2, 1        # aumenta contador de linha
        j for                   # volta para for
exit:
        
        ret

calcula_bombas:
        
        addi s2, a1, -1        # numero de linhas - 1
        add t2, zero, zero	#variável do laço que percorre as linhas

laco:
        addi t3, zero, -1	# reseta variável do laço que percorre as colunas; é setado com valor -1 
        			# pelo fato de haver um "continue" na função, necessitando de um ++ no início do laço para
        			# ignorar a posição da matriz que o chamou e para começar da posição 0 e não da posição 1
        			
        beq t2, a1, fim1      # verifica fim do laco

laco2:
        add s0, zero, zero   #contador de bombas
        addi t3, t3, 1        # aumenta contador de colunas
        beq t3, a1, fim2      # verifica fim do laco2

        mul s1, t2, a1         # posição_matriz = linha * 8
        add s1, s1, t3       # posição_matriz += coluna
        addi a5, zero, 4
        mul s1, s1, a5         # posição_matriz *= 4 (para calcular posição)

        add s3, s1, a0       # calcula endereço da matriz campo
        lw  s3, 0(s3)         # salva posição da matriz

        # verifica se a posição é bomba; se ela for, retorna, como um "continue", para o laço
        # para ignorar essa posição, já que não preciso saber o número de bombas ao redor
        # de uma posição que já é bomba
        
        bne s3, s5, colAnt_linAnt        # verifica se posição da matriz campo é igual a 9
        j laco2                 # volta para laco2 porque o valor é bomba

colAnt_linAnt: #coluna_anterior -- linha_anterior

        addi s3, s1, -4        # posição_matriz -= 4 (coluna anterior)
        addi s3, s3, -32       # posição_matriz -= 36 (linha anterior)
        add s3, a0, s3       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz

        beq t2, zero, linAnt        # verifica linha != 0
        beq t3, zero, linAnt        # verifica coluna != 0
        bne s3, s5, linAnt        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

linAnt: #mesma_coluna -- linha_anterior
        addi s3, s1, -32       # posição_matriz -= 36 (linha anterior)
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz

        beq t2, zero, colProx_linAnt        # verifica linha != 0
        bne s3, s5, colProx_linAnt        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

colProx_linAnt: #proxima_coluna -- linha_anterior
        addi s3, s1, 4        # posição_matriz += 4 (proxima coluna)
        addi s3, s3, -32       # posição_matriz -= 36 (linha anterior)
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz
        
        beq t3, s2, colAnt      # verifica coluna != num_linhas
        beq t2, zero, colAnt        # verifica linha != 0
        bne s3, s5, colAnt        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

colAnt: #coluna_anterior -- mesma_linha
        addi s3, s1, -4        # posição_matriz -= 4 (coluna anterior) 
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz
        
        beq t3, zero, colProx        # verifica coluna != 0
        bne s3, s5, colProx        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

colProx: #proxima_coluna -- mesma_linha
        addi s3, s1, 4        # posição_matriz += 4 (proxima coluna) 
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz
        
        beq t3, s2, colAnt_linProx      # verifica coluna != num_linhas
        bne s3, s5, colAnt_linProx        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

colAnt_linProx: #coluna_anterior -- proxima_linha
        addi s3, s1, -4        # posição_matriz -= 4 (coluna anterior)
        addi s3, s3, 32       # posição_matriz += 36 (proxima linha)
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz

        beq t3, zero, linProx        # verifica x1 != 0
        beq t2, s2, linProx      # verifica y1 != num_linhas
        bne s3, s5, linProx        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

linProx: #mesma_coluna -- proxima_linha
        addi s3, s1, 32       # posição_matriz += 36 (proxima linha)
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz
        
        beq t2, s2, colProx_linProx      # verifica linha != num_linhas
        bne s3, s5, colProx_linProx        # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

colProx_linProx: #proxima_coluna -- proxima_linha
        addi s3, s1, 4        # posição_matriz += 4 (proxima coluna)
        addi s3, s3, 32       # posição_matriz += 36 (proxima linha)
        add s3, s3, a0       # calcula endereço da matriz
        lw  s3, 0(s3)         # salva posição da matriz

        beq t3, s2, continua_calculo # verifica se coluna != num_linhas
        beq t2, s2, continua_calculo # verifica se linha != num_linhas
        bne s3, s5, continua_calculo   # verifica se o valor da posição é igual a 9
        addi s0, s0, 1        # i++

continua_calculo:
        add s3, s1, a0       # calcula endereço da matriz na qual o dado vai ser substituido pelo numero de bombas

        sw  s0, 0(s3)         # salva o numero de bombas
        j laco2                 # volta para laco2

fim2:
        addi t2, t2, 1        # aumenta contador de linhas da matriz
        j laco                 # volta para laco

fim1:
        ret

insere_bombas:
        
       	la	t0, salva_S0
	sw  	s0, 0 (t0)		# salva conteudo de s0 na memoria
	la	t0, salva_ra
	sw  	ra, 0 (t0)		# salva conteudo de ra na memoria
		
	add 	t0, zero, a0		# salva a0 em t0 - endereço da matriz campo
	add 	t1, zero, a1		# salva a1 em t1 - quantidade de linhas 

QTD_BOMBAS:
	addi 	t2, zero, 15 		# seta para 15 bombas	
	add 	t3, zero, zero 	# inicia contador de bombas com 0
	addi 	a7, zero, 30 		# ecall 30 pega o tempo do sistema em milisegundos (usado como semente
	ecall 				
	add 	a1, zero, a0		# coloca a semente em a1
INICIO_LACO:
	beq 	t2, t3, FIM_LACO
	add 	a0, zero, t1 		# carrega limite para %	(resto da divisão)
	jal 	PSEUDO_RAND
	add 	t4, zero, a0		# pega linha sorteada e coloca em t4
	add 	a0, zero, t1 		# carrega limite para % (resto da divisão)
	jal 	PSEUDO_RAND
	add 	t5, zero, a0		# pega coluna sorteada e coloca em t5

###############################################################################
# imprime valores na tela (para debug somente) - retirar comentarios para ver
#	
#		li	a7, 4		# mostra texto "Posicao: "
#		la	a0, posicao
#		ecall
#		li	a7, 1
#		add 	a0, zero, t4 	# imprime a linha sorteada	
#		ecall
#
#		add 	a0, zero, t5 	# imprime coluna sorteada
#		ecall
#		
#		li	a7, 4		# imrpime espaço
#		la	a0, espaco
#		ecall
#		li	a7, 1		
#		add 	a0, zero, t3 	# imprime quantidade ja sorteada
#		ecall
#		
##########################################################################	

LE_POSICAO:	
	mul  	t4, t4, t1
	add  	t4, t4, t5  		# calcula (L * tam) + C
	add  	t4, t4, t4  		# multiplica por 2
	add  	t4, t4, t4  		# multiplica por 4
	add  	t4, t4, t0  		# calcula Base + deslocamento
	lw   	t5, 0(t4)   		# Le posicao de memoria LxC
VERIFICA_BOMBA:		
	addi 	t6, zero, 9		# se posição sorteada já possui bomba
	beq  	t5, t6, PULA_ATRIB	# pula atribuição 
	sw   	t6, 0(t4)		# senão coloca 9 (bomba) na posição
	addi 	t3, t3, 1		# incrementa quantidade de bombas sorteadas
PULA_ATRIB:
	j	INICIO_LACO

FIM_LACO:					# recupera registradores salvos
	la	t0, salva_S0
	lw  	s0, 0(t0)		# recupera conteudo de s0 da memória
	la	t0, salva_ra
	lw  	ra, 0(t0)		# recupera conteudo de ra da memória		
	ret			# retorna para funcao que fez a chamada
		
##################################################################
# PSEUDO_RAND
# função que gera um número pseudo-randomico que será
# usado para obter a posição da linha e coluna na matriz
# entrada: a0 valor máximo do resultado menos 1 
#             (exemplo: a0 = 8 resultado entre 0 e 7)
#          a1 para o número pseudo randomico 
# saida: a0 valor pseudo randomico gerado
#################################################################
#int rand1(int lim, int semente) {
#  static long a = semente; 
#  a = (a * 125) % 2796203; 
#  return (|a % lim|); 
# }  

PSEUDO_RAND:
	addi t6, zero, 125  		# carrega constante t6 = 125
	lui  t5, 682			# carrega constante t5 = 2796203
	addi t5, t5, 1697 		# 
	addi t5, t5, 1034 		# 	
	mul  a1, a1, t6			# a = a * 125
	rem  a1, a1, t5			# a = a % 2796203
	rem  a0, a1, a0			# a % lim
	bge  a0, zero, EH_POSITIVO  	# testa se valor eh positivo
	addi t4, zero, -1           	# caso não 
	mul  a0, a0, t4		    	# transforma em positivo
EH_POSITIVO:	
	ret				# retorna em a0 o valor obtido
############################################################################

       # ret

vitoria:
	la  a0, win       
        li  a7, 4              
        ecall
	ebreak

final:
	ebreak
