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
    ENUM_DECL_METHOD,
    ENUM_DECL_MEMBER_LIST,
    ENUM_DECL_QUALIFIED_NAME,
    ENUM_DECL_MODIFIER_LIST,
};

class SubroutineNode;
class BlockNode;

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
    SubroutineNode* subroutine = nullptr; // подпрограмма или метод

    DeclNode() {
        id = NextNodeId();
    }

public:
    static DeclNode* CreateConstDecl(const std::string& name, TypeNode* type, ExprNode* initValue);
    static DeclNode* CreateVarDecl(DeclNode* idList, TypeNode* type, ExprNode* initValue);
    static DeclNode* CreateTypeDecl(const std::string& name, TypeNode* type);

    static DeclNode* CreateSection(DeclNodeType sectionType, DeclNode* firstDecl);
    static DeclNode* AddToSection(DeclNode* section, DeclNode* newDecl);

    static DeclNode* CreateDeclList(DeclNode* first);
    static DeclNode* CreateEmptyDeclList();
    static DeclNode* AddToDeclList(DeclNode* declList, DeclNode* newDecl);

    static DeclNode* CreateIdList(const std::string& firstName);
    static DeclNode* CreateEmptyIdList();
    static DeclNode* AddToIdList(DeclNode* list, const std::string& name);

    static DeclNode* CreateFieldList(DeclNode* idList, TypeNode* type);
    static DeclNode* AddToFieldList(DeclNode* list, DeclNode* idList, TypeNode* type);

    static DeclNode* CreateSubroutineDef(SubroutineNode* header, DeclNode* modifiers, BlockNode* body);
    static DeclNode* CreateMethodDecl(SubroutineNode* header, DeclNode* modifiers);
    static DeclNode* MergeDeclLists(DeclNode* first, DeclNode* second);
    
    static DeclNode* CreateMemberList(DeclNode* first);
    static DeclNode* AddToMemberList(DeclNode* list, DeclNode* member);

    static DeclNode* CreateQualifiedName(const std::string& firstPart);
    static DeclNode* AddToQualifiedName(DeclNode* name, const std::string& part);

    static DeclNode* CreateModifierList(const std::string& first);
    static DeclNode* CreateEmptyModifierList();
    static DeclNode* AddToModifierList(DeclNode* list, const std::string& modifier);

    std::vector<DeclNode*>& getItems() {
        return items;
    }

    std::vector<std::string>& getIdNames() {
        return idNames;
    }
};

#endif //PASCAL_COMPILER_DECLNODE_H
