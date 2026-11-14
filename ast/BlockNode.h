#ifndef PASCAL_COMPILER_BLOCKNODE_H
#define PASCAL_COMPILER_BLOCKNODE_H
#include "DeclNode.h"
#include "StmtNode.h"


class BlockNode {
protected:
    int id;
    DeclNode* declarations = nullptr;
    StmtNode* body = nullptr;

    BlockNode() {
        id = NextNodeId();
    }

public:
    static BlockNode* CreateBlockNode(DeclNode* declarations, StmtNode* body);
};


#endif //PASCAL_COMPILER_BLOCKNODE_H
