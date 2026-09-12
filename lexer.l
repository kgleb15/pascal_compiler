%option noyywrap
%option never-interactive
%option yylineno
%option c++

%{
#include <string>
#include "core/Console.h"

using std::string;
%}

/* ----------------------------
   States
   ---------------------------- */

/* Здесь будут состояния для сложных конструкций (по типу строковых констант и т.п.) */


/* ----------------------------
   Macros
   ---------------------------- */

/* Раздел с макросами, для более читабельного вида регулярок. Примеры макросов: */
DIGIT      [0-9]
LETTER     [A-Za-z_]
ID         {LETTER}({LETTER}|{DIGIT})*

%%


if                      { /* ---- Ключевые слова (пример) ---- */ Console::Log("KEYWORD: if"); }
then                    { Console::Log("KEYWORD: then"); }
else                    { Console::Log("KEYWORD: else"); }
begin                   { Console::Log("KEYWORD: begin"); }


\:\=                    { /* ---- Операторы (пример) ---- */ Console::Log("OPERATOR: :="); }
\=                      { Console::Log("OPERATOR: ="); }
\+                      { Console::Log("OPERATOR: +"); }
\;                      { Console::Log("OPERATOR: ;"); }



{DIGIT}+                { Console::Log("NUMBER: " + string(yytext)); }
{ID}                    { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
.                       {
                            /* Пример вывода ошибки (с номером строки через lineno()) */
                            Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN: " + string(yytext));
                        }

%%
