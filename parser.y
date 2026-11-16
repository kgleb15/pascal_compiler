%define parse.trace

%code requires {
    #include <string>
    #include "ast/ExprNode.h"
    #include "ast/StmtNode.h"
    #include "ast/TypeNode.h"
    #include "ast/DeclNode.h"
    #include "ast/ParamNode.h"
    #include "ast/SubroutineNode.h"
    #include "ast/BlockNode.h"
    #include "ast/ProgramNode.h"
}

%{
    #include <cstdio>

    extern int yylex(void);

    void yyerror(const char *msg) {
        fprintf(stderr, "%s\n", msg);
    }
%}

%code {
    ProgramNode* programRoot = nullptr;
}

%union {
    long long       LiterIntUnion;
    double          LiterRealUnion;
    std::string*    LiterStrUnion;
    std::string*    IdUnion;
    ExprNode*       ExprUnion;
    StmtNode*       StmtUnion;
    TypeNode*       TypeUnion;
    DeclNode*       DeclarationUnion;
    BlockNode*      BlockUnion;
    ParamNode*      ParamUnion;
    ProgramNode*    ProgramUnion;
    SubroutineNode* SubroutineUnion;
}

%type <ExprUnion> expr expr_list expr_list_e range_bound init_value
%type <StmtUnion> stmt for_stmt repeat_stmt while_stmt if_stmt compound_statement stmt_list
%type <TypeUnion> type not_array_type ordinal_type enum_type enum_element enum_element_list array_type array_bases array_base range_list type_id parameter_type class_type
%type <DeclarationUnion> declaration declaration_part declaration_part_e constant_declaration constant_declaration_list
%type <DeclarationUnion> type_declaration_list type_declaration variable_declaration_list variable_declaration id_list
%type <ProgramUnion> program
%type <BlockUnion> block subroutine_block
%type <ParamUnion> parameter_declarations parameter_declaration value_parameter var_parameter const_parameter formal_parameter_list_e
%type <SubroutineUnion> subroutine_header
%type <DeclarationUnion> subroutine_definition subroutine_name big_id_list modifiers_list modifiers_list_e component_list field_declaration_list member_list member

%printer {
    fprintf(yyo, "%lld", $$);
} <f_liter_int>

%printer {
    fprintf(yyo, "%g", $$);
} <f_liter_float>

%printer {
    fprintf(yyo, "\"%s\"", $$->c_str());
} <f_liter_str>

%printer {
    fprintf(yyo, "\"%s\"", $$->c_str());
} <f_id>

	/* Подробные сообщения об ошибках: bison перечисляет ожидаемые токены */
%define parse.error verbose

    /* Стартовый символ */
%start program

	/* Терминальные символы */
%token ARRAY
%token BEGIN_KW
%token CASE
%token CONST
%token CONSTRUCTOR
%token DESTRUCTOR
%token DO
%token DOWNTO
%token ELSE
%token END
%token FOR
%token FUNCTION
%token IF
%token IN
%token INHERITED
%token NIL
%token OBJECT
%token OF
%token PROCEDURE
%token PROGRAM
%token REPEAT
%token SELF
%token STRING
%token THEN
%token TO
%token TYPE
%token UNTIL
%token VAR
%token WHILE
%token FORWARD

	/* Модификаторы */
%token STATIC
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token STRICT

	/* Специфичные для Object Pascal */
%token CLASS
%token OTHERWISE
%token OUT

	/* Литераты и идентификаторы */
%token<IdUnion> ID
%token<LiterIntUnion> INT_L
%token<LiterRealUnion> REAL_L
%token<LiterStrUnion> STRING_L

%token ASM ABSOLUTE FILE_KW GOTO LABEL OPERATOR PACKED PROPERTY REINTRODUCE UNIT USES SHL SHR XOR POWER

	/* Операторы */
%token ASSIGN
%token ADD_ASSIGN
%token SUB_ASSIGN
%token DIV_ASSIGN
%token MUL_ASSIGN
%token RANGE


	/* приоритеты */
