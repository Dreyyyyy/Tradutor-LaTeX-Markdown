//interface com o lexer
extern int yylineno; //do lexer

void yyerror(char *s);

void abrir_arquivo(FILE **arquivo);

void printa_arquivo(FILE *arquivo, char *texto);
