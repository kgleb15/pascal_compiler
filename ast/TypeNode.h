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
    ENUM_TYPE_ARRAY,
    ENUM_TYPE_CLASS,
    ENUM_TYPE_CLASS_FORWARD
};

class DeclNode;

class TypeNode {
    friend class DotPrinter;
protected:
    int id;
    TypeNodeType nodeType;

    std::string name; // Название типа (integer, real...) или имя элемента перечисления
    ExprNode* rangeLow = nullptr;          // Нижняя граница диапазона
    ExprNode* rangeHigh = nullptr;         // Верхняя граница диапазона
    std::vector<TypeNode*> enumElements;   // Элементы перечисления
    ExprNode* enumElementNumber = nullptr; // Явно заданный порядковый номер элемента перечисления
    std::vector<TypeNode*> arrayRanges;    // Диапазоны индексов массива (пусто для динамического)
    TypeNode* arrayElementType = nullptr;  // Тип элемента массива

    std::string parentName;          // Имя родительского класса
    std::vector<DeclNode*> members;  // Члены класса (поля, методы и вложенные секции)

    TypeNode() {
        id = NextNodeId();
    }

public:
    static TypeNode* CreateNameType(const std::string& name);
    static TypeNode* CreateStringType();
    static TypeNode* CreateRangeType(ExprNode* rangeLow, ExprNode* rangeHigh);

    static TypeNode* CreateEnumType(TypeNode* firstEnumElement);
    static TypeNode* CreateEnumElement(const std::string& name, ExprNode* enumElement);
    static TypeNode* AddToEnumType(TypeNode* enumType, TypeNode* enumElementNumber);

    static TypeNode* CreateStaticArrayType(ExprNode* lowRange, ExprNode* highRange);
    static TypeNode* AddArrayRange(TypeNode* arrayType, ExprNode* rangeLow, ExprNode* rangeHigh);
    static TypeNode* CreateDynamicArrayType();
    static TypeNode* AddArrayBase(TypeNode* outerArray, TypeNode* innerArray);
    static TypeNode* SetArrayElementType(TypeNode* array, TypeNode* elementType);

    static TypeNode* CreateClassType(const std::string& parentName, DeclNode* members);
    static TypeNode* CreateForwardClassType(const std::string& parentName);
};


#endif //PASCAL_COMPILER_TYPENODE_H
