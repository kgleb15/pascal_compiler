#include "ParamNode.h"

ParamNode* ParamNode::CreateParamGroup(ParamNodeType nodeType, DeclNode* idList, TypeNode* type, ExprNode* defaultValue) {
    ParamNode* result = new ParamNode();
    result->nodeType = nodeType;
    result->names = idList->getIdNames();
    result->paramType = type;
    result->defaultValue = defaultValue;
    return result;
}

ParamNode* ParamNode::CreateParam(ParamNodeType nodeType, const std::string& name, TypeNode* type, ExprNode* defaultValue) {
    ParamNode* result = new ParamNode();
    result->nodeType = nodeType;
    result->names.push_back(name);
    result->paramType = type;
    result->defaultValue = defaultValue;
    return result;
}

