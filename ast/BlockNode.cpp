#include "BlockNode.h"

BlockNode* BlockNode::CreateBlockNode(DeclNode* declarations, StmtNode* body) {
    BlockNode* result = new BlockNode();
    result->declarations = declarations;
    result->body = body;
    return result;
}
