#include "TreeNode.h"
pNode createNode(int _lineno, Type _type, char* _value, int args, ...)
{
    pNode currNode = (pNode)malloc(sizeof(TreeNode));
    assert(currNode != NULL);
    currNode->value = (char*)malloc(sizeof(char) * (strlen(_value) + 1));// yytex为char*类型
    assert(currNode->value != NULL);
    
    currNode->firstChild = NULL; //左孩子
    currNode->nextSibling = NULL; //右兄弟
    currNode->lineno = _lineno;
    currNode->type = _type;
    strncpy(currNode->value, _value, strlen(_value)+1);
    
    if(args > 0) // terminal 无孩子兄弟节点
    {
        va_list ap;
        va_start(ap, args);
	pNode tempNode = va_arg(ap, pNode);
	currNode->firstChild = tempNode;
	for (int i = 1; i < args; i++){	
        	// get the first parameter to be the first child
        	tempNode->nextSibling = va_arg(ap, pNode);
		if(tempNode->nextSibling != NULL)
                	tempNode = tempNode->nextSibling;
        }
        va_end(ap);
    }
    return currNode;
}

void delTree(pNode root)
{
    if(root == NULL)
        return;
    pNode tempNode = root->firstChild;
    free(root);
    while(tempNode != NULL)
    {
        pNode nextNode = tempNode->nextSibling;
        delTree(tempNode);
        tempNode = nextNode;
    }
}

void printTree(pNode root, int i) // lineno
{
    if (root == NULL)
        return;
    pNode tempNode = root;
    int n = i;
    while(tempNode != NULL)
    {
        while(n > 1)
        {
            printf("  ");
            n--;
        }
        if(tempNode->type == non_terminal)
            printf("%s (%d)\n", tempNode->value, tempNode->lineno);
        else if(tempNode->type == terminal_other)
            printf("%s\n", tempNode->value);
        else if(tempNode->type == terminal_type)
            printf("TYPE: %s\n", tempNode->value);
        else if(tempNode->type == terminal_int)
            printf("INT: %d\n", atoi(tempNode->value));
	else if(tempNode->type == terminal_hex)
            printf("INT: %ld\n", strtol(tempNode->value,NULL,16));
	else if(tempNode->type == terminal_oct)
            printf("INT: %ld\n", strtol(tempNode->value,NULL,8));
        else if(tempNode->type == terminal_float)
            printf("FLOAT: %f\n", atof(tempNode->value));
        else if(tempNode->type == terminal_id)
            printf("ID: %s\n", tempNode->value);
        printTree(tempNode->firstChild, i + 1); // 递归先序遍历左子树
        tempNode = tempNode->nextSibling;
        n = i;
    }
}
