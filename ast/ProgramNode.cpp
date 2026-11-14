#include "ProgramNode.h"

ProgramNode* ProgramNode::createProgramNode(const std::string& name, BlockNode* block) {
    ProgramNode* result = new ProgramNode();
    result->name = name;
    result->block = block;
    return result;
}