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
%x COMMENT_ONE_CHAR
%x COMMENT_TWO_CHAR

/* ----------------------------
   Macros
   ---------------------------- */

/* Раздел с макросами, для более читабельного вида регулярок. Примеры макросов: */
DIGIT      [0-9]
HEX_DIGIT  [0-9A-Fa-f]
OCT_DIGIT  [0-7]
BIN_DIGIT  [01]

SCALE      [Ee][+-]?{DIGIT}+
REAL       ({DIGIT}+\.{DIGIT}+{SCALE}?)|({DIGIT}+{SCALE})

LETTER     [A-Za-z_]
ID         {LETTER}({LETTER}|{DIGIT})*

%%

%{
    int commentDepth = 0;
    int commentStartLine = 0;
    string commentText;
%}


if                      { /* ---- Ключевые слова (пример) ---- */ Console::Log("KEYWORD: if"); }
then                    { Console::Log("KEYWORD: then"); }
else                    { Console::Log("KEYWORD: else"); }
begin                   { Console::Log("KEYWORD: begin"); }


\:\=                    { /* ---- Операторы (пример) ---- */ Console::Log("OPERATOR: :="); }
\=                      { Console::Log("OPERATOR: ="); }
\+                      { Console::Log("OPERATOR: +"); }
\;                      { Console::Log("OPERATOR: ;"); }



\${HEX_DIGIT}+ {
    long long value = strtoll(yytext + 1, nullptr, 16);
    Console::Log("HEX_INT: " + std::to_string(value));
}

\&{OCT_DIGIT}+ {
    long long value = strtoll(yytext + 1, nullptr, 8);
    Console::Log("OCT_INT: " + std::to_string(value));
}

\%{BIN_DIGIT}+ {
    long long value = strtoll(yytext + 1, nullptr, 2);
    Console::Log("BIN_INT: " + std::to_string(value));
}

{REAL} {
    double value = strtod(yytext, nullptr);
    Console::Log("REAL: " + std::to_string(value));
}

{DIGIT}+ {
    long long value = strtoll(yytext, nullptr, 10);
    Console::Log("INTEGER: " + std::to_string(value));
}


\/\/[^\n]* {
    Console::Log("COMMENT: " + string(yytext));
}


\{ {
    commentDepth = 1;
    commentStartLine = lineno();
    commentText = "";
    BEGIN(COMMENT_ONE_CHAR);
}
<COMMENT_ONE_CHAR>[^{}]* {
    commentText += yytext;
}
<COMMENT_ONE_CHAR>\{ {
    commentDepth++;
    commentText += yytext;
}
<COMMENT_ONE_CHAR>\} {
    commentDepth--;
    if (commentDepth == 0) {
        Console::Log("COMMENT: {" + commentText + "}");
        BEGIN(INITIAL);
    } else {
        commentText += yytext;
    }
}
<COMMENT_ONE_CHAR><<EOF>> {
    Console::Error("Line " + std::to_string(commentStartLine) + ": unclosed comment '{'");
    BEGIN(INITIAL);
}


\(\* {
    commentDepth = 1;
    commentStartLine = lineno();
    commentText = "";
    BEGIN(COMMENT_TWO_CHAR);
}
<COMMENT_TWO_CHAR>[^*(]* {
    commentText += yytext;
}
<COMMENT_TWO_CHAR>\(+[^*]* {
    commentText += yytext;
}
<COMMENT_TWO_CHAR>\*+[^)]* {
    commentText += yytext;
}
<COMMENT_TWO_CHAR>\(\* {
    commentDepth++;
    commentText += yytext;
}
<COMMENT_TWO_CHAR>\*\) {
    commentDepth--;
    if (commentDepth == 0) {
        Console::Log("COMMENT: (*" + commentText + "*)");
        BEGIN(INITIAL);
    } else {
        commentText += yytext;
    }
}
<COMMENT_TWO_CHAR><<EOF>> {
    Console::Error("Line " + std::to_string(commentStartLine) + ": unclosed comment '(*'");
    BEGIN(INITIAL);
}

{ID}                    { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
.                       {
                            /* Пример вывода ошибки (с номером строки через lineno()) */
                            Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN: " + string(yytext));
                        }

%%
