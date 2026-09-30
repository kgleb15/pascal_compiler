%define parse.error verbose


%start program

	/* --- Терминальные символы --- */
%token PROGRAM
%token BEGIN
%token END
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