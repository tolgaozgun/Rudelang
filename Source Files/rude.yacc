%token LB RB SEMICOLON ASSIGN_OP LESS_EQ_THAN GREATER_EQ_THAN LESS_THAN GREATER_THAN LP RP PLUS_OP
%token DIV_OP SUB_OP MULT_OP FACTOR_OP LOGICAL_AND LOGICAL_OR COMMA FOR WHILE IF ELSE ELSEIF
%token RT_VOID PLEASE RETURN NEWLINE NOT_EQUALS_TO ENDPLS
%token FUNC_ID_TIMESTAMP FUNC_ID_CONNECT_URL FUNC_ID_GET_DATA FUNC_ID_SEND_DATA FUNC_ID_CONNECT_INT
%token FUNC_ID_IS_CONNECT_INT FUNC_ID_PRINT FUNC_ID_ENTER FUNC_ID_SWITCH_ON FUNC_ID_SWITCH_OFF FUNC_ID_READ_SENSOR_DATA
%token INTEGER FLOATING_POINT BL_TRUE BL_FALSE STRING_LITERAL IDENTIFIER COMMENT FUNC CHAR_LITERAL DOT EQUALS_TO
%token START DT_INT DT_LONG DT_FLOAT DT_DOUBLE DT_BOOLEAN DT_STRING DT_CHAR DT_SENSOR RT_VOID

%start program

%%
program: start_function newline_list ENDPLS {printf("Parsing is successfully completed, no error detected. We hope you are pleased with our language!"); return 1;}
	| start_function newline_list function_list newline_list ENDPLS {printf("Parsing is successfully completed, no error detected. We hope you are pleased with our language!\n"); return 1;}
 

start_function: return_type START LP RP LB statement_list RB
newline_list: newline_list NEWLINE
	| NEWLINE

statement_list: statement_list statement
        | statement
        | statement_list NEWLINE
        | NEWLINE
	| error SEMICOLON {yyerrok;}


statement: while_statement
        | for_statement
        | definition_statement
        | if_statement
        | return_statement
        | comment_statement
        | expression_statement

definition_statement: declaration_statement
        | assignment_statement
        | initialization_statement
        | empty_statement

/* Statements */
declaration_statement: data_type IDENTIFIER SEMICOLON
assignment_statement: IDENTIFIER ASSIGN_OP expression SEMICOLON
initialization_statement: data_type IDENTIFIER ASSIGN_OP expression SEMICOLON
empty_statement: SEMICOLON
expression_statement: expression SEMICOLON
return_statement: RETURN IDENTIFIER SEMICOLON
        | RETURN number SEMICOLON
        | RETURN STRING_LITERAL SEMICOLON
        | RETURN boolean_literal SEMICOLON
        | RETURN CHAR_LITERAL SEMICOLON
        | RETURN SEMICOLON
comment_statement: COMMENT
boolean_literal: BL_TRUE | BL_FALSE

/* conditional statements */
if_statement: IF LP conditional_expression RP LB statement_list RB else_if_statement else_statement
else_if_statement: ; | ELSEIF LP conditional_expression RP LB statement_list RB else_if_statement
else_statement: ; |  ELSE LB statement_list RB

/* loops */
while_statement: WHILE LP conditional_expression RP LB statement_list RB
for_statement: FOR LP definition_statement conditional_expression SEMICOLON definition_statement RP LB statement_list RB

/* built-in functions */
builtin_get_current_timestamp: FUNC_ID_TIMESTAMP LP RP
builtin_connect_to_url: FUNC_ID_CONNECT_URL LP returnable RP
builtin_get_data_from_url: FUNC_ID_GET_DATA LP STRING_LITERAL RP
	| FUNC_ID_GET_DATA LP IDENTIFIER RP
	| FUNC_ID_GET_DATA LP function_call RP
builtin_send_data_to_url: FUNC_ID_SEND_DATA LP returnable COMMA returnable RP
builtin_connect_to_internet: FUNC_ID_CONNECT_INT LP RP
builtin_is_connected_to_internet: FUNC_ID_IS_CONNECT_INT LP RP
builtin_print: FUNC_ID_PRINT LP expression RP
builtin_read_sensor_data: FUNC_ID_READ_SENSOR_DATA LP DT_SENSOR COMMA number RP
	| FUNC_ID_READ_SENSOR_DATA LP DT_SENSOR COMMA IDENTIFIER RP
	| FUNC_ID_READ_SENSOR_DATA LP DT_SENSOR RP
builtin_toggle_switch_off: FUNC_ID_SWITCH_OFF LP expression RP
builtin_toggle_switch_on: FUNC_ID_SWITCH_ON LP expression RP
builtin_enter: FUNC_ID_ENTER LP RP
builtin_function: builtin_get_current_timestamp
	| builtin_connect_to_url
	| builtin_get_data_from_url
	| builtin_send_data_to_url
	| builtin_connect_to_internet
	| builtin_is_connected_to_internet
	| builtin_print
	| builtin_read_sensor_data
	| builtin_toggle_switch_off
	| builtin_toggle_switch_on
	| builtin_enter

/* function call */
function_call: PLEASE IDENTIFIER LP argument_list RP
	| PLEASE builtin_function
argument_list: argument_list COMMA returnable
	| returnable
	| ;

/* Expressions */
expression: conditional_expression

conditional_expression: conditional_and | conditional_expression LOGICAL_OR conditional_and
conditional_and: equality_expr | conditional_and LOGICAL_AND equality_expr
equality_expr: relational_expr 
	| equality_expr EQUALS_TO relational_expr 
	| equality_expr NOT_EQUALS_TO relational_expr
relational_expr: arithmetic_add_expr
	| relational_expr LESS_THAN arithmetic_add_expr
	| relational_expr GREATER_THAN arithmetic_add_expr
	| relational_expr LESS_EQ_THAN arithmetic_add_expr
	| relational_expr GREATER_EQ_THAN arithmetic_add_expr
arithmetic_add_expr: arithmetic_mult_expr
	| arithmetic_add_expr PLUS_OP arithmetic_mult_expr
	| arithmetic_add_expr SUB_OP arithmetic_mult_expr
arithmetic_mult_expr: arithmetic_base
	| arithmetic_mult_expr MULT_OP arithmetic_base
	| arithmetic_mult_expr DIV_OP arithmetic_base
	| arithmetic_mult_expr FACTOR_OP arithmetic_base
arithmetic_base: boolean_literal | number | STRING_LITERAL | CHAR_LITERAL | LP expression RP | IDENTIFIER | function_call

returnable: IDENTIFIER | number | function_call | literal
literal: boolean_literal | STRING_LITERAL | CHAR_LITERAL

function_list: function_list newline_list function
	| function
function: return_type FUNC IDENTIFIER LP parameter_list RP LB statement_list RB

parameter_list: parameter_list COMMA  parameter | parameter
parameter: data_type IDENTIFIER | ;

/* digerleri */
number: INTEGER
	| FLOATING_POINT

return_type: data_type | RT_VOID
data_type: DT_INT | DT_LONG | DT_FLOAT | DT_DOUBLE | DT_BOOLEAN | DT_STRING | DT_CHAR

%%
#include "lex.yy.c"
int lineno=1;
int yyerror(char *s) { printf("%s on line: %d!\n", s, lineno); }
int main() {
    return yyparse();
}