%left '=' '>' '<' NOT_EQUAL LESS_OR_EQUAL GREATER_OR_EQUAL IS
%left '+' '-' OR
%left '*' '/' DIV MOD AND AS
%right UNARY_MINUS UNARY_PLUS NOT
%left '.' '['

%%

/* Программа и блок */
program : PROGRAM ID ';' block '.' { programRoot = ProgramNode::CreateProgramNode(*$2, $4); $$ = programRoot; }
	    ;

block : declaration_part_e compound_statement { $$ = BlockNode::CreateBlockNode($1, $2); }
      ;

declaration_part_e : %empty { $$ = DeclNode::CreateEmptyDeclList(); }
                   | declaration_part { $$ = $1; }
                   ;

declaration_part : declaration { $$ = DeclNode::CreateDeclList($1); }
                 | declaration_part declaration { $$ = DeclNode::AddToDeclList($1, $2); }
                 ;

/* Виды объявлений */
declaration : constant_declaration_list { $$ = $1; }
            | type_declaration_list { $$ = $1; }
            | variable_declaration_list { $$ = $1; }
            | subroutine_definition { $$ = $1; }
            ;

/* Объявления констант */
constant_declaration_list : CONST constant_declaration { $$ = DeclNode::CreateSection(ENUM_DECL_CONST_SECTION, $2); }
                          | constant_declaration_list constant_declaration { $$ = DeclNode::AddToDeclList($1, $2); }
                          ;

constant_declaration : ID '=' expr ';' { $$ = DeclNode::CreateConstDecl(*$1, nullptr, $3); }
                     | ID ':' type '=' init_value ';' { $$ = DeclNode::CreateConstDecl(*$1, $3, $5); }
                     ;

/* Объявления типов */
type_declaration_list : TYPE type_declaration { $$ = DeclNode::CreateSection(ENUM_DECL_TYPE_SECTION, $2); }
                      | type_declaration_list type_declaration { $$ = DeclNode::AddToDeclList($1, $2); }
                      ;

type_declaration : ID '=' type ';' { $$ = DeclNode::CreateTypeDecl(*$1, $3); } /* Обычные типы */
                 | ID '=' class_type ';' { $$ = DeclNode::CreateTypeDecl(*$1, $3); } /* Объявление класса */
                 ;

/* Типы */
type : not_array_type { $$ = $1; }
     | array_type { $$ = $1; } /* Массивы */
     ;

not_array_type : ordinal_type { $$ = $1; }
               | STRING { $$ = TypeNode::CreateStringType(); }
               ;

/* Порядковые типы */
ordinal_type : ID { $$ = TypeNode::CreateNameType(*$1); } /* Integer, Char, Boolean ... */
             | range_bound RANGE range_bound { $$ = TypeNode::CreateRangeType($1, $3); } /* Диапазоны */
             | enum_type { $$ = $1; }
             ;

range_bound : INT_L { $$ = ExprNode::CreateIntNode($1); }
            | STRING_L { $$ = ExprNode::CreateStringNode(*$1); }
            | ID { $$ = ExprNode::CreateIdNode(*$1); }
            | range_bound '+' range_bound { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_ADD, $1, $3); }
            | range_bound '-' range_bound { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_SUB, $1, $3); }
            | range_bound '*' range_bound { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_MUL, $1, $3); }
            | range_bound DIV range_bound { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_DIV, $1, $3); }
            | '-' range_bound %prec UNARY_MINUS { $$ = ExprNode::CreateUnaryNode(ENUM_EXPR_UNARY_MINUS, $2); }
            | '+' range_bound %prec UNARY_PLUS { $$ = ExprNode::CreateUnaryNode(ENUM_EXPR_UNARY_PLUS, $2); }
            | range_bound AND range_bound { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_AND, $1, $3); }
            | range_bound OR range_bound { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_OR, $1, $3); }
            | NOT range_bound { $$ = ExprNode::CreateUnaryNode(ENUM_EXPR_NOT, $2); }
            | range_bound '.' ID { $$ = ExprNode::CreateMemberNode($1, *$3); } // элемент перечисления / константа класса
            ;

