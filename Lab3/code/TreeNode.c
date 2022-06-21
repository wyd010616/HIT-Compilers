#include "TreeNode.h"

pNode createNode(int _lineno, NodeType _type, char* _name, char* _value, int args, ...)
{
    pNode currNode = (pNode)malloc(sizeof(Node));
    assert(currNode != NULL);
    currNode->name = newString(_name);
    assert(currNode->name != NULL);
    currNode->lineNo = _lineno;
    currNode->type = _type;
    strncpy(currNode->name, _name, strlen(_name)+1);
    // TOKEN
    if (args == 0){
	currNode->val = newString(_value);// yytex为char*类型
	assert(currNode->val != NULL);
	currNode->child = NULL; //左孩子
    	currNode->next = NULL; //右兄弟
	return currNode;
    }
    else // NOT_A_TOKEN 无孩子兄弟节点，不存储值，只存储name
    {
        va_list ap;
        va_start(ap, args);
	pNode tempNode = va_arg(ap, pNode);
	currNode->child = tempNode;
	for (int i = 1; i < args; i++){	
        	// get the first parameter to be the first child
        	tempNode->next = va_arg(ap, pNode);
		if(tempNode->next != NULL)
                	tempNode = tempNode->next;
        }
        va_end(ap);
	return currNode;
    }
}

void delTree(pNode root)
{
    if(root == NULL)
        return;
    pNode tempNode = root->child;
    free(root);
    root = NULL;
    while(tempNode != NULL)
    {
        pNode nextNode = tempNode->next;
        delTree(tempNode);
        tempNode = nextNode;
    }
}

void delNode(pNode* node) {
    if (node == NULL) return;
    pNode p = *node;
    while (p->child != NULL) {
        pNode temp = p->child;
        p->child = p->child->next;
        delNode(&temp);
    }
    free(p->name);
    free(p->val);
    free(p);
    p = NULL;
}


void printTree(pNode root, int height) // lineno
{
    if (root == NULL)
        return;
    for (int i = 0; i < height; i++) {
        printf("  ");
    }
    printf("%s: ",root->name);
    if(root->type == NOT_A_TOKEN)
        printf("(%d)", root->lineNo);
    else if(root->type == TOKEN_TYPE || root->type == TOKEN_ID)
        printf("%s", root->val);
    else if(root->type == TOKEN_INT)
        printf("%d", atoi(root->val));
    else if(root->type == TOKEN_HEX)
        printf("%d", (int)strtol(root->val,NULL,16));
    else if(root->type == TOKEN_OCT)
        printf("%d", (int)strtol(root->val,NULL,8));
    else if(root->type == TOKEN_FLOAT)
        printf("%f", atof(root->val));
    printf("\n");
    printTree(root->child, height + 1);
    printTree(root->next, height);
}
