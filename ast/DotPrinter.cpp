#include "DotPrinter.h"

std::ostream* DotPrinter::out = nullptr;

void DotPrinter::Print(ProgramNode* root, std::ostream& stream) {
    out = &stream;
    *out << "digraph AST {\n";
    *out << "    node [shape=box, fontname=\"Helvetica\"];\n";
    *out << "}\n";
}
