#include "ExprNode.h"

#include <utility>

ExprNode* ExprNode::CreateIntNode(long long intValue) {
    ExprNode* result = new ExprNode();
    result->intValue = intValue;
    result->nodeType = ENUM_EXPR_INT;
    return result;
}

ExprNode* ExprNode::CreateRealNode(double realValue) {
    ExprNode* result = new ExprNode();
    result->realValue = realValue;
    result->nodeType = ENUM_EXPR_REAL;
    return result;
}

ExprNode* ExprNode::CreateStringNode(const std::string& stringValue) {
    ExprNode* result = new ExprNode();
    result->stringValue = stringValue;
    result->nodeType = ENUM_EXPR_STRING;
    return result;
}

ExprNode* ExprNode::CreateNilNode() {
    ExprNode* result = new ExprNode();
    result->nodeType = ENUM_EXPR_NIL;
    return result;
}

ExprNode* ExprNode::CreateIdNode(const std::string& name) {
    ExprNode* result = new ExprNode();
    result->name = name;
    result->nodeType = ENUM_EXPR_ID;
    return result;
}

ExprNode* ExprNode::CreateBinaryNode(ExprNodeType nodeType, ExprNode* leftOperand, ExprNode* rightOperand) {
    ExprNode* result = new ExprNode();
    result->nodeType = nodeType;
    result->leftOperand = leftOperand;
    result->rightOperand = rightOperand;
    return result;
}

ExprNode* ExprNode::CreateUnaryNode(ExprNodeType nodeType, ExprNode* operand) {
    ExprNode* result = new ExprNode();
    result->nodeType = nodeType;
    result->operand = operand;
    return result;
}

ExprNode* ExprNode::CreateCallNode(const std::string& name, std::vector<ExprNode*> arguments) {
    ExprNode* result = new ExprNode();
    result->name = name;
    result->nodeType = ENUM_EXPR_CALL;
    result->arguments = std::move(arguments);
    return result;
}

ExprNode* ExprNode::CreateInheritedNode(const std::string& name, std::vector<ExprNode*> arguments) {
    ExprNode* result = new ExprNode();
    result->name = name;
    result->nodeType = ENUM_EXPR_INHERITED;
    result->arguments = std::move(arguments);
    return result;
}

ExprNode* ExprNode::CreateSelfNode() {
    ExprNode* result = new ExprNode();
    result->nodeType = ENUM_EXPR_SELF;
    return result;
}

ExprNode* ExprNode::CreateMemberNode(ExprNode* object, const std::string& name) {
    ExprNode* result = new ExprNode();
    result->object = object;
    result->nodeType = ENUM_EXPR_MEMBER;
    result->name = name;
    return result;
}

ExprNode* ExprNode::CreateIndexNode(ExprNode* arrayBase, std::vector<ExprNode*> arguments) {
    ExprNode* result = new ExprNode();
    result->arrayBase = arrayBase;
    result->nodeType = ENUM_EXPR_INDEX;
    result->arguments = std::move(arguments);
    return result;
}

ExprNode* ExprNode::CreateMethodCallNode(ExprNode* object, const std::string& name, std::vector<ExprNode*> arguments) {
    ExprNode* result = new ExprNode();
    result->object = object;
    result->nodeType = ENUM_EXPR_METHOD_CALL;
    result->name = name;
    result->arguments = std::move(arguments);
    return result;
}

ExprNode* ExprNode::CreateExprList(ExprNode* firstElement) {
    ExprNode* result = new ExprNode();
    result->nodeType = ENUM_EXPR_LIST;
    result->list_elements.push_back(firstElement);
    return result;
}

ExprNode* ExprNode::CreateEmptyExprList() {
    ExprNode* result = new ExprNode();
    result->nodeType = ENUM_EXPR_LIST;
    return result;
}

ExprNode* ExprNode::AddToExprList(ExprNode* list, ExprNode* element) {
    list->list_elements.push_back(element);
    return list;
}

ExprNode* ExprNode::CreateArrayInitNode(ExprNode* first, ExprNode* restList) {
    ExprNode* result = new ExprNode();
    result->nodeType = ENUM_EXPR_ARRAY_INIT;
    result->arguments.push_back(first);
    for (ExprNode* element : restList->list_elements) {
        result->arguments.push_back(element);
    }
    return result;
}
