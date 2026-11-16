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
    Link(b->id, b->body, "body");
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
        case ENUM_EXPR_NOT:
        case ENUM_EXPR_UNARY_MINUS:
        case ENUM_EXPR_UNARY_PLUS:
            Node(e->id, OperatorText(e->nodeType));
            Link(e->id, e->operand, "operand");
            break;
        case ENUM_EXPR_MEMBER:
            Node(e->id, "member: " + e->name);
            Link(e->id, e->object, "object");
            break;
        case ENUM_EXPR_INDEX:
            Node(e->id, "index");
            Link(e->id, e->arrayBase, "array");
            LinkList(e->id, e->arguments, "index");
            break;
        case ENUM_EXPR_CALL:
            Node(e->id, "call: " + e->name);
            LinkList(e->id, e->arguments, "arg");
            break;
        case ENUM_EXPR_METHOD_CALL:
            Node(e->id, "method call: " + e->name);
            Link(e->id, e->object, "object");
            LinkList(e->id, e->arguments, "arg");
            break;
        case ENUM_EXPR_INHERITED:
            Node(e->id, e->name.empty() ? "inherited" : "inherited: " + e->name);
            LinkList(e->id, e->arguments, "arg");
            break;
        case ENUM_EXPR_ARRAY_INIT:
            Node(e->id, "array init");
            LinkList(e->id, e->arguments, "element");
            break;
        case ENUM_EXPR_LIST:  // служебный узел
            Node(e->id, "[[expr list]]");
            LinkList(e->id, e->list_elements, "item");
            break;
        default:  // бинарные операции
            Node(e->id, OperatorText(e->nodeType));
            Link(e->id, e->leftOperand, "left");
            Link(e->id, e->rightOperand, "right");
            break;
    }
    return e->id;
}

int DotPrinter::PrintNode(StmtNode* s) {
    switch (s->nodeType) {
        case ENUM_STMT_ASSIGN:
            Node(s->id, ":=");
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_ADD_ASSIGN:
            Node(s->id, "+=");
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_SUB_ASSIGN:
            Node(s->id, "-=");
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_MUL_ASSIGN:
            Node(s->id, "*=");
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_DIV_ASSIGN:
            Node(s->id, "/=");
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_CALL:
            Node(s->id, "call statement");
            Link(s->id, s->callExpr, "call");
            return s->id;

        case ENUM_STMT_LIST:
            Node(s->id, "statement list");
            LinkList(s->id, s->stmtList, "stmt");
            return s->id;

        case ENUM_STMT_FOR_TO:
            Node(s->id, "for " + s->loopVariable + " to");
            Link(s->id, s->startExpr, "from");
            Link(s->id, s->endExpr, "to");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_FOR_DOWNTO:
            Node(s->id, "for " + s->loopVariable + " downto");
            Link(s->id, s->startExpr, "from");
            Link(s->id, s->endExpr, "to");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_FOR_IN:
            Node(s->id, "for " + s->loopVariable + " in");
            Link(s->id, s->collection, "collection");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_REPEAT:
            Node(s->id, "repeat");
            Link(s->id, s->loopBody, "body");
            Link(s->id, s->condition, "until");
            return s->id;

        case ENUM_STMT_WHILE:
            Node(s->id, "while");
            Link(s->id, s->condition, "condition");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_IF:
            Node(s->id, "if");
            Link(s->id, s->condition, "condition");
            Link(s->id, s->thenBranch, "then");
            Link(s->id, s->elseBranch, "else");
            return s->id;

        case ENUM_STMT_EMPTY:
            Node(s->id, "empty statement");
            return s->id;
    }
    return s->id;
}

int DotPrinter::PrintNode(TypeNode* t) {
    std::string parent = t->parentName.empty() ? "" : "\nparent: " + t->parentName;
    switch (t->nodeType) {
        case ENUM_TYPE_NAME: Node(t->id, "type: " + t->name); break;
        case ENUM_TYPE_STRING: Node(t->id, "string"); break;
        case ENUM_TYPE_RANGE:
            Node(t->id, "range");
            Link(t->id, t->rangeLow, "low");
            Link(t->id, t->rangeHigh, "high");
            break;
        case ENUM_TYPE_ENUM:
            Node(t->id, "enum");
            LinkList(t->id, t->enumElements, "element");
            break;
        case ENUM_TYPE_ENUM_ELEMENT:
            Node(t->id, "enum element: " + t->name);
            Link(t->id, t->enumElement, "value");
            break;
        case ENUM_TYPE_ARRAY:
            Node(t->id, t->arrayRanges.empty() ? "dynamic array" : "array");
            LinkList(t->id, t->arrayRanges, "range");
            Link(t->id, t->arrayElementType, "element type");
            break;
        case ENUM_TYPE_CLASS:
            Node(t->id, "class" + parent);
            break;
        case ENUM_TYPE_CLASS_FORWARD:
            Node(t->id, "class (forward)" + parent);
            break;
    }
    return t->id;
}

int DotPrinter::PrintNode(ParamNode* p) {
    switch (p->nodeType) {
        case ENUM_PARAM_VALUE:
            Node(p->id, "value param: " + Join(p->names, ", "));
            Link(p->id, p->paramType, "type");
            Link(p->id, p->defaultValue, "default");
            return p->id;
        case ENUM_PARAM_VAR:
            Node(p->id, "var param: " + Join(p->names, ", "));
            Link(p->id, p->paramType, "type");
            Link(p->id, p->defaultValue, "default");
            return p->id;
        case ENUM_PARAM_CONST:
            Node(p->id, "const param: " + Join(p->names, ", "));
            Link(p->id, p->paramType, "type");
            Link(p->id, p->defaultValue, "default");
            return p->id;
        case ENUM_PARAM_LIST:
            Node(p->id, "[[param list]]");
            LinkList(p->id, p->paramList, "param");
            return p->id;
    }
    return p->id;
}

int DotPrinter::PrintNode(SubroutineNode* s) {
    std::string kind;
    switch (s->nodeType) {
        case ENUM_SUB_PROCEDURE: kind = "procedure"; break;
        case ENUM_SUB_FUNCTION: kind = "function"; break;
        case ENUM_SUB_CONSTRUCTOR: kind = "constructor"; break;
        case ENUM_SUB_DESTRUCTOR: kind = "destructor"; break;
    }
    std::string label = kind + ": " + Join(s->nameParts, ".");
    if (!s->modifiers.empty()) {
        label += "\nmodifiers: " + Join(s->modifiers, ", ");
    }
    Node(s->id, label);
    LinkList(s->id, s->params, "param");
    Link(s->id, s->returnType, "returns");
    Link(s->id, s->body, "body");
    return s->id;
}
