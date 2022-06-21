#ifndef TREENODE_H
#define TREENODE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <assert.h>

typedef enum Type
{
    terminal_int,
    terminal_hex,
    terminal_oct,
    terminal_float,
    terminal_id,
    terminal_type,
    terminal_other,
    non_terminal
}Type;

// single node of the syntax tree
typedef struct TreeNode
{
    int lineno; //line number of the lexical unit
    Type type; //type of the lexical unit
    char* value;    //value of the lexical unit(yytext)
    struct TreeNode* firstChild, *nextSibling;
}TreeNode;

typedef TreeNode* pNode;

// create a new tree node to connect several child node
pNode createNode(int _lineno, Type _type, char* _value, int args, ...);
void delTree(pNode root);
void printTree(pNode root, int i);
#endif