/* Перечисления */
enum_type : '(' enum_element_list ')' { $$ = $2; }
          ;

enum_element : ID { $$ = TypeNode::CreateEnumElement(*$1, nullptr); }
             | ID ASSIGN expr { $$ = TypeNode::CreateEnumElement(*$1, $3); } /* ручное изменение порядкового номера */
             ;

enum_element_list : enum_element { $$ = TypeNode::CreateEnumType($1); }
                  | enum_element_list ',' enum_element { $$ = TypeNode::AddToEnumType($1, $3); }
                  ;

/* Массивы */
array_type : array_bases not_array_type { $$ = TypeNode::SetArrayElementType($1, $2); }
           ;

array_bases : array_base { $$ = $1; }
            | array_bases array_base { $$ = TypeNode::AddArrayBase($1, $2); } /* Допустимо несколько array of или array[..] */
            ;

array_base : ARRAY '[' range_list ']' OF { $$ = $3; } /* скобки с диапазоном пустыми быть не могут */
           | ARRAY OF { $$ = TypeNode::CreateDynamicArrayType(); } /* Динамические массивы */
           ;

range_list : range_bound RANGE range_bound { $$ = TypeNode::CreateStaticArrayType($1, $3); }
           | range_list ',' range_bound RANGE range_bound { $$ = TypeNode::AddArrayRange($1, $3, $5); }
           ;

/* Списки идентификаторов */
id_list : ID { $$ = DeclNode::CreateIdList(*$1); }
        | id_list ',' ID { $$ = DeclNode::AddToIdList($1, *$3); }
        ;

big_id_list : ID ',' ID { $$ = DeclNode::AddToIdList(DeclNode::CreateIdList(*$1), *$3); } /* Список от двух идентификаторов */
            | big_id_list ',' ID { $$ = DeclNode::AddToIdList($1, *$3); }
            ;

/* Объявления переменных */
variable_declaration_list : VAR variable_declaration { $$ = DeclNode::CreateSection(ENUM_DECL_VAR_SECTION, $2); }
                          | variable_declaration_list variable_declaration { $$ = DeclNode::AddToDeclList($1, $2); }
                          ;

variable_declaration : id_list ':' type ';' { $$ = DeclNode::CreateVarDecl($1, $3, nullptr); }
                     | id_list ':' type '=' init_value ';' { $$ = DeclNode::CreateVarDecl($1, $3, $5); }
                     ;

init_value : expr { $$ = $1; } /* Начальное значение. Включает случай инициализации массива одним элементом */
           | '(' expr ',' expr_list ')' { $$ = ExprNode::CreateArrayInitNode($2, $4); } /* Инициализация массива (от двух элементов) */
           ;

/* Классы */
class_type : CLASS { $$ = TypeNode::CreateForwardClassType(""); } /* forward объявление */
           | CLASS END { $$ = TypeNode::CreateClassType("", nullptr); }
           | CLASS '(' ID ')' { $$ = TypeNode::CreateForwardClassType(*$3); } /* Наследование */
           | CLASS '(' ID ')' END { $$ = TypeNode::CreateClassType(*$3, nullptr); }
           | CLASS '(' ID ')' component_list END { $$ = TypeNode::CreateClassType(*$3, $5); }
           | CLASS component_list END { $$ = TypeNode::CreateClassType("", $2); }
           ;

component_list : field_declaration_list member_list { $$ = DeclNode::MergeDeclLists($1, $2); }
               | field_declaration_list { $$ = $1; }
               | member_list { $$ = $1; }
               ;

field_declaration_list : id_list ':' type ';' { $$ = DeclNode::CreateFieldList($1, $3); } /* Список полей класса вне var, const ... */
                       | field_declaration_list id_list ':' type ';' { $$ = DeclNode::AddToFieldList($1, $2, $4); }
                       ;

