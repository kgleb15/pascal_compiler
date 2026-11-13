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
};


#endif //PASCAL_COMPILER_TYPENODE_H
