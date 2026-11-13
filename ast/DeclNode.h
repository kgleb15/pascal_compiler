#ifndef PASCAL_COMPILER_DECLNODE_H
#define PASCAL_COMPILER_DECLNODE_H
#include <string>

#include "TypeNode.h"


enum DeclNodeType {
    ENUM_DECL_CONST,
    ENUM_DECL_VAR,
    ENUM_DECL_TYPE,
};

class DeclNode {
protected:
    int id;
    DeclNodeType nodeType;

    std::string name;
    std::vector<std::string> names;
    TypeNode* declType = nullptr;
    ExprNode* initValue = nullptr;

    DeclNode() {
        id = NextNodeId();
    }

public:
    static DeclNode* CreateConstDecl(const std::string& name, TypeNode* type, ExprNode* initValue);;
    static DeclNode* CreateVarDecl(DeclNode* idList, TypeNode* type, ExprNode* initValue);
    static DeclNode* CreateTypeDecl(const std::string& name, TypeNode* type);
};

#endif //PASCAL_COMPILER_DECLNODE_H
