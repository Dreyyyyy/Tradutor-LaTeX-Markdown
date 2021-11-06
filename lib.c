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

int main(int argc, char **argv) {
	if (argc > 1) {
		if (!(yyin = fopen(argv[1], "r"))) {
			perror(argv[1]);
			return(1);
		}
	}

  return yyparse();
}
