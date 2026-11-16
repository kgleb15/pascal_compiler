#ifndef PASCAL_COMPILER_DOTPRINTER_H
#define PASCAL_COMPILER_DOTPRINTER_H
#include <ostream>
#include <string>
#include <vector>
#include "ProgramNode.h"
#include "BlockNode.h"
#include "ExprNode.h"
#include "StmtNode.h"

class DotPrinter {
public:
    static void Print(ProgramNode* root, std::ostream& stream);

private:
    static std::ostream* out;

    static void Node(int id, const std::string& label);
    static void Edge(int from, int to, const std::string& label = "");
    static std::string Escape(const std::string& text);
    static std::string Join(const std::vector<std::string>& parts, const std::string& separator);

    template <class T>
    static void Link(int parent, T* child, const std::string& label = "") {
        if (child != nullptr) {
            Edge(parent, PrintNode(child), label);
        }
    }

    template <class T>
    static void LinkList(int parent, const std::vector<T*>& children, const std::string& labelPrefix = "") {
        for (size_t i = 0; i < children.size(); ++i) {
            std::string label = labelPrefix.empty() ? "" : labelPrefix + " " + std::to_string(i + 1);
            Link(parent, children[i], label);
        }
    }

    static int PrintNode(ProgramNode* node);
    static int PrintNode(BlockNode* node);
    static int PrintNode(ExprNode*);
    static int PrintNode(StmtNode*);

    static std::string OperatorText(ExprNodeType type);
};


#endif //PASCAL_COMPILER_DOTPRINTER_H
