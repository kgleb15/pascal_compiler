#include "DotPrinter.h"
#include <iomanip>
#include <sstream>

std::ostream* DotPrinter::out = nullptr;

const char* const DotPrinter::COLOR_WHITE = "white";
const char* const DotPrinter::COLOR_EXPR  = "#FFF3B0";
const char* const DotPrinter::COLOR_STMT  = "#CFE8FF";
const char* const DotPrinter::COLOR_TYPE  = "#D5F0D5";
const char* const DotPrinter::COLOR_DECL  = "#FFE0B8";
const char* const DotPrinter::COLOR_SUB   = "#E3D7F3";
const char* const DotPrinter::SHAPE_BOX   = "box";
const char* const DotPrinter::SHAPE_ELLIPSE = "ellipse";

void DotPrinter::Print(ProgramNode* root, std::ostream& stream) {
    out = &stream;
    *out << "digraph AST {\n";
    *out << "    node [shape=box];\n";
    if (root != nullptr) PrintNode(root);
    *out << "}\n";
}

void DotPrinter::Node(int id, const std::string& label, const char* shape, const char* fillColor) {
    *out << "    n" << id << " [label=\"" << Escape(label) << "\""
     << ", shape=" << shape << ", style=filled, fillcolor=\"" << fillColor << "\"];\n";
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
    Link(b->id, b->declarations, "declarations");
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
        case ENUM_EXPR_INT: Node(e->id, "int: " + std::to_string(e->intValue), SHAPE_ELLIPSE, COLOR_WHITE); break;
        case ENUM_EXPR_REAL: Node(e->id, "real: " + std::to_string(e->realValue), SHAPE_ELLIPSE, COLOR_WHITE); break;
        case ENUM_EXPR_STRING: Node(e->id, "string: '" + e->stringValue + "'", SHAPE_ELLIPSE, COLOR_WHITE); break;
        case ENUM_EXPR_NIL: Node(e->id, "nil", SHAPE_ELLIPSE, COLOR_WHITE); break;
        case ENUM_EXPR_ID: Node(e->id, "id: " + e->name, SHAPE_ELLIPSE, COLOR_WHITE); break;
        case ENUM_EXPR_SELF: Node(e->id, "self", SHAPE_ELLIPSE, COLOR_WHITE); break;
        case ENUM_EXPR_NOT:
        case ENUM_EXPR_UNARY_MINUS:
        case ENUM_EXPR_UNARY_PLUS:
            Node(e->id, OperatorText(e->nodeType), SHAPE_BOX, COLOR_EXPR);
            Link(e->id, e->operand, "operand");
            break;
        case ENUM_EXPR_MEMBER:
            Node(e->id, "member: " + e->name, SHAPE_BOX, COLOR_EXPR);
            Link(e->id, e->object, "object");
            break;
        case ENUM_EXPR_INDEX:
            Node(e->id, "index", SHAPE_BOX, COLOR_EXPR);
            Link(e->id, e->arrayBase, "array");
            LinkList(e->id, e->arguments, "index");
            break;
        case ENUM_EXPR_CALL:
            Node(e->id, "call: " + e->name, SHAPE_BOX, COLOR_EXPR);
            LinkList(e->id, e->arguments, "arg");
            break;
        case ENUM_EXPR_METHOD_CALL:
            Node(e->id, "method call: " + e->name, SHAPE_BOX, COLOR_EXPR);
            Link(e->id, e->object, "object");
            LinkList(e->id, e->arguments, "arg");
            break;
        case ENUM_EXPR_INHERITED:
            Node(e->id, e->name.empty() ? "inherited" : "inherited: " + e->name, SHAPE_BOX, COLOR_EXPR);
            LinkList(e->id, e->arguments, "arg");
            break;
        case ENUM_EXPR_ARRAY_INIT:
            Node(e->id, "array init", SHAPE_BOX, COLOR_EXPR);
            LinkList(e->id, e->arguments, "element");
            break;
        case ENUM_EXPR_LIST:  // служебный узел
            Node(e->id, "[[expr list]]", SHAPE_BOX, COLOR_EXPR);
            LinkList(e->id, e->list_elements, "item");
            break;
        default:  // бинарные операции
            Node(e->id, OperatorText(e->nodeType), SHAPE_BOX, COLOR_EXPR);
            Link(e->id, e->leftOperand, "left");
            Link(e->id, e->rightOperand, "right");
            break;
    }
    return e->id;
}

