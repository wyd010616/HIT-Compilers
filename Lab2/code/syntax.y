%{
    #define YYSTYPE Node*
    #include "TreeNode.h"
    #include "lex.yy.c"
    extern boolean syntax_error;   // 语法错误标志
    pNode root;
%}

// terminal tokens
%token INT
%token FLOAT
%token ID   // identifier
%token TYPE // type
%token RELOP
%token ASSIGNOP //=
%token PLUS MINUS STAR DIV  // operator
%token AND OR NOT // logical operator
%token DOT COMMA SEMI LP RP LB RB LC RC // punctuation
%token STRUCT RETURN IF ELSE WHILE    // keyword
%token ERRORNUM ERRORID

// non-terminals
%type Program ExtDefList ExtDef ExtDecList   //  High-level Definitions
%type Specifier StructSpecifier OptTag Tag   //  Specifiers
%type VarDec FunDec VarList ParamDec         //  Declarators
%type CompSt StmtList Stmt                   //  Statements
%type DefList Def Dec DecList                //  Local Definitions
%type Exp Args                               //  Expressions

// precedence and associativity
%start Program
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left DOT
%left LB RB
%left LP RP
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%
// High-level Definitions
Program : ExtDefList {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Program", NULL, 1, $1); root = $$;}
;
ExtDefList : ExtDef ExtDefList {$$ = createNode(@$.first_line, NOT_A_TOKEN, "ExtDefList", NULL, 2, $1, $2);}
|   { $$ = NULL;}
;
ExtDef : Specifier ExtDecList SEMI  { $$ = createNode(@$.first_line, NOT_A_TOKEN, "ExtDef", NULL, 3, $1, $2, $3);}
| Specifier SEMI  {$$ = createNode(@$.first_line, NOT_A_TOKEN, "ExtDef", NULL, 2, $1, $2);}
| Specifier FunDec CompSt   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "ExtDef", NULL, 3, $1, $2, $3);}
| error SEMI  {syntax_error = TRUE;}
| Specifier error SEMI {syntax_error = TRUE;}
| error Specifier SEMI {syntax_error = TRUE;}
;
ExtDecList : VarDec {$$ = createNode(@$.first_line, NOT_A_TOKEN, "ExtDecList", NULL, 1, $1);}
| VarDec COMMA ExtDecList   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "ExtDecList", NULL, 3, $1, $2, $3);}
| VarDec error ExtDefList {syntax_error = TRUE;}
;

// Specifiers
Specifier : TYPE    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Specifier", NULL, 1, $1);}
| StructSpecifier   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Specifier", NULL, 1, $1);}
;
StructSpecifier : STRUCT OptTag LC DefList RC   { $$ = createNode(@$.first_line, NOT_A_TOKEN, "StructSpecifier", NULL, 5, $1, $2, $3, $4, $5);}
| STRUCT Tag    { $$ = createNode(@$.first_line, NOT_A_TOKEN, "StructSpecifier", NULL, 2, $1, $2);}
;
OptTag :  ID    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "OptTag", NULL, 1, $1);}
| {$$ = NULL;}
;
Tag : ID    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Tag", NULL, 1, $1);}
;

// Declarators
VarDec : ID { $$ = createNode(@$.first_line, NOT_A_TOKEN, "VarDec", NULL, 1, $1);}
| VarDec LB INT RB  {$$ = createNode(@$.first_line, NOT_A_TOKEN, "VarDec", NULL, 4, $1, $2, $3, $4);}
| VarDec LB error RB { syntax_error = TRUE; }
| error RB { syntax_error = TRUE; }
;
FunDec : ID LP VarList RP   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "FunDec", NULL, 4, $1, $2, $3, $4);}
| ID LP RP  {$$ = createNode(@$.first_line, NOT_A_TOKEN, "FunDec", NULL, 3, $1, $2, $3);}
| ID LP error RP { syntax_error = TRUE; }
| error LP VarList RP { syntax_error = TRUE; }
;
VarList : ParamDec COMMA VarList    { $$ = createNode(@$.first_line, NOT_A_TOKEN, "VarList", NULL, 3, $1, $2, $3);}
| ParamDec  { $$ = createNode(@$.first_line, NOT_A_TOKEN, "VarList", NULL, 1, $1);}
;
ParamDec : Specifier VarDec { $$ = createNode(@$.first_line, NOT_A_TOKEN, "ParamDec", NULL, 2, $1, $2);}
;

// Statements 移入规约冲突
CompSt : LC DefList StmtList RC {$$ = createNode(@$.first_line, NOT_A_TOKEN, "CompSt", NULL, 4, $1, $2, $3, $4);}
| error RC{ syntax_error = TRUE; }
;
StmtList : Stmt StmtList { $$ = createNode(@$.first_line, NOT_A_TOKEN, "StmtList", NULL, 2, $1, $2);}
| /* empty */  {$$ = NULL;}
;
Stmt : Exp SEMI {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Stmt", NULL, 2, $1, $2);}
| CompSt    { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Stmt", NULL, 1, $1);}
| RETURN Exp SEMI   { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Stmt", NULL, 3, $1, $2, $3);}
| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Stmt", NULL, 5, $1, $2, $3, $4, $5);}
| IF LP Exp RP Stmt ELSE Stmt   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Stmt", NULL, 7, $1, $2, $3, $4, $5, $6, $7);}
| WHILE LP Exp RP Stmt  { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Stmt", NULL, 5, $1, $2, $3, $4, $5);}
| error SEMI    {syntax_error = TRUE;}
| Exp error SEMI {syntax_error = TRUE;}
| RETURN Exp error  {syntax_error = TRUE;}
| RETURN error SEMI  {syntax_error = TRUE;}
;

// Local Definitions
DefList : Def DefList   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "DefList", NULL, 2, $1, $2);}
| /* empty */   {$$ = NULL;}
;
Def : Specifier DecList SEMI    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Def", NULL, 3, $1, $2, $3);}
| Specifier error SEMI {syntax_error = 1;}
| Specifier DecList error {syntax_error = 1;}
;
DecList : Dec   { $$ = createNode(@$.first_line, NOT_A_TOKEN, "DecList", NULL, 1, $1);}
| Dec COMMA DecList {$$ = createNode(@$.first_line, NOT_A_TOKEN, "DecList", NULL, 3, $1, $2, $3);}
;
Dec : VarDec    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Dec", NULL, 1, $1);}
| VarDec ASSIGNOP Exp   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Dec", NULL, 3, $1, $2, $3);}
;

// Expressions
Exp : Exp ASSIGNOP Exp  {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp AND Exp   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp OR Exp    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp RELOP Exp { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp PLUS Exp  { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp MINUS Exp {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp STAR Exp  { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp DIV Exp   { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| LP Exp RP {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| MINUS Exp { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 2, $1, $2);}
| NOT Exp   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 2, $1, $2);}
| ID LP Args RP { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 4, $1, $2, $3, $4);}
| ID LP RP  {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| Exp LB Exp RB { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 4, $1, $2, $3, $4);}
| Exp DOT ID    { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 3, $1, $2, $3);}
| ID    {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);}
| INT   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);}
| FLOAT { $$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);}
/*
| ERRORNUM {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);syntax_error = TRUE;}
| ERRORID {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Exp", NULL, 1, $1);syntax_error = TRUE;}
*/
;
Args : Exp COMMA Args   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Args", NULL, 3, $1, $2, $3);}
| Exp   {$$ = createNode(@$.first_line, NOT_A_TOKEN, "Args", NULL, 1, $1);}
;
%%


