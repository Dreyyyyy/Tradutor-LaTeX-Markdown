%option noyywrap yylineno
%{
	#include <string.h>
	#include <stdio.h>
	#include <stdlib.h>
	#include "parser.tab.h"
%}

pt1 ([0-9]|[a-zA-Z])+
pt2 ([0-9]|[a-zA-Z]|\.|\'|\!|\?|\:|\,|\;|" "|\=|\+|\-|\*|\/|"\n"|\~)*
delim (\{|\}|\[|\])
eol [\n]

%%
"\\documentclass"					{ return CLASSE; }
"\\usepackage"						{ return PACOTE; }
"\\title"									{ return TITULO; }
"\\author"								{ return AUTOR; }
"\\begin{document}"				{	return INICIODOC; }
"\\end{document}"					{ return FIMDOC; }
"\\section"								{ return SECAO; }
"\\subsection"						{ return SUBSECAO; }
"\\begin{enumerate}"			{ return INICIOLN; }
"\\end{enumerate}"				{ return FIMLN; }
"\\begin{itemize}"				{ return INICIOIT; }
"\\end{itemize}"					{ return FIMIT;	}
"\\item"									{ return ITEM; }
"\\emph"									{ return ITALIC; }
"\\textbf"								{ return BOLD; }
{delim}										{ return DELIM; }
{eol}											{ return EOL; }
({pt1}{pt2})				      { yylval.palavra = strdup(yytext); return TEXTO; }
.													;
%%
