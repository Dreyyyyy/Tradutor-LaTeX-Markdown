%
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
%token EOL

%%

programa:
		documentoLatex
		;

documentoLatex:
 		configuracao identificacao
		;
		
configuracao:
		classe pacote
		;
		
classe:
		CLASSE DELIM ignorartexto DELIM ignorarlinha {
			printf("Classes ignoradas.\n");
		}
		;

pacote:
		| PACOTE DELIM ignorartexto DELIM ignorarlinha pacote| PACOTE DELIM ignorartexto DELIM DELIM ignorartexto DELIM ignorarlinha pacote {
			printf("Pacotes ignorados.\n");
		}
		;

identificacao:
		titulo autor
		;

titulo:
		TITULO DELIM titulotex DELIM pulalinha
		;

autor:
		AUTOR DELIM autortex DELIM pulalinha
		;

titulotex:
		TEXTO {
			if(!arquivoSaida)
				abrir_arquivo();
				
			fprintf(arquivoSaida,"#%s", $1);
		}
		;

autortex:
		TEXTO {
			if(!arquivoSaida)
				abrir_arquivo();
				
			fprintf(arquivoSaida,"##%s", $1);
		}
		;
		
pulalinha:
		| EOL pulalinha{
			if(!arquivoSaida)
				abrir_arquivo();	
				
			fprintf(arquivoSaida,"\n");
		}
		;
		
ignorartexto:
		TEXTO
		;
		
ignorarlinha:
		| EOL ignorarlinha
		;
%%

void abrir_arquivo() {
	arquivoSaida = fopen("/home/andrey/Desktop/TRAB-01/arquivoSaida.txt", "w");

	if (!arquivoSaida)
		printf(">Erro ao criar o arquivo!\n");
}
