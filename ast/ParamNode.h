#ifndef PASCAL_COMPILER_PARAMNODE_H
#define PASCAL_COMPILER_PARAMNODE_H
#include <string>
#include <vector>

#include "ExprNode.h"
#include "TypeNode.h"


enum ParamNodeType {
    ENUM_PARAM_VALUE,
    ENUM_PARAM_VAR,
    ENUM_PARAM_CONST,
    ENUM_PARAM_LIST, // список параметров функции/процедуры
};

class ParamNode {
protected:
    int id;
    ParamNodeType nodeType;

    std::vector<std::string> names;   // имена параметров одной группы
    TypeNode* paramType = nullptr;
    ExprNode* defaultValue = nullptr; // Значение по умолчанию
    std::vector<ParamNode*> paramList;

    ParamNode() {
        id = NextNodeId();
    }

    static ParamNode* CreateParamGroup(ParamNodeType nodeType, DeclNode* idList, TypeNode* type, ExprNode* defaultValue);
    static ParamNode* CreateParam(ParamNodeType nodeType, const std::string& name, TypeNode* type, ExprNode* defaultValue);

    static ParamNode* CreateParamList(ParamNode* first);
    static ParamNode* CreateEmptyParamList();
    static ParamNode* AddToParamList(ParamNode* list, ParamNode* param);
};

#endif //PASCAL_COMPILER_PARAMNODE_H
