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

DeclNode* DeclNode::CreateTypeDecl(const std::string &name, TypeNode *type) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_TYPE;
    result->name = name;
    result->declType = type;
    return result;
}

DeclNode* DeclNode::CreateSection(DeclNodeType sectionType, DeclNode* firstDecl) {
    DeclNode* result = new DeclNode();
    result->nodeType = sectionType;
    result->items.push_back(firstDecl);
    return result;
}

DeclNode* DeclNode::CreateDeclList(DeclNode* first) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_LIST;
    result->items.push_back(first);
    return result;
}

DeclNode* DeclNode::CreateEmptyDeclList() {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_LIST;
    return result;
}

DeclNode* DeclNode::AddToDeclList(DeclNode* declList, DeclNode* newDecl) {
    declList->items.push_back(newDecl);
    return declList;
}

DeclNode* DeclNode::CreateIdList(const std::string& firstName) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_ID_LIST;
    result->names.push_back(firstName);
    return result;
}

DeclNode* DeclNode::AddToIdList(DeclNode* list, const std::string& name) {
    list->names.push_back(name);
    return list;
}