member_list : member { $$ = DeclNode::CreateDeclList($1); }
            | member_list member { $$ = DeclNode::AddToDeclList($1, $2); }
            ;

member : variable_declaration_list { $$ = $1; }
       | constant_declaration_list { $$ = $1; }
       | type_declaration_list { $$ = $1; }
       | subroutine_header ';' modifiers_list_e { $$ = DeclNode::CreateMethodDecl($1, $3); } /* Определение метода */
       ;

modifiers_list_e : %empty { $$ = DeclNode::CreateEmptyIdList(); }
                 | modifiers_list { $$ = $1; }
                 ;

modifiers_list : ID ';' { $$ = DeclNode::CreateIdList(*$1); } /* abstract, virtual, dynamic ... */
               | modifiers_list ID ';' { $$ = DeclNode::AddToIdList($1, *$2); }
               ;


/* Процедуры и функции */
subroutine_definition : subroutine_header ';' modifiers_list_e subroutine_block ';' { $$ = DeclNode::CreateSubroutineDef($1, $3, $4); }
                      ;

subroutine_header : PROCEDURE subroutine_name formal_parameter_list_e { $$ = SubroutineNode::CreateSubroutineHeader(ENUM_SUB_PROCEDURE, $2, $3, nullptr); }
                  | FUNCTION subroutine_name formal_parameter_list_e ':' type_id { $$ = SubroutineNode::CreateSubroutineHeader(ENUM_SUB_FUNCTION, $2, $3, $5); }
                  | CONSTRUCTOR subroutine_name formal_parameter_list_e { $$ = SubroutineNode::CreateSubroutineHeader(ENUM_SUB_CONSTRUCTOR, $2, $3, nullptr); }
                  | DESTRUCTOR subroutine_name { $$ = SubroutineNode::CreateSubroutineHeader(ENUM_SUB_DESTRUCTOR, $2, nullptr, nullptr); }
                  | DESTRUCTOR subroutine_name '(' ')' { $$ = SubroutineNode::CreateSubroutineHeader(ENUM_SUB_DESTRUCTOR, $2, nullptr, nullptr); }
                  ;

subroutine_name : ID { $$ = DeclNode::CreateIdList(*$1); }
                | subroutine_name '.' ID { $$ = DeclNode::AddToIdList($1, *$3); } /* название с указанием класса */
                ;

formal_parameter_list_e : %empty { $$ = ParamNode::CreateEmptyParamList(); }
                        | '(' ')' { $$ = ParamNode::CreateEmptyParamList(); }
                        | '(' parameter_declarations ')' { $$ = $2; }
                        ;

parameter_declarations : parameter_declaration { $$ = ParamNode::CreateParamList($1); }
                       | parameter_declarations ';' parameter_declaration { $$ = ParamNode::AddToParamList($1, $3); }
                       ;

parameter_declaration : value_parameter { $$ = $1; }
                      | var_parameter { $$ = $1; }
                      | const_parameter { $$ = $1; }
                      ;

value_parameter : big_id_list ':' parameter_type { $$ = ParamNode::CreateParamGroup(ENUM_PARAM_VALUE, $1, $3, nullptr); }
                | ID ':' type_id '=' expr { $$ = ParamNode::CreateParam(ENUM_PARAM_VALUE, *$1, $3, $5); } /* Присваивать нач. значение можно только одному параметру */
                | ID ':' parameter_type { $$ = ParamNode::CreateParam(ENUM_PARAM_VALUE, *$1, $3, nullptr); }
                ;

var_parameter : VAR id_list ':' parameter_type { $$ = ParamNode::CreateParamGroup(ENUM_PARAM_VAR, $2, $4, nullptr); }
              | VAR id_list { $$ = ParamNode::CreateParamGroup(ENUM_PARAM_VAR, $2, nullptr, nullptr); }
              ;

