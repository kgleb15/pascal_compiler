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
%token IMPLEMENTATION
%token INHERITED
%token INTERFACE
%token NIL
%token OBJECT
%token OF
%token PROCEDURE
%token PROGRAM
%token RECORD
%token REPEAT
%token SELF
%token SET
%token STRING
%token THEN
%token TO
%token TYPE
%token UNTIL
%token VAR
%token WHILE
%token WITH
%token STATIC
%token PRIVATE
%token PROTECTED
%token PUBLIC
%token STRICT

%token PACKED
%token CLASS
%token PROPERTY

	/* Литераты и идентификаторы */
%token ID
%token INT_L
%token REAL_L
%token STRING_L

%token ASSIGN
%token ADD_ASSIGN
%token SUB_ASSIGN
%token DIV_ASSIGN
%token MUL_ASSIGN
%token RANGE


	/* приоритеты */
%left '=' '>' '<' NOT_EQUAL LESS_OR_EQUAL GREATER_OR_EQUAL IN IS
%left '+' '-' OR XOR
%left '*' '/' DIV MOD AND SHR SHL AS SYMMETRIC_DIFFERENCE
%right UNARY_MINUS UNARY_PLUS NOT '@'
%nonassoc '.' '[' '(' '^'


%%

program : PROGRAM ID ';' declaration_part compound_statement '.'
	    ;

declaration_part : /* empty */
                 | declaration_part declaration
                 ;

/* разные типы объявлений */
declaration : constant_declaration_list
            | type_declaration_list
            | variable_declaration_list
            ;

constant_declaration_list : CONST constant_declaration
                          | constant_declaration_list constant_declaration
                          ;

constant_declaration : ID '=' expr ';'
                     | ID ':' ID '=' init_value ';'
                     | ID ':' STRING '=' init_value ';' /* TODO: использовать type */
                     ;

type_declaration_list : TYPE type_declaration
                      | type_declaration_list type_declaration
                      ;

type_declaration : ID '=' type ';'
                 | ID '=' class_type ';'
                 ;

type : not_array_type
     | array_type   /* Массивы */
     ;

not_array_type : ordinal_type
               | STRING
               | STRING '[' INT_L ']'
               | TYPE STRING '(' INT_L ')'
               | record_type
               | SET OF ordinal_type /* set type */
               | '^' ID      /* pounter type */
               | procedural_type
               | TYPE ID     /* Type aliase */
               ;

ordinal_type : ID
             | ordinal_constant_bound RANGE ordinal_constant_bound  /* Диапазоны */
             ; /* TODO: enum */

ordinal_constant_bound : integer_bound
                       | ID
                       | STRING_L
                       ;

integer_bound : INT_L
              | integer_bound '+' integer_bound
              | integer_bound '-' integer_bound
              | integer_bound '*' integer_bound
              | integer_bound DIV integer_bound
              | '-' integer_bound %prec UNARY_MINUS
              | '+' integer_bound %prec UNARY_PLUS
              | '(' integer_bound ')'
              ;

array_type : array_bases not_array_type /* Уточнить типы type */
           ;

array_bases : array_base
            | array_bases array_base
            ;

array_base : ARRAY '[' range_list ']' OF
           | PACKED ARRAY '[' range_list ']' OF
           | ARRAY OF /* Динамические массивы */
           ;

range_list : ordinal_type
           | range_list ',' ordinal_type
           ;

record_type : RECORD field_list_e END
            | PACKED RECORD field_list_e END
            ;

field_list_e : /* empty */
             | field_list
             ;

field_list : fixed_fields
           | fixed_fields ';'
           | fixed_fields ';' variant_part
           | variant_part /* ';' может быть и после variant_part но это обрабатывает variant_list*/
           ;

fixed_fields : fixed_field
             | fixed_fields ';' fixed_field
             ;

fixed_field : id_list ':' type
            ;

id_list : ID
        | id_list ',' ID
        ;

variant_part : CASE ordinal_type OF variant_list
             | CASE ID ':' ordinal_type OF variant_list
             ;

variant_list : variant_list_body
             | variant_list_body ';'
             ;

variant_list_body : variant
                  | variant_list_body ';' variant
                  ;

variant : expr_list ':' '(' field_list_e ')'
        ;

procedural_type : procedural_or_func_header
                | procedural_or_func_header OF OBJECT
                ;

procedural_or_func_header : PROCEDURE formal_parameter_list_e
                          | FUNCTION formal_parameter_list_e ':' result_type
                          ;

formal_parameter_list_e : /* empty */
                        | '(' ')'
                        | '(' formal_parameters ')'
                        ;

formal_parameters : parameter_declaration
                  | formal_parameters ';' parameter_declaration
                  ;

/* TODO: пока упрощенная версия */
parameter_declaration : parameter_modifier id_list ':' type
                      | id_list ':' type
                      | parameter_modifier id_list
                      ;

parameter_modifier : VAR
                   | CONST
                   ; /* TODO: out */

result_type : ID
            | STRING
            ;


variable_declaration_list : VAR variable_declaration
                          | variable_declaration_list variable_declaration
                          ;

