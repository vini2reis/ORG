//Diego Becker e Vinicius dos Reis
//FIFO e escrita no Retorno

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct linha
{
    int vet1[4];
    int dirty;
    int rotulo;
    int valido;
    int pol_sub;
} linha;

typedef struct conjunto
{
    struct linha vetor_linha[4];
} conjunto;

typedef struct bloco
{
    int vet2[4];
} bloco;

//bits= numero de bits
//num= binario
//decimal= numero em decimal
//inicial= valor que diz em qual bit ele ta


//binario para decimal
int dec(int bits, char num[bits], int inicial)
{
    int cont = 0;
    for (int i = bits - 1; i >= 0; i--)
    {
        if (num[i] == '1')
            cont += inicial;
        inicial *= 2;
    }
    return cont;
}

//pega valor e tranforma para binario
int dec_to_dec(int bits, int decimal, int inicial)
{
    int x;
    char bin[bits];
    for (int aux = bits - 1; aux >= 0; aux--)
    {
        if (decimal % 2 == 0)
            bin[aux] = '0';
        else
            bin[aux] = '1';
        decimal /= 2;
    }
    return x = dec(bits, bin, inicial);
}

//so para printar em binario
void bin(int num, int bits)
{
    int aux = bits - 1, bin[bits];
    for (; aux >= 0; aux--)
    {
        if (num % 2 == 0)
            bin[aux] = 0;
        else
            bin[aux] = 1;
        num /= 2;
    }
    for (aux = 0; aux < bits; aux++)
        printf("%d", bin[aux]);
}

void print_mem(struct bloco vetor_bloco[32], struct conjunto vetor_conjunto[4])
{
    printf("\n\t\t\t\t\tMEMORIA PRINCIPAL\n\n");
    for (int i = 0; i < 32; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            printf("\t\tCelula[");
            bin(i * 4 + j, 7);
            printf("]: ");
            bin(vetor_bloco[i].vet2[j], 8);
            if (j % 2 == 1)
                printf("\n");
        }
    }
    puts("\n\n-------------------------------------------------------------------------------------------------");
    printf("\n\t\t\t\t\tMEMORIA CACHE\n");
    printf("\n|FIFO| |VALIDO| |DIRTY| | ROTULO | |   00   | |   01   | |   10   | |   11   | |LINHA| |CONJUNTOS|\n");
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            printf("|-");
            bin(vetor_conjunto[i].vetor_linha[j].pol_sub, 3);
            printf("| |   %d  |", vetor_conjunto[i].vetor_linha[j].valido);
            printf(" |  %d  | |  ", vetor_conjunto[i].vetor_linha[j].dirty);
            if (vetor_conjunto[i].vetor_linha[j].valido == 0)
                printf("----");
            else
                bin(vetor_conjunto[i].vetor_linha[j].rotulo, 4);
            printf("  | ");
            for (int k = 0; k < 4; k++)
            {
                printf("|");
                if (vetor_conjunto[i].vetor_linha[j].valido == 0)
                    printf("--------");
                else
                    bin(vetor_conjunto[i].vetor_linha[j].vet1[k], 8);
                printf("| ");
            }
            printf("| ");
            bin(i * 4 + j, 3); //linha
            printf(" | |   ");
            bin(i, 1); //conjunto
            printf("    |\n");
        }
    }
    printf("\n\n-------------------------------------------------------------------------------------------------");
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            if (vetor_conjunto[i].vetor_linha[j].pol_sub == 0 || vetor_conjunto[i].vetor_linha[j].pol_sub == 4)
            {
                printf("\n\t\t\tProxima localizacao: Linha [");
                bin(i * 4 + j, 3);
                printf("] - ");
                printf("Conjunto [");
                bin(i, 1);
                printf("]");
                break;
            }
        }
    }
    puts("\n-------------------------------------------------------------------------------------------------");
}

