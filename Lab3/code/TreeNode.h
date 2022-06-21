#ifndef TREENODE_H
#define TREENODE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <assert.h>

#include "enum.h"

#define TRUE 1
#define FALSE 0

// single node of the syntax tree
typedef struct TreeNode
{
    int lineNo; //line number of the lexical unit
    NodeType type; //type of the lexical unit
    char* name;
    char* val;    //value of the lexical unit(yytext)
    struct TreeNode *child, *next;
}Node;

typedef Node* pNode;
typedef unsigned boolean;

// create a new tree node to connect several child node
pNode createNode(int _lineno, NodeType _type, char* _name, char* _value, int args, ...);
void delTree(pNode node);
void delNode(pNode* node);
void printTree(pNode root, int i);

static inline char* newString(char* src) {
    if (src == NULL) return NULL;
    int length = strlen(src) + 1;
    char* p = (char*)malloc(sizeof(char) * length);
    assert(p != NULL);
    strncpy(p, src, length);
    return p;
}
#endif