variable_declaration : id_list ':' type ';'
                     | id_list ':' type '=' init_value ';'
                     ;

init_value : expr
           | '(' init_value ',' array_init_value_list ')' /* Инициализация массива из одного элемента считается как expr */
           | '(' record_init_value_list ')'
           ;

array_init_value_list : init_value
                      | array_init_value_list ',' init_value
                      ;

record_init_value_list : record_init_value
                       | record_init_value_list ';' record_init_value
                       ;

record_init_value : ID ':' init_value
                  ;


class_type : CLASS
           | CLASS END
           | CLASS heritage
           | CLASS heritage END
           | CLASS heritage component_list END
           | CLASS component_list END
           ;

heritage : '(' ID ')' /* Наследование */
         ;

component_list : initial_part visible_sections
               | initial_part
               | visible_sections
               ;

initial_part : field_definition_list member_list
             | field_definition_list
             | member_list
             ;

visible_sections : visible_section
                 | visible_sections visible_section
                 ;

visible_section : visibility_specifier field_definition_list_e member_list_e
                ;

visibility_specifier : PRIVATE
                     | PROTECTED
                     | PUBLIC
                     | STRICT PRIVATE
                     | STRICT PROTECTED
                     ;

field_definition_list_e : /* empty */
                        | field_definition_list
                        ;

field_definition_list : field_definition
                      | field_definition_list field_definition
                      ;

field_definition : id_list ':' type ';'
                 | id_list ':' type ';' STATIC ';'
                 ;

member_list_e : /* empty */
              | member_list
              ;

member_list : member
            | member_list member
            ;

member : variable_declaration_list
       | CLASS variable_declaration_list
       | constant_declaration_list
       | type_declaration_list
       | method_definition
       | property_definition
       ;

method_definition : CLASS method_header ';' method_directive_list
                  | method_header ';' method_directive_list
                  | CLASS method_header ';'
                  | method_header ';'
                  ;

method_header : FUNCTION ID formal_parameter_list_e ':' result_type
              | PROCEDURE ID formal_parameter_list_e
              | CONSTRUCTOR ID
              | DESTRUCTOR ID
              | CONSTRUCTOR ID '(' ')'
              | DESTRUCTOR ID '(' ')'
              ;

method_directive_list : method_directive
                      | method_directive_list method_directive
                      ;

method_directive : ID ';' /* abstract, virtual, dynamic ... */
                 | STATIC ';'
                 ;

property_definition : PROPERTY property_body
                    | CLASS PROPERTY property_body /* Статическое свойство */
                    ;

/* Название : тип ... */
property_body : ID ':' ID property_specifiers ';'
              ;

/* read GetX write SetX ... */
property_specifiers : ID ID
                    | property_specifiers ID ID
                    ;

stmt : expr ASSIGN expr
     | expr ADD_ASSIGN expr
     | expr SUB_ASSIGN expr
     | expr DIV_ASSIGN expr
     | expr MUL_ASSIGN expr
     | expr
     | compound_statement
     | for_stmt
     | repeat_stmt
     | while_stmt
     ;

for_stmt : FOR ID ASSIGN expr TO expr DO stmt
         | FOR ID ASSIGN expr DOWNTO expr DO stmt
         | FOR ID IN expr DO stmt
         ;

repeat_stmt : REPEAT stmt UNTIL expr
            ;

while_stmt : WHILE expr DO stmt
           ;

compound_statement : BEGIN stmt_list END
                   ;

stmt_list : stmt
	  | stmt_list ';' stmt
	  | stmt_list ';'
	  ;

expr : INT_L
     | REAL_L
     | STRING_L
     | NIL
     | ID
     | expr '=' expr
     | expr '<' expr
     | expr '>' expr
     | expr NOT_EQUAL expr
     | expr LESS_OR_EQUAL expr
     | expr GREATER_OR_EQUAL expr
     | expr IN expr
     | expr IS expr
     | expr '+' expr
     | expr '-' expr
     | expr OR expr
     | expr XOR expr
     | expr '*' expr
     | expr '/' expr
     | expr DIV expr
     | expr MOD expr
     | expr AND expr
     | expr SHL expr
     | expr SHR expr
     | expr AS expr
     | expr SYMMETRIC_DIFFERENCE expr
     | '-' expr %prec UNARY_MINUS
     | '+' expr %prec UNARY_PLUS
     | NOT expr
     | '(' expr ')'
     | expr '.' ID
     | expr '[' expr ']'
     | expr '^'
     | ID '(' expr_list_e ')'
     | expr '.' ID '(' expr_list_e ')'
     | '[' set_group_list_e ']'
     | '@' expr
     | SELF
     | INHERITED
     | INHERITED ID
     | INHERITED ID '(' expr_list_e ')'
     ;

expr_list : expr
          | expr_list ',' expr
          ;

expr_list_e : /* empty */
            | expr_list
            ;

set_group_list_e : /* empty */
                 | set_group_list
                 ;

set_group_list : set_group
               | set_group_list ',' set_group
               ;

set_group : expr
          | expr RANGE expr
          ;
%%