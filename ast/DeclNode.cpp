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
    result->varNames = idList->idNames;
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
    result->idNames.push_back(firstName);
    return result;
}

DeclNode* DeclNode::AddToIdList(DeclNode* list, const std::string& name) {
    list->idNames.push_back(name);
    return list;
}

DeclNode* DeclNode::CreateEmptyIdList() {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_ID_LIST;
    return result;
}

DeclNode* DeclNode::CreateFieldList(DeclNode* idList, TypeNode* type) {
    DeclNode* result = new DeclNode();
    result->nodeType = ENUM_DECL_FIELD;
    result->varNames = idList->idNames;
    result->declType = type;
    return CreateDeclList(result);
}

DeclNode* DeclNode::AddToFieldList(DeclNode* list, DeclNode* idList, TypeNode* type) {
    DeclNode* newField = new DeclNode();
    newField->nodeType = ENUM_DECL_FIELD;
    newField->varNames = idList->idNames;
    newField->declType = type;
    list->items.push_back(newField);
    return list;
}

DeclNode* DeclNode::MergeDeclLists(DeclNode* first, DeclNode* second) {
    for (DeclNode* item : second->items) {
        first->items.push_back(item);
    }
    return first;
}

