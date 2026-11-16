#ifndef PASCAL_COMPILER_PROGRAMNODE_H
#define PASCAL_COMPILER_PROGRAMNODE_H
#include <string>

#include "BlockNode.h"

class ProgramNode {
    friend class DotPrinter;
protected:
    int id;
    std::string name;
    BlockNode* block;

    ProgramNode() {
        id = NextNodeId();
    }

public:
    static ProgramNode* CreateProgramNode(const std::string& name, BlockNode* block);
};


#endif //PASCAL_COMPILER_PROGRAMNODE_H
