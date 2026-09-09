%option noyywrap
%option never-interactive

%{
#include <stdio.h>
%}

%%

[0-9]+                  { printf("NUMBER: %s\n", yytext); }
[A-Za-z_][A-Za-z0-9_]*  { printf("IDENTIFIER: %s\n", yytext); }
[ \t\r\n]+              { /* ignore whitespace */ }
.                       { printf("UNKNOWN: %s\n", yytext); }

%%
