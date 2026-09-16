%option noyywrap
%option never-interactive
%option yylineno
%option c++

%{
#include <string>
#include "core/Console.h"
#include "core/Buffer.h"

using std::string;
%}

/* ----------------------------
   States
   ---------------------------- */

/* Здесь будут состояния для сложных конструкций (по типу строковых констант и т.п.) */
%x COMMENT_ONE_CHAR
%x COMMENT_TWO_CHAR
%x STRING
%x STRING_CONT

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

CONTROL_CODE       \#({DIGIT}+|\${HEX_DIGIT}+|\&{OCT_DIGIT}+|\%{BIN_DIGIT}+)
CONTROL_CARET_CODE \^[A-Za-z]

%%

%{
    int commentDepth = 0;
    Buffer commentBuf;
    Buffer stringBuf;
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
    commentBuf.reset();
    commentBuf.setStartLine(lineno());
    BEGIN(COMMENT_ONE_CHAR);
}
<COMMENT_ONE_CHAR>[^{}]* {
    commentBuf.append(yytext);
}
<COMMENT_ONE_CHAR>\{ {
    commentDepth++;
    commentBuf.append(yytext);
}
<COMMENT_ONE_CHAR>\} {
    commentDepth--;
    if (commentDepth == 0) {
        Console::Log("COMMENT: {" + commentBuf.current() + "}");
        BEGIN(INITIAL);
    } else {
        commentBuf.append(yytext);
    }
}
<COMMENT_ONE_CHAR><<EOF>> {
    Console::Error("Line " + std::to_string(commentBuf.getStartLine()) + ": unclosed comment '{'");
    BEGIN(INITIAL);
}


\(\* {
    commentDepth = 1;
    commentBuf.reset();
    commentBuf.setStartLine(lineno());
    BEGIN(COMMENT_TWO_CHAR);
}
<COMMENT_TWO_CHAR>[^*(]* {
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\(+[^*]* {
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\*+[^)]* {
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\(\* {
    commentDepth++;
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\*\) {
    commentDepth--;
    if (commentDepth == 0) {
        Console::Log("COMMENT: (*" + commentBuf.current() + "*)");
        BEGIN(INITIAL);
    } else {
        commentBuf.append(yytext);
    }
}
<COMMENT_TWO_CHAR><<EOF>> {
    Console::Error("Line " + std::to_string(commentBuf.getStartLine()) + ": unclosed comment '(*'");
    BEGIN(INITIAL);
}


\' {
    stringBuf.reset();
    stringBuf.setStartLine(lineno());
    BEGIN(STRING);
}
{CONTROL_CODE} {
    stringBuf.reset();
    stringBuf.setStartLine(lineno());
    int base = 10;
    if (yytext[1] == '$') {
        base = 16;
    } else if (yytext[1] == '&') {
        base = 8;
    } else if (yytext[1] == '%') {
        base = 2;
    }

    stringBuf.append(string(1, (char) strtoll(yytext + 1, nullptr, base)));
    BEGIN(STRING_CONT);
}
{CONTROL_CARET_CODE} {
    stringBuf.reset();
    stringBuf.setStartLine(lineno());
    stringBuf.append(string(1, (char) (toupper(yytext[1]) - 'A' + 1)));
    BEGIN(STRING_CONT);
}

<STRING>[^'\n]* {
    stringBuf.append(yytext);
}
<STRING>\'\' {
    stringBuf.append("'");
}
<STRING>\' {
    BEGIN(STRING_CONT);
}
<STRING>\n {
    Console::Error("Line " + std::to_string(stringBuf.getStartLine()) + ": string contains a line break");
    BEGIN(INITIAL);
}


<STRING_CONT>\' {
    BEGIN(STRING);
}
<STRING_CONT>{CONTROL_CODE} {
    int base = 10;
    if (yytext[1] == '$') {
        base = 16;
    } else if (yytext[1] == '&') {
        base = 8;
    } else if (yytext[1] == '%') {
        base = 2;
    }

    stringBuf.append(string(1, (char) strtoll(yytext + 1, nullptr, base)));
}
<STRING_CONT>{CONTROL_CARET_CODE} {
    stringBuf.append(string(1, (char) (toupper(yytext[1]) - 'A' + 1)));
}
<STRING_CONT>(.|\n) { yyless(0); Console::Log("STRING: " + stringBuf.current()); BEGIN(INITIAL); }


{ID}                    { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
.                       {
                            /* Пример вывода ошибки (с номером строки через lineno()) */
                            Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN: " + string(yytext));
                        }

%%
