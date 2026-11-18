#ifndef PASCAL_COMPILER_SUBROUTINENODE_H
#define PASCAL_COMPILER_SUBROUTINENODE_H
#include <string>
#include <utility>
#include <vector>

#include "BlockNode.h"
#include "ParamNode.h"


enum SubroutineNodeType {
    ENUM_SUB_PROCEDURE,
    ENUM_SUB_FUNCTION,
    ENUM_SUB_CONSTRUCTOR,
    ENUM_SUB_DESTRUCTOR,
};

class DeclNode;

class SubroutineNode {
    friend class DotPrinter;
protected:
    int id;
    SubroutineNodeType nodeType;

    std::vector<std::string> nameParts; // Элементы квалифицированного имени
    std::vector<ParamNode*> params;     // Группы параметров
    TypeNode* returnType = nullptr;     // Возвращаемое значение
    std::vector<std::string> modifiers; // Модификаторы
    BlockNode* body = nullptr;          // Тело (null для forward и объявления в классе)

    SubroutineNode() {
        id = NextNodeId();
    }

public:
    static SubroutineNode* CreateSubroutineHeader(SubroutineNodeType nodeType, DeclNode* nameList, ParamNode* paramList, TypeNode* returnType);

    void setModifiers(std::vector<std::string> modifiers) {
        this->modifiers = std::move(modifiers);
    }

    void setBody(BlockNode* body) {
        this->body = body;
    }
};

#endif //PASCAL_COMPILER_SUBROUTINENODE_H
