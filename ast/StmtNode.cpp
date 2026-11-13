#include "StmtNode.h"

StmtNode* StmtNode::CreateAssignNode(StmtNodeType nodeType, ExprNode* target, ExprNode* value) {
    StmtNode* result = new StmtNode();
    result->nodeType = nodeType;
    result->target = target;
    result->value = value;
    return result;
}

StmtNode* StmtNode::CreateCallNode(ExprNode* callExpr) {
    StmtNode* result = new StmtNode();
    result->nodeType = ENUM_STMT_CALL;
    result->callExpr = callExpr;
    return result;
}

StmtNode* StmtNode::CreateStmtList(StmtNode* first) {
    StmtNode* result = new StmtNode();
    result->nodeType = ENUM_STMT_LIST;
    result->stmtList.push_back(first);
    return result;
}

StmtNode* StmtNode::AddToStmtList(StmtNode* list, StmtNode* stmt) {
    list->stmtList.push_back(stmt);
    return list;
}

StmtNode* StmtNode::CreateForNode(StmtNodeType nodeType, const std::string& loopVariable, ExprNode* startExpr, ExprNode* endExpr, StmtNode* loopBody) {
    StmtNode* result = new StmtNode();
    result->nodeType = nodeType;
    result->loopVariable = loopVariable;
    result->startExpr = startExpr;
    result->endExpr = endExpr;
    result->loopBody = loopBody;
    return result;
}

StmtNode* StmtNode::CreateForInNode(const std::string& loopVariable, ExprNode* collection, StmtNode* loopBody) {
    StmtNode* result = new StmtNode();
    result->nodeType = ENUM_STMT_FOR_IN;
    result->loopVariable = loopVariable;
    result->collection = collection;
    result->loopBody = loopBody;
    return result;
}

StmtNode* StmtNode::CreateRepeatNode(StmtNode* loopBody, ExprNode* condition) {
    StmtNode* result = new StmtNode();
    result->nodeType = ENUM_STMT_REPEAT;
    result->loopBody = loopBody;
    result->condition = condition;
    return result;
}

StmtNode* StmtNode::CreateWhileNode(ExprNode* condition, StmtNode* loopBody) {
    StmtNode* result = new StmtNode();
    result->nodeType = ENUM_STMT_WHILE;
    result->condition = condition;
    result->loopBody = loopBody;
    return result;
}

StmtNode* StmtNode::CreateIfNode(ExprNode* condition, StmtNode* thenBranch, StmtNode* elseBranch) {
    StmtNode* result = new StmtNode();
    result->nodeType = ENUM_STMT_IF;
    result->condition = condition;
    result->thenBranch = thenBranch;
    result->elseBranch = elseBranch;
    return result;
}


