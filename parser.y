	/* Подробные сообщения об ошибках: bison перечисляет ожидаемые токены */
%define parse.error verbose

%start program

	/* Терминальные символы */
%token ARRAY
%token BEGIN
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
%token PROPERTY

	/* Литераты и идентификаторы */
%token ID
%token INT_L
%token REAL_L
%token STRING_L

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
%nonassoc '.' '[' '('

%%

/* Программа и блок */
program : PROGRAM ID ';' block '.'
	    ;

block : declaration_part_e compound_statement
      ;

declaration_part_e : %empty
                   | declaration_part
                   ;

declaration_part : declaration
                 | declaration_part declaration
                 ;

/* Виды объявлений */
declaration : constant_declaration_list
            | type_declaration_list
            | variable_declaration_list
            | subroutine_declaration
            ;

/* Объявления констант */
constant_declaration_list : CONST constant_declaration
                          | constant_declaration_list constant_declaration
                          ;

constant_declaration : ID '=' expr ';'
                     | ID ':' type '=' init_value ';'
                     ;

/* Объявления типов */
type_declaration_list : TYPE type_declaration
                      | type_declaration_list type_declaration
                      ;

type_declaration : ID '=' type ';'          /* Обычные типы */
                 | ID '=' class_type ';'    /* Объявление класса */
                 ;

/* Типы */
type : not_array_type
     | array_type   /* Массивы */
     ;

not_array_type : ordinal_type
               | STRING
               | STRING '[' INT_L ']'
               ;

/* Порядковые типы */
ordinal_type : ID /* Integer, Char, Boolean ... */
             | range_bound RANGE range_bound  /* Диапазоны */
             | enum_type
             ;

range_bound : INT_L
            | STRING_L
            | ID
            | range_bound '+' range_bound
            | range_bound '-' range_bound
            | range_bound '*' range_bound
            | range_bound DIV range_bound
            | '-' range_bound %prec UNARY_MINUS
            | '+' range_bound %prec UNARY_PLUS
            | range_bound AND range_bound
            | range_bound OR range_bound
            | NOT range_bound
            | range_bound '.' ID
            ;

/* Перечисления */
enum_type : '(' enum_element_list ')'
          ;

enum_element : ID
             | ID ASSIGN expr /* ручное изменение порядкового номера */
             ;

enum_element_list : enum_element
                  | enum_element_list ',' enum_element
                  ;

/* Массивы */
array_type : array_bases not_array_type
           ;

array_bases : array_base
            | array_bases array_base /* Допустимо несколько array of или array[..] */
            ;

array_base : ARRAY '[' range_list ']' OF /* скобки с диапазоном пустыми быть не могут */
           | ARRAY OF /* Динамические массивы */
           ;

range_list : ordinal_type
           | range_list ',' ordinal_type
           ;

/* Списки идентификаторов */
id_list : ID
        | id_list ',' ID
        ;

big_id_list : ID ',' ID /* Список от двух идентификаторов */
            | big_id_list ',' ID
            ;

/* Объявления переменных */
variable_declaration_list : VAR variable_declaration
                          | variable_declaration_list variable_declaration
                          ;

variable_declaration : id_list ':' type ';'
                     | id_list ':' type '=' init_value ';'
                     ;

init_value : expr /* включает случай инициализации массива одним элементом */
           | '(' expr ',' expr_list ')' /* Инициализация массива (от двух элементов) */
           ;

/* Классы */
class_type : CLASS /* forward объявление */
           | CLASS END
           | CLASS '(' ID ')' /* Наследование */
           | CLASS '(' ID ')' END
           | CLASS '(' ID ')' component_list END
           | CLASS component_list END
           ;

component_list : field_definition_list member_list
               | field_definition_list
               | member_list
               ;

field_definition_list : field_definition
                      | field_definition_list field_definition
                      ;

field_definition : id_list ':' type ';'
                 ;

member_list : member
            | member_list member
            ;

member : variable_declaration_list
       | constant_declaration_list
       | type_declaration_list
       | subroutine_header ';' modifiers_list_e /* Определение метода */
       | PROPERTY ID ':' type_id property_specifiers ';' /* Определение свойства --- Название : тип ... */
       ;

modifiers_list_e : %empty
                 | modifiers_list
                 ;

modifiers_list : ID ';' /* abstract, virtual, dynamic ... */
               | modifiers_list ID ';'
               ;

property_specifiers : ID ID /* read GetX write SetX ... */
                    | property_specifiers ID ID
                    ;


/* Процедуры и функции */
subroutine_declaration : subroutine_header ';' modifiers_list_e subroutine_block ';'
                       ;

