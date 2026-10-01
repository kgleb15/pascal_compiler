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

	/* Литераты и идентификаторы */
%token ID
%token INT_L
%token REAL_L
%token STRING_L

%token ASSIGN
%token RANGE


	/* приоритеты */
%left '=' '>' '<' NOT_EQUAL LESS_OR_EQUAL GREATER_OR_EQUAL IN IS
%left '+' '-' OR XOR
%left '*' '/' DIV MOD AND SHR SHL AS SYMMETRIC_DIFFERENCE
%right UNARY_MINUS UNARY_PLUS NOT
%nonassoc '.' '[' '(' '^'


%%

program : PROGRAM ID ';' block '.'
	;

block : BEGIN stmt_list END	 /* вопрос с ; */
      ;

stmt_list : stmt
	  | stmt_list stmt
	  ;

stmt : ID ASSIGN expr
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