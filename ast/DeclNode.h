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
    ENUM_DECL_LIST,         // Общий список объявлений
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
    friend class DotPrinter;
protected:
    int id;
    DeclNodeType nodeType;

    std::string name;                       // Имя объявляемой константы или типа
    std::vector<std::string> varNames;      // Имена var
    std::vector<std::string> fieldNames;    // Имена полей класса
    std::vector<std::string> idNames; // Имена служебных узлов-списков (список id, части имени, список модификаторов)
    TypeNode* declType = nullptr;           // Тип константы, переменной, поля
    ExprNode* initValue = nullptr;          // Начальное значение
    std::vector<DeclNode*> items;           // элементы секций (const, var, type) и для общего списка объявлений
    SubroutineNode* subroutine = nullptr;   // подпрограмма или метод

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
    static DeclNode* AddToIdList(DeclNode* list, const std::string& name);

    static DeclNode* CreateFieldList(DeclNode* idList, TypeNode* type);
    static DeclNode* AddToFieldList(DeclNode* list, DeclNode* idList, TypeNode* type);

    static DeclNode* CreateSubroutineDef(SubroutineNode* header, DeclNode* modifiers, BlockNode* body);
    static DeclNode* CreateMethodDecl(SubroutineNode* header, DeclNode* modifiers);

    static DeclNode* MergeFieldsAndMembers(DeclNode* fields, DeclNode* members);

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
