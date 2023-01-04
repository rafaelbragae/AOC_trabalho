#Autores:
#	Conrado Gobato - 149506
#	Rafael Braga Ennes - 156357

#O nosso programa tem como objetivo fazer uma calculadora de investimentos e acoes, com as seguintes funcoes:
#	Juros Compostos
#	Calculadora de indicadores
#	Avaliacoes de acoes
.text
.globl main
 main:
	#impressao do menu
	li $v0, 4 #codigo da syscall (impressao de string)
	
	la $a0, title
	syscall
	
	la $a0, op_1
	syscall
	
	la $a0, op_2
	syscall
	
	la $a0, op_0
	syscall
	 
 opcao:
	#verificacao da opcao
	li $v0, 5
	syscall
	
	add $t9, $v0, $zero #armazena operacao
	
	bgt $t9, 2, invalido #operacao maior que 2
	bltz $t9, invalido #operacao negativa
	
	beq $t9, $zero, quit
	beq $t9, 1, analise_acao
	beq $t9, 2, investimento
	 
 analise_acao:
    #impressao das strings
	li $v0, 4
	la $a0, preco
	syscall
	
	li $v0, 6
	syscall
	mov.s $f5, $f0
	
	li $v0, 4
	la $a0, lucro
	syscall
	
	li $v0, 6
	syscall
	mov.s $f1, $f0
	
	li $v0, 4
	la $a0, ebitda
	syscall
	
	li $v0, 6
	syscall
	mov.s $f2, $f0
	
	li $v0, 4
	la $a0, div_liquida
	syscall
	
	li $v0, 6
	syscall
	mov.s $f3, $f0
	
 calculadora_indic:
    		li $v0, 4
		la $a0, divisor
		syscall
		
		#P/L
   		div.s $f6, $f5, $f1
   		li $v0, 4
		la $a0, impressao_preco_lucro
		syscall
   		li $v0, 4
		la $a0, preco_sobre_lucro
		syscall
   		li $v0, 2
		mov.s $f12, $f6
 		syscall
 		li $v0, 4
		la $a0, divisor
		syscall

 		#divida lliquida/ebitda
   		div.s $f4, $f3, $f2
   		li $v0, 4
		la $a0, impressao_div_ebitda
		syscall
   		li $v0, 4
		la $a0, div_sobre_ebitda
		syscall
   		li $v0, 2
		mov.s $f12, $f4
 		syscall
 		li $v0, 4
		la $a0, divisor
		syscall
		
 		#Preco/ebitda
   		div.s $f7, $f5, $f2
   		li $v0, 4
		la $a0, impressao_preco_ebitda
		syscall
   		li $v0, 4
		la $a0, preco_sobre_ebitda
		syscall
   		li $v0, 2
		mov.s $f12, $f7
 		syscall
 		li $v0, 4
		la $a0, divisor
		syscall
 		j main
 		
 investimento:
	li $v0, 4
	la $a0, meses
	syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $v0, 4
	la $a0, invest_inicial
	syscall
	
	li $v0, 6
	syscall
	mov.s $f2, $f0
	
	
	li $v0, 4
	la $a0, juros
	syscall
	
	li $v0, 6
	syscall
	
	mov.s $f4, $f0
	
	lwc1 $f7, float100
	
	div.s $f4, $f4, $f7
	lwc1 $f6, float1
	add.s $f4, $f4, $f6

    	lwc1 $f5, float0  #investimento total
    	
    	mul.s $f6, $f4, $f4
    	addi $t0, $t0, -2
 conta:
	
    	beq $t0, $zero, multi
        mul.s $f6, $f6, $f4
        addi $t0, $t0, -1
   	j conta
 multi:
	mul.s $f7, $f2, $f6
	j imprime_invest
   	
 imprime_invest:
	li $v0, 2
	mov.s $f12, $f7
 	syscall
 	j main
    
 invalido:
    #opcao invalida
    addi $v0, $zero, 4
	la $a0, invalid
	syscall
	j main
	
  invalido2:
    #opcao invalida
    addi $v0, $zero, 4
	la $a0, invalid
	syscall
	j analise_acao
	
  quit:
	#fim do programa
	addi $v0, $zero, 10
	syscall
	
.data

#MENU1
title:	.asciiz	"\nEscolha a opcao:\n"
op_1:	.asciiz " 1 - Acoes\n"
op_2:	.asciiz " 2 - Investimentos\n"
op_0:	.asciiz " 0 - Sair\n"

#MENU_ACOES
analise:	.asciiz " 1 - Analise de Acoes\n"
calculadora:	.asciiz " 2 - Calculadora de Indicadores\n"
voltar:	.asciiz " 0 - Voltar\n"

#MENU_ANALISE
preco:	.asciiz "\nPreco da acao: \n"
lucro:	.asciiz "Lucro da empresa: \n"
ebitda:	.asciiz "Ebitda: \n"
div_liquida: .asciiz "Divida liquida: \n"
divisor: .asciiz "\n####################################################################################################################################################\n" 
preco_sobre_lucro: .asciiz "\nPreco da acao/Lucro da empresa: \n"
div_sobre_ebitda: .asciiz "\nDivida Liquida/Ebitda da empresa: \n"
preco_sobre_ebitda: .asciiz "\nPreco da acao/Ebitda da empresa: \n"

#MENU_JUROS
meses:	.asciiz "\nNumero de meses: \n"
invest_inicial:	.asciiz "Investimento inicial: \n"
invest_mensal:	.asciiz "Investimento mensal: \n"
juros: .asciiz "Taxa de juros mensal: \n"

#ERROS	
invalid2:  .asciiz "\nerro!!\n"
invalid:  .asciiz "\nOpcao invalida!!\n"
error2: .asciiz "Numero invalido!!\n"

#IMPRESSÂO DPOS INDICADORES
impressao_preco_lucro: .asciiz "\nO Índice Preço/Lucro serve como um indicador do otimismo ou pessimismo usado no mercado pelos investidores, além de contribuir na identificação de oportunidades financeiras. Também conhecido como Múltiplo de Lucros, é uma medida bastante popular entre os investidores pessoa física, gestores e investidores institucionais.\n\n"
impressao_div_ebitda: .asciiz "\nO Índice Dívida Líquida/EBITDA serve para analisar o índice de endividamento de uma empresa. Seu resultado demonstra o número de anos que uma empresa levaria para pagar sua dívida líquida no cenário em que o EBITDA permanece constante.\n\n"
impressao_preco_ebitda: .asciiz "\nO P/EBITDA é uma métrica que indica o potencial de geração de caixa de uma empresa. Esse indicador calcula a razão entre o preço da ação e o EBITDA da empresa por ação, sendo bastante utilizado por investidores para analisar empresas listadas na bolsa de valores.\n\n"

#EXTRAS

float1: .float 1.0
float0: .float 0.0
float100: .float 100.0
