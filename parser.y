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

%token PACKED

	/* Специфичные для Object Pascal */
%token CLASS
%token DISPINTERFACE
%token EXCEPT
%token EXPORTS
%token FINALIZATION
%token FINALLY
%token INITIALIZATION
%token INLINE
%token LIBRARY
%token ON
%token OUT
%token PROPERTY
%token RAISE
%token RESOURCESTRING
%token THREADVAR
%token TRY

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
%nonassoc THEN
%nonassoc ELSE


%%

program : PROGRAM ID ';' declaration_part compound_statement '.'
	    ;

declaration_part : /* empty */
                 | declaration_part declaration
                 ;

/* разные типы объявлений */
declaration : constant_declaration_list
            | type_declaration_list
            ;

constant_declaration_list : CONST constant_declaration
                          | constant_declaration_list constant_declaration
                          ;

constant_declaration : ID '=' expr ';'
                     | ID ':' ID '=' expr ';'
                     | ID ':' STRING '=' expr ';' /* TODO: использовать type */
                     ;

type_declaration_list : TYPE type_declaration
                      | type_declaration_list type_declaration
                      ;

type_declaration : ID '=' type ';'
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
     | if_stmt
     ;

for_stmt : FOR ID ASSIGN expr TO expr DO stmt
         | FOR ID ASSIGN expr DOWNTO expr DO stmt
         | FOR ID IN expr DO stmt
         ;

repeat_stmt : REPEAT stmt UNTIL expr
            ;

while_stmt : WHILE expr DO stmt
           ;

if_stmt : IF expr THEN stmt
        | IF expr THEN stmt ELSE stmt
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