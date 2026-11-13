#ifndef PASCAL_COMPILER_STMTNODE_H
#define PASCAL_COMPILER_STMTNODE_H
#include "ExprNode.h"


enum StmtNodeType {
    ENUM_STMT_ASSIGN,
    ENUM_STMT_ADD_ASSIGN,
    ENUM_STMT_SUB_ASSIGN,
    ENUM_STMT_MUL_ASSIGN,
    ENUM_STMT_DIV_ASSIGN,
    ENUM_STMT_CALL,         // вызовы процедуры, метода, inherited
    ENUM_STMT_LIST,
    ENUM_STMT_FOR_TO,
    ENUM_STMT_FOR_DOWNTO,
    ENUM_STMT_FOR_IN,
    ENUM_STMT_REPEAT,
    ENUM_STMT_WHILE,
    ENUM_STMT_IF
};

class StmtNode {
protected:
    int id;
    StmtNodeType nodeType;

    ExprNode* target; // Левая часть присваивания
    ExprNode* value;  // Правая часть присваивания
    ExprNode* callExpr;

    std::vector<StmtNode*> stmtList;

    std::string loopVariable; // переменная цикла
    ExprNode* startExpr;
    ExprNode* endExpr;
    ExprNode* collection; // Для for in

    ExprNode* condition;
    StmtNode* loopBody;
    StmtNode* thenBranch;
    StmtNode* elseBranch;

public:
    static StmtNode* CreateAssignNode(StmtNodeType nodeType, ExprNode* target, ExprNode* value);
    static StmtNode* CreateCallNode(ExprNode* callExpr);
    static StmtNode* CreateStmtList(StmtNode* first);
    static StmtNode* AddToStmtList(StmtNode* list, StmtNode* stmt);
    static StmtNode* CreateForNode(StmtNodeType nodeType, const std::string& loopVariable, ExprNode* startExpr, ExprNode* endExpr, ExprNode* loopBody);
    static StmtNode* CreateForInNode(StmtNodeType nodeType, const std::string& loopVariable, ExprNode* collection, ExprNode* loopBody);
    static StmtNode* CreateRepeatNode(StmtNode* loopBody, StmtNode* condition);
    static StmtNode* CreateWhileNode(ExprNode* condition, StmtNode* loopBody);
    static StmtNode* CreateIfNode(ExprNode* condition, StmtNode* thenBranch, StmtNode* elseBranch);
};

#endif //PASCAL_COMPILER_STMTNODE_H
