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
