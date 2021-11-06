%option noyywrap yylineno
%{
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include "parser.tab.h"
%}

pt1 ([0-9]|[a-zA-Z])+
pt2 ([0-9]|[a-zA-Z]|\.|\'|\!|\?|\:|\,|\;|" ")*
delim (\{|\})

%%
"\\documentclass"					{ return CLASSE; }
"\\usepackage"						{ return PACOTE; }
"\\title"									{ return TITULO; }
"\\author"								{ return AUTOR; }
{delim}										{ return DELIM; }
({pt1}{pt2})				      { yylval.palavra = strdup(yytext); return TEXTO; }
%%
