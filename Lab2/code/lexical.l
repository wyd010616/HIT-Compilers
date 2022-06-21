%{
    #include "TreeNode.h"
    #include "syntax.tab.h"
    #include <string.h>
    #include <stdio.h>
    #include <math.h>
    extern boolean lexical_error;  //词法错误标志
    int yycolumn = 1;
    int lines = 0;
    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line = yylineno; \
        yylloc.first_column = yycolumn; \
        yylloc.last_column = yycolumn + yyleng - 1; \
        yycolumn += yyleng;
%}

%option yylineno
INT 0|([1-9][0-9]*)
DECERROR [0-9]+[a-wA-Wy-zY-Z]+[0-9a-dA-Df-zF-Z]*|[0-9]+[0-9]+[a-dA-Df-zF-Z]+[0-9]*[0-9a-dA-Df-zF-Z]*
OCT 0[0-7]+
OCTERROR 0[0-7]*[8-9]+[0-9]*
HEX 0[xX][0-9a-fA-F]+
HEXERROR 0[xX][0-9a-fA-F]*[g-zG-Z]+[0-9a-zA-Z]*
FLOAT   [0-9]+\.[0-9]+([eE][+-]?[0-9]+)?|[0-9]+[eE][+-]?[0-9]+|\.[0-9]+|[0-9]+\.|[eE][+-]?[0-9]+|[.][0-9]+[Ee][+-]?[0-9]+|[0-9]+\.[Ee][+-]?[0-9]+
FLOATERROR \.[eE][+-]?[0-9]+|[0-9]*\.[0-9]+[eE][+-]?|[0-9]+\.[0-9]*[eE][+-]?|[0-9]+[Ee][+-]?|\.[eE][+-]?
ID  [a-zA-Z_][a-zA-Z_0-9]*
SEMI    ;
COMMA   ,
ASSIGNOP    =
RELOP   >|<|>=|<=|==|!=
PLUS    \+
MINUS   -
STAR    \*
DIV \/
AND &&
OR  \|\|
DOT \.
NOT !
TYPE    "int"|"float"
LP  \(
RP  \)
LB  \[
RB  \]
LC  \{
RC  \}
STRUCT  "struct"
RETURN  "return"
IF  "if"
ELSE    "else"
WHILE   "while"
BLANK   [ ]
TAB [ \t]
%%
{TYPE}  { yylval = createNode(yylineno, TOKEN_TYPE, "TYPE", yytext, 0); return TYPE;}
{STRUCT}    { yylval = createNode(yylineno, TOKEN_OTHER, "STRUCT", yytext, 0); return STRUCT;}
{RETURN}    { yylval = createNode(yylineno, TOKEN_OTHER, "RETURN", yytext, 0); return RETURN;}
{IF}    { yylval = createNode(yylineno, TOKEN_OTHER, "IF", yytext, 0); return IF;}
{ELSE}  { yylval = createNode(yylineno, TOKEN_OTHER, "ELSE", yytext, 0); return ELSE;}
{WHILE} { yylval = createNode(yylineno, TOKEN_OTHER, "WHILE", yytext, 0); return WHILE;}
{INT}   { yylval = createNode(yylineno, TOKEN_INT, "INT", yytext, 0); return INT;}
{HEX}   { yylval = createNode(yylineno, TOKEN_HEX, "INT", yytext, 0); return INT;}
{OCT}   { yylval = createNode(yylineno, TOKEN_OCT, "INT", yytext, 0); return INT;}
{FLOAT} { yylval = createNode(yylineno, TOKEN_FLOAT, "FLOAT", yytext, 0); return FLOAT;}
{ID}    { yylval = createNode(yylineno, TOKEN_ID, "ID", yytext, 0); return ID;}
{SEMI}  { yylval = createNode(yylineno, TOKEN_OTHER, "SEMI", yytext, 0); return SEMI;}
{COMMA} { yylval = createNode(yylineno, TOKEN_OTHER, "COMMA", yytext, 0); return COMMA;}
{ASSIGNOP}  { yylval = createNode(yylineno, TOKEN_OTHER, "ASSIGNOP", yytext, 0); return ASSIGNOP;}
{RELOP} { yylval = createNode(yylineno, TOKEN_OTHER, "RELOP", yytext, 0); return RELOP;}
{PLUS}  { yylval = createNode(yylineno, TOKEN_OTHER, "PLUS", yytext, 0); return PLUS;}
{MINUS} { yylval = createNode(yylineno, TOKEN_OTHER, "MINUS", yytext, 0); return MINUS;}
{STAR}  { yylval = createNode(yylineno, TOKEN_OTHER, "STAR", yytext, 0); return STAR;}
{DIV}   { yylval = createNode(yylineno, TOKEN_OTHER, "DIV", yytext, 0); return DIV;}
{AND}   { yylval = createNode(yylineno, TOKEN_OTHER, "AND", yytext, 0); return AND;}
{OR}    { yylval = createNode(yylineno, TOKEN_OTHER, "OR", yytext, 0); return OR;}
{DOT}   { yylval = createNode(yylineno, TOKEN_OTHER, "DOT", yytext, 0); return DOT;}
{NOT}   { yylval = createNode(yylineno, TOKEN_OTHER, "NOT", yytext, 0); return NOT;}
{LP}    { yylval = createNode(yylineno, TOKEN_OTHER, "LP", yytext, 0); return LP;}
{RP}    { yylval = createNode(yylineno, TOKEN_OTHER, "RP", yytext, 0); return RP;}
{LB}    { yylval = createNode(yylineno, TOKEN_OTHER, "LB", yytext, 0); return LB;}
{RB}    { yylval = createNode(yylineno, TOKEN_OTHER, "RB", yytext, 0); return RB;}
{LC}    { yylval = createNode(yylineno, TOKEN_OTHER, "LC", yytext, 0); return LC;}
{RC}    { yylval = createNode(yylineno, TOKEN_OTHER, "RC", yytext, 0); return RC;}
{BLANK} {}
{TAB}   {yycolumn += 3;}
\n|\r {yycolumn = 1;}
"//"    {
            char c = input(); //丢弃该行全部内容
            while (c != '\n' && c != EOF) 
                c = input();
        }
"/*"    {
	char a = input();
	char b = input(); //必须是连续的'/*','*/'
	while(a != '*' || b != '/') 
        {
        	a = b;
		b = input();
		if(b == EOF)
		{
			printf("Error type B at Line %d: Missing */.\n",yylineno);
			break;
		}
        }
	}
{OCTERROR}  {printf("Error type A at Line %d: Illegal octal number \'%s\'\n", yylineno, yytext); yylval = NULL; lexical_error = 1; return ERRORNUM;}
{HEXERROR} {printf("Error type A at Line %d: Illegal hexadecimal number \'%s\'\n", yylineno, yytext); yylval = NULL; lexical_error = 1; return ERRORNUM;}
{DECERROR} {printf("Error type A at Line %d: Illegal decimal number \'%s\'\n", yylineno, yytext); yylval = NULL; lexical_error = 1; return ERRORNUM;}
{FLOATERROR} {printf("Error type A at Line %d: Illegal floating number \'%s\'\n", yylineno, yytext); yylval = NULL; lexical_error = 1; return ERRORNUM;}
.   {printf("Error type A at Line %d: Mysterious characters \'%s\'\n", yylineno, yytext); lexical_error = 1;}
%%

void yyerror(const char* msg){
    fprintf(stderr, "Error type B at line %d: %s.\n", yylineno, msg);
    return;
}