const_parameter : CONST big_id_list ':' parameter_type { $$ = ParamNode::CreateParamGroup(ENUM_PARAM_CONST, $2, $4, nullptr); }
                | CONST ID ':' type_id '=' expr { $$ = ParamNode::CreateParam(ENUM_PARAM_CONST, *$2, $4, $6); } /* Присваивать нач. значение можно только одному параметру */
                | CONST ID ':' parameter_type { $$ = ParamNode::CreateParam(ENUM_PARAM_CONST, *$2, $4, nullptr); }
                ;

parameter_type : type_id { $$ = $1; }
               | ARRAY OF type_id { $$ = TypeNode::SetArrayElementType(TypeNode::CreateDynamicArrayType(), $3); }
               ;

type_id : ID { $$ = TypeNode::CreateNameType(*$1); }
        | STRING { $$ = TypeNode::CreateStringType(); }
        ;

subroutine_block : block { $$ = $1; }
                 | FORWARD { $$ = nullptr; }
                 ;

/* Операторы */
stmt : expr ASSIGN expr { $$ = StmtNode::CreateAssignNode(ENUM_STMT_ASSIGN, $1, $3); }
     | expr ADD_ASSIGN expr { $$ = StmtNode::CreateAssignNode(ENUM_STMT_ADD_ASSIGN, $1, $3); }
     | expr SUB_ASSIGN expr { $$ = StmtNode::CreateAssignNode(ENUM_STMT_SUB_ASSIGN, $1, $3); }
     | expr DIV_ASSIGN expr { $$ = StmtNode::CreateAssignNode(ENUM_STMT_DIV_ASSIGN, $1, $3); }
     | expr MUL_ASSIGN expr { $$ = StmtNode::CreateAssignNode(ENUM_STMT_MUL_ASSIGN, $1, $3); }
     | ID { $$ = StmtNode::CreateCallNode(ExprNode::CreateCallNode(*$1, {})); } /* Вызов функции без скобок */
     | expr '.' ID { $$ = StmtNode::CreateCallNode(ExprNode::CreateMethodCallNode($1, *$3, {})); } /* Вызов метода без скобок */
     | ID '(' expr_list_e ')' { $$ = StmtNode::CreateCallNode(ExprNode::CreateCallNode(*$1, $3->list_elements)); } /* Вызов функции/процедуры */
     | expr '.' ID '(' expr_list_e ')' { $$ = StmtNode::CreateCallNode(ExprNode::CreateMethodCallNode($1, *$3, $5->list_elements)); } /* Вызов метода с параметрами */
     | INHERITED { $$ = StmtNode::CreateCallNode(ExprNode::CreateInheritedNode("", {})); } /* Вызов метода родительского класса */
     | INHERITED ID { $$ = StmtNode::CreateCallNode(ExprNode::CreateInheritedNode(*$2, {})); }
     | INHERITED ID '(' expr_list_e ')' { $$ = StmtNode::CreateCallNode(ExprNode::CreateInheritedNode(*$2, $4->list_elements)); }
     | compound_statement { $$ = $1; }
     | for_stmt { $$ = $1; }
     | repeat_stmt { $$ = $1; }
     | while_stmt { $$ = $1; }
     | if_stmt { $$ = $1; }
     | %empty { $$ = StmtNode::CreateEmptyNode(); }
     ;

/* Циклы */
for_stmt : FOR ID ASSIGN expr TO expr DO stmt { $$ = StmtNode::CreateForNode(ENUM_STMT_FOR_TO, *$2, $4, $6, $8); }
         | FOR ID ASSIGN expr DOWNTO expr DO stmt { $$ = StmtNode::CreateForNode(ENUM_STMT_FOR_DOWNTO, *$2, $4, $6, $8); }
         | FOR ID IN expr DO stmt { $$ = StmtNode::CreateForInNode(*$2, $4, $6); } /* через перечисление */
         ;

repeat_stmt : REPEAT stmt_list UNTIL expr { $$ = StmtNode::CreateRepeatNode($2, $4); }
            ;

while_stmt : WHILE expr DO stmt { $$ = StmtNode::CreateWhileNode($2, $4); }
           ;