subroutine_header : PROCEDURE subroutine_name formal_parameter_list_e
                  | FUNCTION subroutine_name formal_parameter_list_e ':' type_id
                  | CONSTRUCTOR subroutine_name formal_parameter_list_e
                  | DESTRUCTOR subroutine_name
                  | DESTRUCTOR subroutine_name '(' ')'
                  ;

subroutine_name : ID
                | ID '.' ID /* название с указанием класса */
                ;

formal_parameter_list_e : %empty
                        | '(' ')'
                        | '(' paramater_declarations ')'
                        ;

paramater_declarations : parameter_declaration
                       | paramater_declarations ';' parameter_declaration
                       ;

parameter_declaration : value_parameter
                      | var_parameter
                      | out_parameter
                      | const_parameter
                      ;

value_parameter : big_id_list ':' parameter_type
                | ID ':' type_id '=' expr /* Присваивать нач. значение можно только одному параметру */
                | ID ':' parameter_type
                ;

var_parameter : VAR id_list ':' parameter_type
              | VAR id_list
              ;

out_parameter : OUT id_list ':' parameter_type
              | OUT id_list
              ;

const_parameter : CONST big_id_list ':' parameter_type
                | CONST big_id_list
                | CONST ID ':' type_id '=' expr /* Присваивать нач. значение можно только одному параметру */
                | CONST ID ':' parameter_type
                ;

parameter_type : type_id
               | ARRAY OF type_id
               ;

type_id : ID
        | STRING
        ;

subroutine_block : block
                 | FORWARD
                 ;

/* Операторы */
stmt : expr ASSIGN expr
     | expr ADD_ASSIGN expr
     | expr SUB_ASSIGN expr
     | expr DIV_ASSIGN expr
     | expr MUL_ASSIGN expr
     | ID
     | expr '.' ID /* Вызов метода без скобок */
     | ID '(' expr_list_e ')' /* Вызов функции/процедуры */
     | expr '.' ID '(' expr_list_e ')' /* Вызов метода с параметрами */
     | INHERITED /* Вызов метода родительского класса */
     | INHERITED ID
     | INHERITED ID '(' expr_list_e ')'
     | compound_statement
     | for_stmt
     | repeat_stmt
     | while_stmt
     | if_stmt
     | case_stmt
     | %empty
     ;

/* Циклы */
for_stmt : FOR ID ASSIGN expr TO expr DO stmt
         | FOR ID ASSIGN expr DOWNTO expr DO stmt
         | FOR ID IN expr DO stmt /* через перечисление */
         ;

repeat_stmt : REPEAT stmt_list UNTIL expr
            ;

while_stmt : WHILE expr DO stmt
           ;

/* if...then...else */
if_stmt : IF expr THEN stmt
        | IF expr THEN stmt ELSE stmt
        ;

/* case...of */
case_label : STRING_L
           | ID
           | INT_L
           | range_bound RANGE range_bound
           ;

case_label_list : case_label
                | case_label_list ',' case_label
                ;

case_variant : case_label_list ':' stmt
             ;

case_variant_list : case_variant
                  | case_variant_list ';' case_variant
                  ;

case_stmt : CASE expr OF case_variant_list opt_semicolon END
          | CASE expr OF case_variant_list opt_semicolon ELSE stmt_list END
          | CASE expr OF case_variant_list opt_semicolon OTHERWISE stmt_list END
          ;

opt_semicolon : %empty
              | ';'
              ;

/* Составной оператор и список операторов */
compound_statement : BEGIN stmt_list END
                   ;

stmt_list : stmt
	      | stmt_list ';' stmt
	      ;

/* Выражения */
expr : INT_L
     | REAL_L
     | STRING_L
     | NIL
     | ID /* Вызов функции без скобок, просто идентификатор или, например True*/
     | expr '=' expr
     | expr '<' expr
     | expr '>' expr
     | expr NOT_EQUAL expr
     | expr LESS_OR_EQUAL expr
     | expr GREATER_OR_EQUAL expr
     | expr IS expr
     | expr '+' expr
     | expr '-' expr
     | expr OR expr
     | expr '*' expr
     | expr '/' expr
     | expr DIV expr
     | expr MOD expr
     | expr AND expr
     | expr AS expr
     | '-' expr %prec UNARY_MINUS
     | '+' expr %prec UNARY_PLUS
     | NOT expr
     | '(' expr ')'
     | expr '.' ID /* Вызов метода без скобок */
     | expr '[' expr_list ']' /* Доступ к эл-ту массива */
     | ID '(' expr_list_e ')' /* Вызов функции/процедуры */
     | expr '.' ID '(' expr_list_e ')'
     | SELF
     | INHERITED /* Вызов метода родительского класса */
     | INHERITED ID
     | INHERITED ID '(' expr_list_e ')'
     ;

expr_list : expr
          | expr_list ',' expr
          ;

expr_list_e : %empty
            | expr_list
            ;


%%
