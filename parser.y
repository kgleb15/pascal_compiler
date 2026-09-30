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
%token ID
%token INT_L
%token ASSIGN

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
     | ID
     ;

%%