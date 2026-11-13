#ifndef PASCAL_COMPILER_TYPENODE_H
#define PASCAL_COMPILER_TYPENODE_H
#include <string>

#include "ExprNode.h"


enum TypeNodeType {
    ENUM_TYPE_NAME,
    ENUM_TYPE_STRING,
    ENUM_TYPE_RANGE,
    ENUM_TYPE_ENUM,
    ENUM_TYPE_ENUM_ELEMENT,
    ENUM_TYPE_ARRAY
};

class TypeNode {
protected:
    int id;
    TypeNodeType nodeType;

    std::string name;
    ExprNode* rangeLow = nullptr;
    ExprNode* rangeHigh = nullptr;
    std::vector<TypeNode*> enumElements;
    ExprNode* enumElement = nullptr;
    std::vector<TypeNode*> arrayRanges;
    TypeNode* arrayElementType = nullptr;

public:
    static TypeNode* CreateNameType(const std::string& name);
    static TypeNode* CreateStringType();
    static TypeNode* CreateRangeType(ExprNode* rangeLow, ExprNode* rangeHigh);

    static TypeNode* CreateEnumType(TypeNode* firstEnumElement);
    static TypeNode* CreateEnumElement(const std::string& name, ExprNode* enumElement);
    static TypeNode* AddToEnumType(TypeNode* enumType, TypeNode* enumElement);
};


#endif //PASCAL_COMPILER_TYPENODE_H
