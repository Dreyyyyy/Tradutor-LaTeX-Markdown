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
%token <palavra> DOCUMENTO
%token CLASSE
%token PACOTE
%token TITULO
%token DELIM
%token AUTOR
%token EOL
%token INICIODOC
%token FIMDOC
%token SECAO
%token SUBSECAO
%token INICIOLN
%token FIMLN
%token ITEM
%token INICIOIT
%token FIMIT
%token ITALIC;
%token BOLD;

%%

programa:
		documentoLatex
		;

documentoLatex:
 		configuracao identificacao principal
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
		
principal:
		iniciodoc corpolista fimdoc
		;
		
iniciodoc:
		INICIODOC ignorarlinha
		;
		
corpolista:
		| secao corpo corpolista | subsecao corpo corpolista
		;		
		
secao:
		SECAO DELIM { if(!arquivoSaida) abrir_arquivo(); fprintf(arquivoSaida,"### "); } texto DELIM pulalinha
		;

subsecao:
		SUBSECAO DELIM { if(!arquivoSaida) abrir_arquivo(); fprintf(arquivoSaida,"#### "); } texto DELIM pulalinha
		;
		
corpo:
		texto estilo corpo | texto | listas | estilo
		;

estilo:
		BOLD DELIM { if(!arquivoSaida) abrir_arquivo(); fprintf(arquivoSaida,"**"); } texto { fprintf(arquivoSaida,"** "); } DELIM
		| ITALIC DELIM { if(!arquivoSaida) abrir_arquivo(); fprintf(arquivoSaida,"*"); } texto { fprintf(arquivoSaida,"* "); } DELIM
		;

listas :
		| listanum listas | listaitem listas
		;
		
listanum:
		INICIOLN ignorarlinha itensln FIMLN ignorarlinha
		;
		
listaitem:
		INICIOIT ignorarlinha itensit FIMIT ignorarlinha
		;
		
itensln:
		| ITEM TEXTO itensln {
			if(!arquivoSaida)
				abrir_arquivo();
				
			fprintf(arquivoSaida,"1. %s", $2);
		}
		;
		
itensit:
		| ITEM TEXTO itensit {
			if(!arquivoSaida)
				abrir_arquivo();
				
			fprintf(arquivoSaida,"* %s", $2);
		}
		;

fimdoc:
		FIMDOC ignorarlinha
		;

titulo:
		TITULO DELIM { if(!arquivoSaida) abrir_arquivo(); fprintf(arquivoSaida,"# "); } texto  DELIM pulalinha
		;

autor:
		AUTOR DELIM { if(!arquivoSaida) abrir_arquivo(); fprintf(arquivoSaida,"## "); } texto DELIM pulalinha
		;

pulalinha:
		| EOL pulalinha{
			if(!arquivoSaida)
				abrir_arquivo();	
				
			fprintf(arquivoSaida,"\n");
		}
		;
		
texto:
		TEXTO {
			if(!arquivoSaida)
				abrir_arquivo();
				
			fprintf(arquivoSaida,"%s", $1);
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
	arquivoSaida = fopen("/home/andrey/Desktop/TRAB-01/arquivoSaida.md", "w");

	if (!arquivoSaida)
		printf(">Erro ao criar o arquivo!\n");
}
