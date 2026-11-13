#ifndef PASCAL_COMPILER_STMTNODE_H
#define PASCAL_COMPILER_STMTNODE_H
#include "ExprNode.h"
#include "NodeId.h"


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
    ENUM_STMT_IF,
    ENUM_STMT_EMPTY
};

class StmtNode {
protected:
    int id;
    StmtNodeType nodeType;

    ExprNode* target = nullptr; // Левая часть присваивания
    ExprNode* value = nullptr;  // Правая часть присваивания
    ExprNode* callExpr = nullptr;

    std::vector<StmtNode*> stmtList;

    std::string loopVariable; // переменная цикла
    ExprNode* startExpr = nullptr;
    ExprNode* endExpr = nullptr;
    ExprNode* collection = nullptr; // Для for in

    ExprNode* condition = nullptr;
    StmtNode* loopBody = nullptr;
    StmtNode* thenBranch = nullptr;
    StmtNode* elseBranch = nullptr;

    StmtNode() {
        id = NextNodeId();
    }

public:
    static StmtNode* CreateAssignNode(StmtNodeType nodeType, ExprNode* target, ExprNode* value);
    static StmtNode* CreateCallNode(ExprNode* callExpr);
    static StmtNode* CreateStmtList(StmtNode* first);
    static StmtNode* AddToStmtList(StmtNode* list, StmtNode* stmt);
    static StmtNode* CreateForNode(StmtNodeType nodeType, const std::string& loopVariable, ExprNode* startExpr, ExprNode* endExpr, StmtNode* loopBody);
    static StmtNode* CreateForInNode(const std::string& loopVariable, ExprNode* collection, StmtNode* loopBody);
    static StmtNode* CreateRepeatNode(StmtNode* loopBody, ExprNode* condition);
    static StmtNode* CreateWhileNode(ExprNode* condition, StmtNode* loopBody);
    static StmtNode* CreateIfNode(ExprNode* condition, StmtNode* thenBranch, StmtNode* elseBranch);
    static StmtNode* CreateEmptyNode();
};

#endif //PASCAL_COMPILER_STMTNODE_H
