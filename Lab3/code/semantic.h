#ifndef SEMANTIC_H
#define SEMENTIC_H

#define HASH_TABLE_SIZE 0x3fff
#define STACK_DEEP

#include "TreeNode.h"

typedef struct type* pType;
typedef struct fieldList* pFieldList;
typedef struct tableItem* pItem;
typedef struct hashTable* pHash;
typedef struct stack* pStack;
typedef struct table* pTable;

typedef struct type {
    Kind kind;
    union {
        // 基本类型
        BasicType basic;
        // 数组类型信息包括元素类型与数组大小构成
        struct {
            pType elem;
            int size;
        } array;
        // 结构体类型信息是一个链表
        struct {
            char* structName;
            pFieldList field;
        } structure;

        struct {
            int argc;
            pFieldList argv;
            pType returnType;
        } function;
    } u;
} Type;

typedef struct fieldList {
    char* name;     // 域的名字
    pType type;     // 域的类型
    boolean isArg;  // 实验3中结构体参数需要传址，此处需要做特殊处理
    pFieldList tail;  // 下一个域
} FieldList;

typedef struct tableItem {
    int symbolDepth;
    pFieldList field;
    pItem nextSymbol;  // 栈中同等深度的符号
    pItem nextHash;    // 处理hash冲突
} TableItem;

typedef struct hashTable {
    pItem* hashArray; // 散列表
} HashTable;

typedef struct stack {
    pItem* stackArray;
    int curStackDepth; // 记录当前元素在栈中的深度
} Stack;

typedef struct table { //十字链表与open hashing
    pHash hash;
    pStack stack;
    int unNamedStructNum; //未命名结构体，词法分析中id不能为纯数字，所以将未命名结构体id暂时定义为int，同时可以处理冲突
} Table;

extern pTable table;

// Type functions
pType newType(Kind kind, ...);
pType copyType(pType src);
void deleteType(pType type);
boolean checkType(pType type1, pType type2);
void printType(pType type);

// FieldList functions
pFieldList newFieldList(char* newName, pType newType);
pFieldList copyFieldList(pFieldList src);
void deleteFieldList(pFieldList fieldList);
void setFieldListName(pFieldList p, char* newName);
void printFieldList(pFieldList fieldList);

// tableItem functions

pItem newItem(int symbolDepth, pFieldList pfield);
void deleteItem(pItem item);
boolean isStructDef(pItem src);

// Hash functions
pHash newHash();
void deleteHash(pHash hash);
pItem getHashHead(pHash hash, int index);
void setHashHead(pHash hash, int index, pItem newVal);

// Stack functions
pStack newStack();
void deleteStack(pStack stack);
void addStackDepth(pStack stack);
void minusStackDepth(pStack stack);
pItem getCurDepthStackHead(pStack stack);
void setCurDepthStackHead(pStack stack, pItem newVal);

// Table functions
pTable initTable();
void deleteTable(pTable table);
pItem searchTableItem(pTable table, char* name);
boolean checkTableItemConflict(pTable table, pItem item);
void addTableItem(pTable table, pItem item);
void deleteTableItem(pTable table, pItem item);
void clearCurDepthStackList(pTable table);
// void addStructLayer(pTable table);
// void minusStructLayer(pTable table);
// boolean isInStructLayer(pTable table);
void printTable(pTable table);

// Global functions
static inline unsigned int hash_pjw(char* name) {
    unsigned int val = 0, i;
    for (; *name; ++name) {
        val = (val << 2) + *name;
        if (i = val & ~HASH_TABLE_SIZE)
            val = (val ^ (i >> 12)) & HASH_TABLE_SIZE;
    }
    return val;
}

static inline void pError(ErrorType type, int line, char* msg) {
    printf("Error type %d at Line %d: %s\n", type, line, msg);
}

void Traversal(pNode node);

// Generate symbol table functions
void ExtDef(pNode node);
void ExtDecList(pNode node, pType specifier);
pType Specifier(pNode node);
pType StructSpecifier(pNode node);
pItem VarDec(pNode node, pType specifier);
void FunDec(pNode node, pType returnType);
void VarList(pNode node, pItem func);
pFieldList ParamDec(pNode node);
void CompSt(pNode node, pType returnType);
void StmtList(pNode node, pType returnType);
void Stmt(pNode node, pType returnType);
void DefList(pNode node, pItem structInfo);
void Def(pNode node, pItem structInfo);
void DecList(pNode node, pType specifier, pItem structInfo);
void Dec(pNode node, pType specifier, pItem structInfo);
pType Exp(pNode node);
void Args(pNode node, pItem funcInfo);

#endif