/* if...then...else */
if_stmt : IF expr THEN stmt { $$ = StmtNode::CreateIfNode($2, $4, nullptr); }
        | IF expr THEN stmt ELSE stmt { $$ = StmtNode::CreateIfNode($2, $4, $6); }
        ;

/* Составной оператор и список операторов */
compound_statement : BEGIN_KW stmt_list END { $$ = $2; }
                   ;

stmt_list : stmt { $$ = StmtNode::CreateStmtList($1); }
	      | stmt_list ';' stmt { $$ = StmtNode::AddToStmtList($1, $3); }
	      ;

/* Выражения */
expr : INT_L { $$ = ExprNode::CreateIntNode($1); }
     | REAL_L { $$ = ExprNode::CreateRealNode($1); }
     | STRING_L { $$ = ExprNode::CreateStringNode(*$1); }
     | NIL { $$ = ExprNode::CreateNilNode(); }
     | ID { $$ = ExprNode::CreateIdNode(*$1); } /* Вызов функции без скобок, просто идентификатор или, например, True */
     | expr '=' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_EQUALS, $1, $3); }
     | expr '<' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_LESS, $1, $3); }
     | expr '>' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_GREATER, $1, $3); }
     | expr NOT_EQUAL expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_NOT_EQUALS, $1, $3); }
     | expr LESS_OR_EQUAL expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_LESS_OR_EQUALS, $1, $3); }
     | expr GREATER_OR_EQUAL expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_GREATER_OR_EQUALS, $1, $3); }
     | expr IS expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_IS, $1, $3); }
     | expr '+' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_ADD, $1, $3); }
     | expr '-' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_SUB, $1, $3); }
     | expr OR expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_OR, $1, $3); }
     | expr '*' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_MUL, $1, $3); }
     | expr '/' expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_DIVIDE, $1, $3); }
     | expr DIV expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_DIV, $1, $3); }
     | expr MOD expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_MOD, $1, $3); }
     | expr AND expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_AND, $1, $3); }
     | expr AS expr { $$ = ExprNode::CreateBinaryNode(ENUM_EXPR_AS, $1, $3); }
     | '-' expr %prec UNARY_MINUS { $$ = ExprNode::CreateUnaryNode(ENUM_EXPR_UNARY_MINUS, $2); }
     | '+' expr %prec UNARY_PLUS { $$ = ExprNode::CreateUnaryNode(ENUM_EXPR_UNARY_PLUS, $2); }
     | NOT expr { $$ = ExprNode::CreateUnaryNode(ENUM_EXPR_NOT, $2); }
     | '(' expr ')' { $$ = $2; }
     | expr '.' ID { $$ = ExprNode::CreateMemberNode($1, *$3); } /* Вызов метода без скобок */
     | expr '[' expr_list ']' { $$ = ExprNode::CreateIndexNode($1, $3->list_elements); } /* Доступ к эл-ту массива */
     | ID '(' expr_list_e ')' { $$ = ExprNode::CreateCallNode(*$1, $3->list_elements); } /* Вызов функции/процедуры */
     | expr '.' ID '(' expr_list_e ')' { $$ = ExprNode::CreateMethodCallNode($1, *$3, $5->list_elements); }
     | SELF { $$ = ExprNode::CreateSelfNode(); } /* Ссылка на текущий экземпляр класса */
     | INHERITED { $$ = ExprNode::CreateInheritedNode("", {}); } /* Вызов метода родительского класса */
     | INHERITED ID { $$ = ExprNode::CreateInheritedNode(*$2, {}); }
     | INHERITED ID '(' expr_list_e ')' { $$ = ExprNode::CreateInheritedNode(*$2, $4->list_elements); }
     ;

expr_list : expr { $$ = ExprNode::CreateExprList($1); }
          | expr_list ',' expr { $$ = ExprNode::AddToExprList($1, $3); }
          ;

expr_list_e : %empty { $$ = ExprNode::CreateEmptyExprList(); }
            | expr_list { $$ = $1; }
            ;

%%
