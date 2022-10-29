/* rude.l */

alphabetic      [A-Za-z]
digit           [0-9] 
alphanumeric    ({alphabetic}|{digit})
symbol          [!-@]
char_literal	'({alphanumeric}|{symbol})'
string_literal  \"({alphanumeric}|{symbol}|.)*\"
sensor_type     (TEMPERATURE|HUMIDITY|AIR_PRESSURE|AIR_QUALITY|LIGHT|SOUND_LEVEL) 
sign		[+-]
%%

\{                                  return LB;
\}                                  return RB;
\;                                  return SEMICOLON;
\=                                  return ASSIGN_OP;
\<\=                                return LESS_EQ_THAN;
\>\=                                return GREATER_EQ_THAN;
\<                                  return LESS_THAN;
\>                                  return GREATER_THAN;
\=\=								return EQUALS_TO;
\!\=					return NOT_EQUALS_TO;
\(                                  return LP;
\)                                  return RP;
\+                                  return PLUS_OP;
\/                                  return DIV_OP; 
\-                                  return SUB_OP;
\*                                  return MULT_OP;
\*\*								return FACTOR_OP;
\&\&                                return LOGICAL_AND;
\|\|                                return LOGICAL_OR;
\,                                  return COMMA;
\.									return DOT;
\/\#[^(\#\/)]*\#\/		    { /* DO NOTHING - DO NOT RETURN COMMENT */ }
for                                 return FOR;
while                               return WHILE;
if                                  return IF;
else								return ELSE;
elif								return ELSEIF;
int                                 return DT_INT;
long                                return DT_LONG;
float                               return DT_FLOAT;
double                              return DT_DOUBLE;
boolean                             return DT_BOOLEAN;
string                              return DT_STRING;
char                                return DT_CHAR;
{sensor_type}							return DT_SENSOR;
void								return RT_VOID;
endpls	return ENDPLS;
pls								return PLEASE;
return								return RETURN;
start								return START;
func								return FUNC;
getCurrentTimestamp					return FUNC_ID_TIMESTAMP;
connectToURL						return FUNC_ID_CONNECT_URL;
getDataFromURL						return FUNC_ID_GET_DATA;
sendDataToURL						return FUNC_ID_SEND_DATA;
connectToInternet					return FUNC_ID_CONNECT_INT;
isConnectedToInternet				return FUNC_ID_IS_CONNECT_INT;
print								return FUNC_ID_PRINT;
enter								return FUNC_ID_ENTER;
toggleSwitchOn						return FUNC_ID_SWITCH_ON;
toggleSwitchOff						return FUNC_ID_SWITCH_OFF;
readSensorData						return FUNC_ID_READ_SENSOR_DATA;

{sign}?{digit}+                            return INTEGER;
{sign}?{digit}*(\.)?{digit}+               return FLOATING_POINT;


true                                return BL_TRUE;
false                               return BL_FALSE;

{char_literal}						return CHAR_LITERAL;
{string_literal}                   	return STRING_LITERAL;
{alphabetic}({alphanumeric})*       return IDENTIFIER;
\n                                                                      {;extern int lineno; ++lineno; return NEWLINE;}
.                                   {; }

%%
int yywrap() { return 1; }

