#ifndef PASCAL_COMPILER_DECLNODE_H
#define PASCAL_COMPILER_DECLNODE_H
#include <string>

#include "TypeNode.h"


enum DeclNodeType {
    ENUM_DECL_CONST,
    ENUM_DECL_VAR,
    ENUM_DECL_TYPE,
    ENUM_DECL_CONST_SECTION,
    ENUM_DECL_VAR_SECTION,
    ENUM_DECL_TYPE_SECTION,
    ENUM_DECL_LIST,
    ENUM_DECL_ID_LIST,
    ENUM_DECL_FIELD,
    ENUM_DECL_SUBROUTINE,
    ENUM_DECL_METHOD
};

class DeclNode {
protected:
    int id;
    DeclNodeType nodeType;

    std::string name;
    std::vector<std::string> varNames;
    std::vector<std::string> fieldNames;
    std::vector<std::string> idNames;
    TypeNode* declType = nullptr;
    ExprNode* initValue = nullptr;
    std::vector<DeclNode*> items; // элементы секций и для списка блоков объявлений

    DeclNode() {
        id = NextNodeId();
    }

public:
    static DeclNode* CreateConstDecl(const std::string& name, TypeNode* type, ExprNode* initValue);;
    static DeclNode* CreateVarDecl(DeclNode* idList, TypeNode* type, ExprNode* initValue);
    static DeclNode* CreateTypeDecl(const std::string& name, TypeNode* type);

    static DeclNode* CreateSection(DeclNodeType sectionType, DeclNode* firstDecl);
    static DeclNode* CreateDeclList(DeclNode* first);
    static DeclNode* CreateEmptyDeclList();
    static DeclNode* AddToDeclList(DeclNode* declList, DeclNode* newDecl);

    static DeclNode* CreateIdList(const std::string& firstName);
    static DeclNode* CreateEmptyIdList();
    static DeclNode* AddToIdList(DeclNode* list, const std::string& name);

    static DeclNode* CreateFieldList(DeclNode* idList, TypeNode* type);
    static DeclNode* AddToFieldList(DeclNode* list, DeclNode* idList, TypeNode* type);
    static DeclNode* MergeDeclLists(DeclNode* first, DeclNode* second);
};

#endif //PASCAL_COMPILER_DECLNODE_H
