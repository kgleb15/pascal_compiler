#include "SubroutineNode.h"

SubroutineNode* SubroutineNode::createSubroutineHeader(SubroutineNodeType nodeType, DeclNode* nameList, ParamNode* paramList, TypeNode* returnType) {
    SubroutineNode* result = new SubroutineNode();
    result->nodeType = nodeType;
    result->nameParts = nameList->getIdNames();
    result->params = paramList->getParamList();
    result->returnType = returnType;
    return result;
}

