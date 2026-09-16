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
    /* ---------- Модули и структура ---------- */
(?i:program)        { Console::Log("KEYWORD: program"); }
(?i:unit)           { Console::Log("KEYWORD: unit"); }
(?i:interface)      { Console::Log("KEYWORD: interface"); }
(?i:implementation) { Console::Log("KEYWORD: implementation"); }
(?i:initialization) { Console::Log("KEYWORD: initialization"); }
(?i:finalization)   { Console::Log("KEYWORD: finalization"); }
(?i:uses)           { Console::Log("KEYWORD: uses"); }
(?i:library)        { Console::Log("KEYWORD: library"); }
(?i:package)        { Console::Log("KEYWORD: package"); }

    /* ---------- Блоки и определения ---------- */
(?i:begin)          { Console::Log("KEYWORD: begin"); }
(?i:end)            { Console::Log("KEYWORD: end"); }
(?i:const)          { Console::Log("KEYWORD: const"); }
(?i:var)            { Console::Log("KEYWORD: var"); }
(?i:type)           { Console::Log("KEYWORD: type"); }
(?i:label)          { Console::Log("KEYWORD: label"); }
(?i:procedure)      { Console::Log("KEYWORD: procedure"); }
(?i:function)       { Console::Log("KEYWORD: function"); }
(?i:forward)        { Console::Log("KEYWORD: forward"); }
(?i:external)       { Console::Log("KEYWORD: external"); }
(?i:absolute)       { Console::Log("KEYWORD: absolute"); }


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
