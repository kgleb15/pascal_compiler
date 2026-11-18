#ifndef PASCAL_COMPILER_BLOCKNODE_H
#define PASCAL_COMPILER_BLOCKNODE_H
#include "StmtNode.h"

class DeclNode;

class BlockNode {
    friend class DotPrinter;
protected:
    int id;
    DeclNode* declarations = nullptr; // Список разделов объявлений
    StmtNode* body = nullptr;

    BlockNode() {
        id = NextNodeId();
    }

public:
    static BlockNode* CreateBlockNode(DeclNode* declarations, StmtNode* body);
};


#endif //PASCAL_COMPILER_BLOCKNODE_H
