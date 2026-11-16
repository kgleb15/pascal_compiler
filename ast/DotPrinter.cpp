#include "DotPrinter.h"
#include <iomanip>
#include <sstream>

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

std::string DotPrinter::OperatorText(ExprNodeType type) {
    switch (type) {
        case ENUM_EXPR_EQUALS:            return "=";
        case ENUM_EXPR_NOT_EQUALS:        return "<>";
        case ENUM_EXPR_GREATER:           return ">";
        case ENUM_EXPR_LESS:              return "<";
        case ENUM_EXPR_LESS_OR_EQUALS:    return "<=";
        case ENUM_EXPR_GREATER_OR_EQUALS: return ">=";
        case ENUM_EXPR_IS:                return "is";
        case ENUM_EXPR_AS:                return "as";
        case ENUM_EXPR_ADD:               return "+";
        case ENUM_EXPR_SUB:               return "-";
        case ENUM_EXPR_MUL:               return "*";
        case ENUM_EXPR_DIVIDE:            return "/";
        case ENUM_EXPR_DIV:               return "div";
        case ENUM_EXPR_MOD:               return "mod";
        case ENUM_EXPR_OR:                return "or";
        case ENUM_EXPR_AND:               return "and";
        case ENUM_EXPR_NOT:               return "not";
        case ENUM_EXPR_UNARY_MINUS:       return "unary -";
        case ENUM_EXPR_UNARY_PLUS:        return "unary +";
        default:                          return "???";
    }
}

int DotPrinter::PrintNode(ExprNode* e) {
    switch (e->nodeType) {
        case ENUM_EXPR_INT: Node(e->id, "int: " + std::to_string(e->intValue)); break;
        case ENUM_EXPR_REAL: Node(e->id, "real: " + std::to_string(e->realValue)); break;
        case ENUM_EXPR_STRING: Node(e->id, "string: '" + e->stringValue + "'"); break;
        case ENUM_EXPR_NIL: Node(e->id, "nil"); break;
        case ENUM_EXPR_ID: Node(e->id, "id: " + e->name); break;
        case ENUM_EXPR_SELF: Node(e->id, "self"); break;
        default:  // бинарные операции
            Node(e->id, OperatorText(e->nodeType));
            Link(e->id, e->leftOperand, "left");
            Link(e->id, e->rightOperand, "right");
            break;
    }
    return e->id;
}