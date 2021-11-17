%{
#include <stdio.h>
#include <stdlib.h>
#include "lib.h"

int yylex();
void yyerror( char *s);

FILE *arquivoSaida = NULL;
void abrir_arquivo(FILE **arquivo);
void printa_arquivo(FILE *arquivo, char *texto);
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
%token CAPITULO
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
		| capitulo corpo corpolista | secao corpo corpolista | subsecao corpo corpolista
		;		
				
capitulo:
		CAPITULO DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"### "); } texto DELIM pulalinha
		;
		
secao:
		SECAO DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"#### "); } texto DELIM pulalinha
		;

subsecao:
		SUBSECAO DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"###### "); } texto DELIM pulalinha
		;
		
corpo:
		| texto estilo corpo | texto listas corpo | listas texto corpo | listas | estilo
		;

estilo:
		BOLD DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"**"); } texto { printa_arquivo(arquivoSaida,"** "); } DELIM
		| ITALIC DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"*"); } texto { printa_arquivo(arquivoSaida,"* "); } DELIM
		;

listas :
		| listanum listas | listaitem listas
		;
		
listanum:
		INICIOLN ignorarlinha itensl FIMLN pulalinha
		;
		
listaitem:
		INICIOIT ignorarlinha itensi FIMIT pulalinha
		;
		
itensl:
		| itensln itensl
		;		
		
itensi:
		| itensit itensi
		;
		
itensln:
		ITEM TEXTO {
			if(!arquivoSaida)
				abrir_arquivo(&arquivoSaida);
				
			printa_arquivo(arquivoSaida, "1. ");		
			printa_arquivo(arquivoSaida, $2);
		}
		;
		
itensit:
		ITEM TEXTO {
			if(!arquivoSaida)
				abrir_arquivo(&arquivoSaida);
				
			printa_arquivo(arquivoSaida, "* ");	
			printa_arquivo(arquivoSaida, $2);
		}
		;

fimdoc:
		FIMDOC ignorarlinha
		;

titulo:
		TITULO DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"# "); } texto  DELIM pulalinha
		;

autor:
		AUTOR DELIM { if(!arquivoSaida) abrir_arquivo(&arquivoSaida); printa_arquivo(arquivoSaida,"## "); } texto DELIM pulalinha
		;

pulalinha:
		| EOL pulalinha{
			if(!arquivoSaida)
				abrir_arquivo(&arquivoSaida);	
				
			printa_arquivo(arquivoSaida,"\n");
		}
		;
		
texto:
		TEXTO {
			if(!arquivoSaida)
				abrir_arquivo(&arquivoSaida);
				
			printa_arquivo(arquivoSaida, $1);
		}
		;
		
ignorartexto:
		TEXTO
		;
		
ignorarlinha:
		| EOL ignorarlinha
		;
%%
