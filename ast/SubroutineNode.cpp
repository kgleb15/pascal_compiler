#include "SubroutineNode.h"
#include "DeclNode.h"

SubroutineNode* SubroutineNode::CreateSubroutineHeader(SubroutineNodeType nodeType, DeclNode* nameList, ParamNode* paramList, TypeNode* returnType) {
    SubroutineNode* result = new SubroutineNode();
    result->nodeType = nodeType;
    result->nameParts = nameList->getIdNames();
    if (paramList != nullptr) {
        result->params = paramList->getParamList();
    }
    result->returnType = returnType;
    return result;
}

