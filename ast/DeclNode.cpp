#include "DeclNode.h"

DeclNode* DeclNode::CreateConstDecl(const std::string& name, TypeNode* type, ExprNode* initValue) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_CONST;
    result->name = name;
    result->declType = type;
    result->initValue = initValue;
    return result;
}

DeclNode* DeclNode::CreateVarDecl(DeclNode* idList, TypeNode* type, ExprNode* initValue) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_VAR;
    result->names = idList->names;
    result->declType = type;
    result->initValue = initValue;
    return result;
}

DeclNode *DeclNode::CreateTypeDecl(const std::string &name, TypeNode *type) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_TYPE;
    result->name = name;
    result->declType = type;
    return result;
}
