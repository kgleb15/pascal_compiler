#ifndef PASCAL_COMPILER_DOTPRINTER_H
#define PASCAL_COMPILER_DOTPRINTER_H
#include <ostream>
#include <string>
#include <vector>
#include "ProgramNode.h"

class DotPrinter {
public:
    static void Print(ProgramNode* root, std::ostream& stream);

private:
    static std::ostream* out;

    static void Node(int id, const std::string& label);
    static void Edge(int from, int to, const std::string& label = "");
    static std::string Escape(const std::string& text);
    static std::string Join(const std::vector<std::string>& parts, const std::string& separator);
};


#endif //PASCAL_COMPILER_DOTPRINTER_H
