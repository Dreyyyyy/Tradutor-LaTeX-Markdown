tradutor: lexer.l parser.y lib.h
	bison -d parser.y
	flex lexer.l
	gcc parser.tab.c lex.yy.c lib.c
	@echo Tradutor compilado!
