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

ParamNode* ParamNode::CreateParamList(ParamNode* first) {
    ParamNode* result = new ParamNode();
    result->nodeType = ENUM_PARAM_LIST;
    result->paramList.push_back(first);
    return result;
}

ParamNode* ParamNode::CreateEmptyParamList() {
    ParamNode* result = new ParamNode();
    result->nodeType = ENUM_PARAM_LIST;
    return result;
}

ParamNode* ParamNode::AddToParamList(ParamNode* list, ParamNode* param) {
    list->paramList.push_back(param);
    return list;
}
