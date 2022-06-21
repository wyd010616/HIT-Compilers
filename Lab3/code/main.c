#include "inter.h"
#include "syntax.tab.h"

extern int yylineno;
extern int yyparse();
extern void yyrestart(FILE*);

int syntax_error = 0;
int lexical_error = 0;
extern pNode root;

int main(int argc,char** argv){
    if(argc<=1){
	yyparse();
        return 1;
    }

    FILE* fr = fopen(argv[1], "r");
    if (!fr) {
        perror(argv[1]);
        return 1;
    }

    FILE* fw = fopen(argv[2], "wt+");
    if (!fw) {
        perror(argv[2]);
        return 1;
    }

    yyrestart(fr);
    yyparse();
    if(syntax_error == 0 && lexical_error == 0){
        table = initTable();
        //printTree(root, 0);
        Traversal(root);
	interCodeList = newInterCodeList();
        genInterCodes(root);
        if (!interError) {
            //printInterCode(NULL, interCodeList);
            printInterCode(fw, interCodeList);
        }
        // deleteInterCodeList(interCodeList);
        deleteTable(table);
    }
    //delTree(root);
    delNode(&root);
    return 0;
}
