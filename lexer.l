%option noyywrap
%option never-interactive
%option c++

%{
#include <string>
#include "core/Console.h"

using std::string;
%}

%%

[0-9]+                  { Console::Log("NUMBER: " + string(yytext)); }
[A-Za-z_][A-Za-z0-9_]*  { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
.                       { Console::Error("UNKNOWN: " + string(yytext)); }

%%