int DotPrinter::PrintNode(StmtNode* s) {
    switch (s->nodeType) {
        case ENUM_STMT_ASSIGN:
            Node(s->id, ":=", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_ADD_ASSIGN:
            Node(s->id, "+=", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_SUB_ASSIGN:
            Node(s->id, "-=", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_MUL_ASSIGN:
            Node(s->id, "*=", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_DIV_ASSIGN:
            Node(s->id, "/=", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->target, "target");
            Link(s->id, s->value, "value");
            return s->id;

        case ENUM_STMT_CALL:
            Node(s->id, "call statement", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->callExpr, "call");
            return s->id;

        case ENUM_STMT_LIST:
            Node(s->id, "statement list", SHAPE_BOX, COLOR_STMT);
            LinkList(s->id, s->stmtList, "stmt");
            return s->id;

        case ENUM_STMT_FOR_TO:
            Node(s->id, "for " + s->loopVariable + " to", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->startExpr, "from");
            Link(s->id, s->endExpr, "to");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_FOR_DOWNTO:
            Node(s->id, "for " + s->loopVariable + " downto", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->startExpr, "from");
            Link(s->id, s->endExpr, "to");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_FOR_IN:
            Node(s->id, "for " + s->loopVariable + " in", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->collection, "collection");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_REPEAT:
            Node(s->id, "repeat", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->loopBody, "body");
            Link(s->id, s->condition, "until");
            return s->id;

        case ENUM_STMT_WHILE:
            Node(s->id, "while", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->condition, "condition");
            Link(s->id, s->loopBody, "body");
            return s->id;

        case ENUM_STMT_IF:
            Node(s->id, "if", SHAPE_BOX, COLOR_STMT);
            Link(s->id, s->condition, "condition");
            Link(s->id, s->thenBranch, "then");
            Link(s->id, s->elseBranch, "else");
            return s->id;

        case ENUM_STMT_EMPTY:
            Node(s->id, "empty statement", SHAPE_BOX, COLOR_STMT);
            return s->id;
    }
    return s->id;
}

int DotPrinter::PrintNode(TypeNode* t) {
    std::string parent = t->parentName.empty() ? "" : "\nparent: " + t->parentName;
    switch (t->nodeType) {
        case ENUM_TYPE_NAME: Node(t->id, "type: " + t->name, SHAPE_BOX, COLOR_TYPE); break;
        case ENUM_TYPE_STRING: Node(t->id, "string", SHAPE_BOX, COLOR_TYPE); break;
        case ENUM_TYPE_RANGE:
            Node(t->id, "range", SHAPE_BOX, COLOR_TYPE);
            Link(t->id, t->rangeLow, "low");
            Link(t->id, t->rangeHigh, "high");
            break;
        case ENUM_TYPE_ENUM:
            Node(t->id, "enum", SHAPE_BOX, COLOR_TYPE);
            LinkList(t->id, t->enumElements, "element");
            break;
        case ENUM_TYPE_ENUM_ELEMENT:
            Node(t->id, "enum element: " + t->name, SHAPE_BOX, COLOR_TYPE);
            Link(t->id, t->enumElement, "value");
            break;
        case ENUM_TYPE_ARRAY:
            Node(t->id, t->arrayRanges.empty() ? "dynamic array" : "array", SHAPE_BOX, COLOR_TYPE);
            LinkList(t->id, t->arrayRanges, "range");
            Link(t->id, t->arrayElementType, "element type");
            break;
        case ENUM_TYPE_CLASS:
            Node(t->id, "class" + parent, SHAPE_BOX, COLOR_TYPE);
            LinkList(t->id, t->members, "member");
            break;
        case ENUM_TYPE_CLASS_FORWARD:
            Node(t->id, "class (forward)" + parent, SHAPE_BOX, COLOR_TYPE);
            break;
    }
    return t->id;
}

int DotPrinter::PrintNode(ParamNode* p) {
    switch (p->nodeType) {
        case ENUM_PARAM_VALUE:
            Node(p->id, "value param: " + Join(p->names, ", "), SHAPE_BOX, COLOR_SUB);
            Link(p->id, p->paramType, "type");
            Link(p->id, p->defaultValue, "default");
            return p->id;
        case ENUM_PARAM_VAR:
            Node(p->id, "var param: " + Join(p->names, ", "), SHAPE_BOX, COLOR_SUB);
            Link(p->id, p->paramType, "type");
            Link(p->id, p->defaultValue, "default");
            return p->id;
        case ENUM_PARAM_CONST:
            Node(p->id, "const param: " + Join(p->names, ", "), SHAPE_BOX, COLOR_SUB);
            Link(p->id, p->paramType, "type");
            Link(p->id, p->defaultValue, "default");
            return p->id;
        case ENUM_PARAM_LIST:
            Node(p->id, "[[param list]]", SHAPE_BOX, COLOR_SUB);
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
    Node(s->id, label, SHAPE_BOX, COLOR_SUB);
    LinkList(s->id, s->params, "param");
    Link(s->id, s->returnType, "returns");
    Link(s->id, s->body, "body");
    return s->id;
}

int DotPrinter::PrintNode(DeclNode* d) {
    switch (d->nodeType) {
        case ENUM_DECL_CONST:
            Node(d->id, "const: " + d->name, SHAPE_BOX, COLOR_DECL);
            Link(d->id, d->declType, "type");
            Link(d->id, d->initValue, "value");
            break;
        case ENUM_DECL_VAR:
            Node(d->id, "var: " + Join(d->varNames, ", "), SHAPE_BOX, COLOR_DECL);
            Link(d->id, d->declType, "type");
            Link(d->id, d->initValue, "init");
            break;
        case ENUM_DECL_TYPE:
            Node(d->id, "type: " + d->name, SHAPE_BOX, COLOR_DECL);
            Link(d->id, d->declType, "definition");
            break;
        case ENUM_DECL_FIELD: {
            const std::vector<std::string>& names = d->fieldNames.empty() ? d->varNames : d->fieldNames;
            Node(d->id, "field: " + Join(names, ", "), SHAPE_BOX, COLOR_DECL);
            Link(d->id, d->declType, "type");
            break;
        }
        case ENUM_DECL_CONST_SECTION: Node(d->id, "const section", SHAPE_BOX, COLOR_DECL); LinkList(d->id, d->items); break;
        case ENUM_DECL_VAR_SECTION: Node(d->id, "var section", SHAPE_BOX, COLOR_DECL); LinkList(d->id, d->items); break;
        case ENUM_DECL_TYPE_SECTION: Node(d->id, "type section", SHAPE_BOX, COLOR_DECL); LinkList(d->id, d->items); break;
        case ENUM_DECL_LIST: Node(d->id, "declarations", SHAPE_BOX, COLOR_DECL); LinkList(d->id, d->items); break;
        case ENUM_DECL_SUBROUTINE:
            Node(d->id, d->subroutine != nullptr && d->subroutine->body == nullptr ? "subroutine (forward)" : "subroutine", SHAPE_BOX, COLOR_DECL);
            Link(d->id, d->subroutine);
            break;
        case ENUM_DECL_METHOD:
            Node(d->id, "method declaration", SHAPE_BOX, COLOR_DECL);
            Link(d->id, d->subroutine);
            break;
        default:
            Node(d->id, "[[decl list]]", SHAPE_BOX, COLOR_DECL);
            LinkList(d->id, d->items);
            break;
    }
    return d->id;
}
