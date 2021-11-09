//Calculadora :: definição de funções em C

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include "lib.h"

extern FILE *yyin;

extern int yyparse();

void yyerror(char *s) {
	printf(">%s\n", s);
}

void abrir_arquivo(FILE **arquivo) {
	*arquivo = fopen("/home/andrey/Desktop/TRAB-01/arquivoSaida.md", "w");

	if (!(*arquivo))
		printf(">Erro ao criar o arquivo!\n");
}

void printa_arquivo(FILE *arquivo, char *texto) {
	fprintf(arquivo, "%s", texto);
}

int main(int argc, char **argv) {
	if (argc > 1) {
		if (!(yyin = fopen(argv[1], "r"))) {
			perror(argv[1]);
			return(1);
		}
	}

  return yyparse();
}