void ender_cache(struct bloco vetor_bloco[32], struct conjunto vetor_conjunto[2], double acertos_leitura[1], double acertos_escrita[1], double faltas_leitura[1], double faltas_escrita[1], int tipo)
{
    int aux = 0, dado = 0, data = 0, end = 0, bloc = 0, soma_endereco = 0, int_conjunto, int_deslocamento, int_rotulo, int_bloco, int_endereco, int_dado, x = 0, linha_enc_cache, linha_enc_conjunto;
    double porc;
    char bits_endereco[7], bits_dado[8], bits_conjunto[1], bits_rotulo[4], bits_deslocamento[2];

    printf("\nDigite o endereco desejado:\n");
    scanf("%d", &end);
    int ajuda = end;

    for (aux = 7; aux >= 1; aux--)
    {
        if (end % 2 == 0)
            bits_endereco[aux] = '0';
        else
            bits_endereco[aux] = '1';
        end /= 2;
    }

    printf("%s\n", bits_endereco);

    int_endereco = dec(7, bits_endereco, 1);
    bloc = ajuda / 4;

    bits_rotulo[0] = bits_endereco[1];
    bits_rotulo[1] = bits_endereco[2];
    bits_rotulo[2] = bits_endereco[3];
    bits_rotulo[3] = bits_endereco[4];
    int_rotulo = dec(4, bits_rotulo, 1);
    printf("inrrot: %s\n", bits_rotulo);

    
    bits_conjunto[0] = bits_endereco[5]; 
    int_conjunto = dec(1, bits_conjunto, 1);
    printf("%d\n", int_conjunto);

    bits_deslocamento[0] = bits_endereco[6];
    bits_deslocamento[1] = bits_endereco[7];
    int_deslocamento = dec(2, bits_deslocamento, 1);
    for (int i = 0; i < 4; i++)
    {
        if (vetor_conjunto[int_conjunto].vetor_linha[i].valido == 1)
        {
            if (vetor_conjunto[int_conjunto].vetor_linha[i].rotulo == int_rotulo)
            {
                x = 1;
                
                break;
            }
        }
        else
            x = 0;
    }
    if (x == 0)
    {
        printf("\nEndereco n�o encontrado na cache!\n");
        if(tipo == 0)
            faltas_leitura[0]++;
        for (int i = 0; i < 4; i++)
        {
            if (vetor_conjunto[int_conjunto].vetor_linha[i].pol_sub == 0)
            {
                vetor_conjunto[int_conjunto].vetor_linha[i].rotulo = int_rotulo;
                printf("rot: %d\n", vetor_conjunto[int_conjunto].vetor_linha[i].rotulo);
                soma_endereco += dec_to_dec(4, vetor_conjunto[int_conjunto].vetor_linha[i].rotulo, 2);
                printf("soma1: %d\n", soma_endereco);
                soma_endereco += dec_to_dec(1, int_conjunto, 1);
                printf("soma2: %d\n", soma_endereco);
                //soma_endereco /= 8;
                //printf("soma: %d\n", soma_endereco);
                for (int j = 0; j < 4; j++)
                {
                    if (vetor_conjunto[int_conjunto].vetor_linha[i].dirty == 1)
                        vetor_bloco[soma_endereco].vet2[j] = vetor_conjunto[int_conjunto].vetor_linha[i].vet1[j];
                    printf("vet: %s\n", vetor_bloco);

                    vetor_conjunto[int_conjunto].vetor_linha[i].vet1[j] = vetor_bloco[bloc].vet2[j];
                }
                vetor_conjunto[int_conjunto].vetor_linha[i].dirty = 0;
                vetor_conjunto[int_conjunto].vetor_linha[i].valido = 1;
                vetor_conjunto[int_conjunto].vetor_linha[i].pol_sub = 1;
                vetor_conjunto[int_conjunto].vetor_linha[i].rotulo = int_rotulo;

                linha_enc_cache = int_conjunto * 4 + i;
                printf("linhaaa: %d\n", linha_enc_cache);
                linha_enc_conjunto = i;
                printf("aqq:%d\n", linha_enc_conjunto);

                if (i > 0){
                    int j = 0;
                    j = i;
                    while(j > 0){
                        vetor_conjunto[int_conjunto].vetor_linha[j - 1].pol_sub += 1;
                        j--;
                    }
                }
                /*else
                    vetor_conjunto[int_conjunto].vetor_linha[i + 1].pol_sub = 0;*/
                break;
            }
            else if (vetor_conjunto[int_conjunto].vetor_linha[i].pol_sub == 4){
                soma_endereco += dec_to_dec(4, vetor_conjunto[int_conjunto].vetor_linha[i].rotulo, 2);
                printf("soma1: %d\n", soma_endereco);
                soma_endereco += dec_to_dec(1, int_conjunto, 1);
                printf("soma2: %d\n", soma_endereco);
                for (int j = 0; j < 4; j++)
                {
                    if (vetor_conjunto[int_conjunto].vetor_linha[i].dirty == 1)
                        vetor_bloco[soma_endereco].vet2[j] = vetor_conjunto[int_conjunto].vetor_linha[i].vet1[j];
                    printf("vet: %s\n", vetor_bloco);

                    vetor_conjunto[int_conjunto].vetor_linha[i].vet1[j] = vetor_bloco[bloc].vet2[j];
                }
                vetor_conjunto[int_conjunto].vetor_linha[i].dirty = 0;
                vetor_conjunto[int_conjunto].vetor_linha[i].valido = 1;
                vetor_conjunto[int_conjunto].vetor_linha[i].pol_sub = 1;
                vetor_conjunto[int_conjunto].vetor_linha[i].rotulo = int_rotulo;

                linha_enc_cache = int_conjunto * 4 + i;
                printf("linhaaa: %d\n", linha_enc_cache);
                linha_enc_conjunto = i;
                printf("aqq:%d\n", linha_enc_conjunto);
                printf("i: %d\n", i);

                if(i == 0){
                    printf("!!!!!");
                    int j = i;
                    printf("!!");
                    while(j < 3){
                        printf("!");
                        vetor_conjunto[int_conjunto].vetor_linha[j + 1].pol_sub += 1;
                        printf("j: %d\n", j);
                        j++;
                    } 
                }
                if (i > 0){
                    int j = 0;
                    j = i;
                    while(j > 0){
                        vetor_conjunto[int_conjunto].vetor_linha[j - 1].pol_sub += 1;
                        printf("j: %d\n", j);
                        j--;
                    }
                    j = i;
                    while(j < 3){
                        vetor_conjunto[int_conjunto].vetor_linha[j + 1].pol_sub += 1;
                        printf("j2: %d\n", j);
                        j++;
                    }
                }
                break;
            }
        }
    }
    else
    {
        printf("\nEndereco encontrado na cache!\n");
        if(tipo == 0)
            acertos_leitura[0]++;
    }
    printf("Numero do bloco a que se refere o endere�o: ");
    bin(bloc, 5);
    printf("\nQuadro da cache em que esta mapeado: ");
    bin(linha_enc_cache, 3);
    printf("\nDeslocamento no quadro: %c", bits_deslocamento[0]);
    printf("%c\n", bits_deslocamento[1]);

    if (tipo == 1)
    {
        for (int i = 0; i < 4; i++)
        {
            if (vetor_conjunto[int_conjunto].vetor_linha[i].rotulo == int_rotulo)
            {
                vetor_conjunto[int_conjunto].vetor_linha[i].rotulo = int_rotulo;
                printf("rot: %d\n", vetor_conjunto[int_conjunto].vetor_linha[i].rotulo);
                soma_endereco += dec_to_dec(4, vetor_conjunto[int_conjunto].vetor_linha[i].rotulo, 2);
                printf("soma1: %d\n", soma_endereco);
                soma_endereco += dec_to_dec(1, int_conjunto, 1);
                printf("soma2: %d\n", soma_endereco);

                linha_enc_cache = int_conjunto * 4 + i;
                printf("linhaaa: %d\n", linha_enc_cache);
                linha_enc_conjunto = i;
                printf("aqq:%d\n", linha_enc_conjunto);

                
                break;
            }
        }

        printf("\nDigite o conteudo do dado desejado a ser escrito:\n");
        scanf("%d", &dado);
        printf("ttttttt");

        for (data = 7; data >= 1; data--)
        {
            printf("reeeeeee");
            if (dado % 2 == 0)
                bits_dado[data] = '0';
            else
                bits_dado[data] = '1';
            dado /= 2;
        }

        int_dado = dec(8, bits_dado, 1);
        printf("%d e %d\n %d = %d", int_conjunto, linha_enc_conjunto, vetor_conjunto[int_conjunto].vetor_linha[linha_enc_conjunto].rotulo, int_rotulo);

        if (vetor_conjunto[int_conjunto].vetor_linha[linha_enc_conjunto].rotulo == int_rotulo)
        {

            if (vetor_conjunto[int_conjunto].vetor_linha[linha_enc_conjunto].vet1[int_deslocamento] != int_dado)
            {
                vetor_conjunto[int_conjunto].vetor_linha[linha_enc_conjunto].vet1[int_deslocamento] = int_dado;
                vetor_conjunto[int_conjunto].vetor_linha[linha_enc_conjunto].dirty = 1;
                printf("\nDado n�o encontrado na cache!\n");
                faltas_escrita[0]++;
            }
            else
            {
                printf("\nDado encontrado na cache!\n");
                acertos_escrita[0]++;
            }
        }
    }
}

