#ifndef PASCAL_COMPILER_PROGRAMNODE_H
#define PASCAL_COMPILER_PROGRAMNODE_H
#include <string>

#include "BlockNode.h"

class ProgramNode {
    friend class DotPrinter;
protected:
    int id;
    std::string name;   // Имя программы
    BlockNode* block;   // Главный блок программы

    ProgramNode() {
        id = NextNodeId();
    }

public:
    static ProgramNode* CreateProgramNode(const std::string& name, BlockNode* block);
};


#endif //PASCAL_COMPILER_PROGRAMNODE_H
