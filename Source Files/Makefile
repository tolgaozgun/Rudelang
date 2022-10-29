parser: lex.yy.c y.tab.c
	gcc -o parser y.tab.c
y.tab.c: rude.yacc
	yacc -v rude.yacc
lex.yy.c: rude.lex
	lex rude.lex
