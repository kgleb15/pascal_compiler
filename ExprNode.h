#ifndef PASCAL_COMPILER_EXPRNODE_H
#define PASCAL_COMPILER_EXPRNODE_H
#include <string>
#include <vector>


enum ExprNodeType {
    ENUM_EXPR_INT,
    ENUM_EXPR_REAL,
    ENUM_EXPR_STRING,
    ENUM_EXPR_NIL,
    ENUM_EXPR_ID,
    ENUM_EXPR_EQUALS,
    ENUM_EXPR_NOT_EQUALS,
    ENUM_EXPR_GREATER,
    ENUM_EXPR_LESS,
    ENUM_EXPR_LESS_OR_EQUALS,
    ENUM_EXPR_GREATER_OR_EQUALS,
    ENUM_EXPR_IS,
    ENUM_EXPR_AS,
    ENUM_EXPR_ADD,
    ENUM_EXPR_SUB,
    ENUM_EXPR_MUL,
    ENUM_EXPR_DIVIDE, // Обычное деление
    ENUM_EXPR_DIV,
    ENUM_EXPR_MOD,
    ENUM_EXPR_OR,
    ENUM_EXPR_AND,
    ENUM_EXPR_NOT,
    ENUM_EXPR_UNARY_MINUS,
    ENUM_EXPR_UNARY_PLUS,
    ENUM_EXPR_MEMBER,
    ENUM_EXPR_INDEX,
    ENUM_EXPR_CALL,
    ENUM_EXPR_METHOD_CALL,
    ENUM_EXPR_INHERITED,
    ENUM_EXPR_SELF,
    ENUM_EXPR_LIST
};

class ExprNode {
protected:
    int id;
    ExprNodeType nodeType;

    long long intValue;
    double realValue;
    std::string stringValue;
    std::string name;

    ExprNode* leftOperand;
    ExprNode* rightOperand;
    ExprNode* operand;
    std::vector<ExprNode*> arguments;
    ExprNode* object; // для полей и методов класса (сам объект)
    ExprNode* arrayBase;  // для массивов

    std::vector<ExprNode*> list_elements; // Для expr_list

public:
    static ExprNode* CreateIntNode(long long intValue);
    static ExprNode* CreateRealNode(double realValue);
    static ExprNode* CreateStringNode(const std::string& stringValue);
    static ExprNode* CreateNilNode();
    static ExprNode* CreateIdNode(const std::string& name);
    static ExprNode* CreateBinaryNode(ExprNodeType nodeType, ExprNode* leftOperand, ExprNode* rightOperand);
    static ExprNode* CreateUnaryNode(ExprNodeType nodeType, ExprNode* operand);
    static ExprNode* CreateCallNode(const std::string& name, std::vector<ExprNode*> arguments);
    static ExprNode* CreateInheritedNode(const std::string& name, std::vector<ExprNode*> arguments);
    static ExprNode* CreateSelfNode();
    static ExprNode* CreateMemberNode(ExprNode* object, const std::string& name);
    static ExprNode* CreateIndexNode(ExprNode* arrayBase, std::vector<ExprNode*> arguments);
    static ExprNode* CreateMethodCallNode(ExprNode* object, const std::string& name, std::vector<ExprNode*> arguments);
    static ExprNode* CreateExprList(ExprNode* firstElement);
    static ExprNode* CreateEmptyExprList();
    static ExprNode* AddToExprList(ExprNode* list, ExprNode* element);
};


#endif //PASCAL_COMPILER_EXPRNODE_H
