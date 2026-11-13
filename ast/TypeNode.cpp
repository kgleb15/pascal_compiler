#include "TypeNode.h"

TypeNode* TypeNode::CreateNameType(const std::string& name) {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_NAME;
    result->name = name;
    return result;
}

TypeNode *TypeNode::CreateStringType() {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_STRING;
    return result;
}

TypeNode* TypeNode::CreateRangeType(ExprNode* rangeLow, ExprNode* rangeHigh) {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_RANGE;
    result->rangeLow = rangeLow;
    result->rangeHigh = rangeHigh;
    return result;
}

TypeNode* TypeNode::CreateEnumType(TypeNode* firstEnumElement) {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_ENUM;
    result->enumElements.push_back(firstEnumElement);
    return result;
}

TypeNode* TypeNode::CreateEnumElement(const std::string& name, ExprNode* enumElement) {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_ENUM_ELEMENT;
    result->name = name;
    result->enumElement = enumElement;
    return result;
}

TypeNode* TypeNode::AddToEnumType(TypeNode* enumType, TypeNode* enumElement) {
    enumType->enumElements.push_back(enumElement);
    return enumType;
}

TypeNode* TypeNode::CreateStaticArrayType(ExprNode* rangeLow, ExprNode* rangeHigh) {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_ARRAY;
    result->arrayRanges.push_back(CreateRangeType(rangeLow, rangeHigh));
    return result;
}

TypeNode* TypeNode::AddArrayRange(TypeNode* arrayType, ExprNode* rangeLow, ExprNode* rangeHigh) {
    arrayType->arrayRanges.push_back(CreateRangeType(rangeLow, rangeHigh));
    return arrayType;
}

TypeNode* TypeNode::CreateDynamicArrayType() {
    TypeNode* result = new TypeNode();
    result->nodeType = ENUM_TYPE_ARRAY;
    return result;
}

TypeNode* TypeNode::AddArrayBase(TypeNode* outerArray, TypeNode* innerArray) {
    TypeNode* lastArrayBase = outerArray;
    while (lastArrayBase->arrayElementType != nullptr) {
        lastArrayBase = lastArrayBase->arrayElementType;
    }
    lastArrayBase->arrayElementType = innerArray;
    return outerArray;
}

TypeNode* TypeNode::SetArrayElementType(TypeNode* array, TypeNode* elementType) {
    TypeNode* lastArrayBase = array;
    while (lastArrayBase->arrayElementType != nullptr) {
        lastArrayBase = lastArrayBase->arrayElementType;
    }
    lastArrayBase->arrayElementType = elementType;
    return array;
}
