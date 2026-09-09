%option noyywrap
%option never-interactive
%option c++

%{
#include <iostream>
%}

%%

[0-9]+                  { std::cout << "NUMBER: " << yytext << std::endl; }
[A-Za-z_][A-Za-z0-9_]*  { std::cout << "IDENTIFIER: " << yytext << std::endl; }
[ \t\r\n]+              { /* ignore */ }
.                       { std::cout << "UNKNOWN: " << yytext << std::endl; }

%%