void main(void)
{
    struct conjunto vetor_conjunto[2];
    struct bloco vetor_bloco[32];
    double porc, acertos_leitura[1] = {0}, acertos_escrita[1] = {0}, faltas_leitura[1] = {0}, faltas_escrita[1] = {0};
    int op;
    for (int i = 0; i < 32; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            vetor_bloco[i].vet2[j] = rand() % 256;
        }
    }
    for (int i = 0; i < 2; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            vetor_conjunto[i].vetor_linha[j].pol_sub = 0;
            vetor_conjunto[i].vetor_linha[j].valido = 0;
            vetor_conjunto[i].vetor_linha[j].dirty = 0;
        }
    }
    do
    {
        puts("\n\t\t\t\t\t\tMENU\n");
        puts("\t\t\t(1) Para ler o conteudo de um endereco da memoria;");
        puts("\t\t\t(2) Para escrever em um determinado endereco da memoria;");
        puts("\t\t\t(3) Para apresentar as estatisticas de acertos e faltas;");
        puts("\t\t\t(4) Para printar MP e Cache;");
        puts("\t\t\t(0) Para encerrar o programa.\n");
        printf("\t\t\tDigite o numero correspondente a opcao: ");
        scanf("%d", &op);
        switch (op)
        {
        case 1:
            ender_cache(vetor_bloco, vetor_conjunto, acertos_leitura, acertos_escrita, faltas_leitura, faltas_escrita, 0);

            break;
        case 2:
            ender_cache(vetor_bloco, vetor_conjunto, acertos_leitura, acertos_escrita, faltas_leitura, faltas_escrita, 1);

            break;
        case 3:
            printf("\n\t\t\t\t\t\tESTATISTICAS:\n");
            porc = (acertos_leitura[0] / (acertos_leitura[0] + faltas_leitura[0])) * 100;
            printf("\n\t\t\tAcertos (leitura): %.0lf (absoluto) | %.2lf (porcentagem)\n", acertos_leitura[0], porc);
            porc = (faltas_leitura[0] / (acertos_leitura[0] + faltas_leitura[0])) * 100;
            printf("\t\t\tFaltas (leitura):  %.0lf (absoluto) | %.2lf (porcentagem)\n", faltas_leitura[0], porc);
            porc = (acertos_escrita[0] / (acertos_escrita[0] + faltas_escrita[0])) * 100;
            printf("\n\t\t\tAcertos (escrita): %.0lf (absoluto) | %.2lf (porcentagem)\n", acertos_escrita[0], porc);
            porc = (faltas_escrita[0] / (acertos_escrita[0] + faltas_escrita[0])) * 100;
            printf("\t\t\tFaltas (escrita):  %.0lf (absoluto) | %.2lf (porcentagem)\n", faltas_escrita[0], porc);
            porc = ((acertos_escrita[0] + acertos_leitura[0]) / (acertos_leitura[0] + acertos_escrita[0] + faltas_escrita[0] + faltas_leitura[0])) * 100;
            printf("\n\t\t\tAcertos (geral):   %.0lf (absoluto) | %.2lf (porcentagem)\n", acertos_escrita[0] + acertos_leitura[0], porc);
            porc = ((faltas_escrita[0] + faltas_leitura[0]) / (acertos_leitura[0] + acertos_escrita[0] + faltas_escrita[0] + faltas_leitura[0])) * 100;
            printf("\t\t\tFaltas (geral):    %.0lf (absoluto) | %.2lf (porcentagem)\n", faltas_escrita[0] + faltas_leitura[0], porc);
            break;
        case 4:
            print_mem(vetor_bloco, vetor_conjunto);
            break;
        case 0:
            system("clear");
            puts("Voce escolheu por sair! Ate mais!");
            break;
        default:
            system("clear");
            puts("Opcao invalida!");
        }
    } while (op != 0);
}
