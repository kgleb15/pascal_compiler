#include "DotPrinter.h"

std::ostream* DotPrinter::out = nullptr;

void DotPrinter::Print(ProgramNode* root, std::ostream& stream) {
    out = &stream;
    *out << "digraph AST {\n";
    *out << "    node [shape=box, fontname=\"Helvetica\"];\n";
    if (root != nullptr) PrintNode(root);
    *out << "}\n";
}

void DotPrinter::Node(int id, const std::string& label) {
    *out << "    n" << id << " [label=\"" << Escape(label) << "\"];\n";
}

void DotPrinter::Edge(int from, int to, const std::string& label) {
    *out << "    n" << from << " -> n" << to;
    if (!label.empty()) {
        *out << " [label=\"" << Escape(label) << "\"]";
    }
    *out << ";\n";
}

std::string DotPrinter::Escape(const std::string& text) {
    std::string result;
    for (char c : text) {
        if (c == '"' || c == '\\') {
            result += '\\'; result += c;
        }
        else if (c == '\n') {
            result += "\\n";
        }
        else if (c != '\r') {
            result += c;
        }
    }
    return result;
}

std::string DotPrinter::Join(const std::vector<std::string>& parts, const std::string& separator) {
    std::string result;
    for (int i = 0; i < parts.size(); ++i) {
        if (i > 0) {
            result += separator;
        }
        result += parts[i];
    }
    return result;
}

int DotPrinter::PrintNode(BlockNode* b) {
    Node(b->id, "block");
    return b->id;
}

int DotPrinter::PrintNode(ProgramNode* p) {
    Node(p->id, "program: " + p->name);
    Link(p->id, p->block, "block");
    return p->id;
}