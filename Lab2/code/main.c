#include "semantic.h"
#include "syntax.tab.h"

extern int yylineno;
extern int yyparse();
extern void yyrestart(FILE* f);

int syntax_error = 0;
int lexical_error = 0;
extern pNode root;

int main(int argc,char** argv){
    if(argc<=1){
	yyparse();
        return 1;
    }

    FILE* f=fopen(argv[1],"r");
    if(!f)
    {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yyparse();
    if(syntax_error == 0 && lexical_error == 0){
        table = initTable();
        //printTree(root, 0);
        Traversal(root);
        deleteTable(table);
    }
    delTree(root);
    return 0;
}
