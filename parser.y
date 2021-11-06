%{
#include <stdio.h>
#include <stdlib.h>
#include "lib.h"

int yylex();
void yyerror( char *s);

FILE *arquivoSaida = NULL;
void abrir_arquivo();
%}

%union{
	char *palavra;
}

%token <palavra> TEXTO
%token CLASSE
%token PACOTE
%token TITULO
%token DELIM
%token AUTOR

%%

programa:
		documentoLatex
		;

documentoLatex:
 		identificacao
		;

identificacao:
		| titulo autor
		;

titulo:
		TITULO DELIM titulotex DELIM
		;

autor:
		AUTOR DELIM autortex DELIM
		;

titulotex:
		TEXTO {
			abrir_arquivo();
			fprintf(arquivoSaida,"#%s\n", $1);
		}
		;

autortex:
		TEXTO {
			fprintf(arquivoSaida,"##%s\n", $1);
		}
		;

%%

void abrir_arquivo() {
	arquivoSaida = fopen("/home/andrey/Desktop/TRAB-01/arquivoSaida.txt", "w");

	if (!arquivoSaida)
		printf(">Erro ao criar o arquivo!\n");
}
