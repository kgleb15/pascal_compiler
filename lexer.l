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
CONTROL_CARET_CODE \^[A-Za-z]\b

%%

%{
    int commentDepth = 0;
    Buffer commentBuf;
    Buffer stringBuf;
%}


    /* ---------- Ключевые слова  ---------- */
(?i:and)            { Console::Log("KEYWORD: and"); }
(?i:array)          { Console::Log("KEYWORD: array"); }
(?i:asm)            { Console::Log("KEYWORD: asm"); }
(?i:begin)          { Console::Log("KEYWORD: begin"); }
(?i:case)           { Console::Log("KEYWORD: case"); }
(?i:const)          { Console::Log("KEYWORD: const"); }
(?i:constructor)    { Console::Log("KEYWORD: constructor"); }
(?i:destructor)     { Console::Log("KEYWORD: destructor"); }
(?i:div)            { Console::Log("KEYWORD: div"); }
(?i:do)             { Console::Log("KEYWORD: do"); }
(?i:downto)         { Console::Log("KEYWORD: downto"); }
(?i:else)           { Console::Log("KEYWORD: else"); }
(?i:end)            { Console::Log("KEYWORD: end"); }
(?i:file)           { Console::Log("KEYWORD: file"); }
(?i:for)            { Console::Log("KEYWORD: for"); }
(?i:function)       { Console::Log("KEYWORD: function"); }
(?i:goto)           { Console::Log("KEYWORD: goto"); }
(?i:if)             { Console::Log("KEYWORD: if"); }
(?i:implementation) { Console::Log("KEYWORD: implementation"); }
(?i:in)             { Console::Log("KEYWORD: in"); }
(?i:inherited)      { Console::Log("KEYWORD: inherited"); }
(?i:interface)      { Console::Log("KEYWORD: interface"); }
(?i:label)          { Console::Log("KEYWORD: label"); }
(?i:mod)            { Console::Log("KEYWORD: mod"); }
(?i:nil)            { Console::Log("KEYWORD: nil"); }
(?i:not)            { Console::Log("KEYWORD: not"); }
(?i:object)         { Console::Log("KEYWORD: object"); }
(?i:of)             { Console::Log("KEYWORD: of"); }
(?i:operator)       { Console::Log("KEYWORD: operator"); }
(?i:or)             { Console::Log("KEYWORD: or"); }
(?i:procedure)      { Console::Log("KEYWORD: procedure"); }
(?i:program)        { Console::Log("KEYWORD: program"); }
(?i:record)         { Console::Log("KEYWORD: record"); }
(?i:repeat)         { Console::Log("KEYWORD: repeat"); }
(?i:self)           { Console::Log("KEYWORD: self"); }
(?i:set)            { Console::Log("KEYWORD: set"); }
(?i:shl)            { Console::Log("KEYWORD: shl"); }
(?i:shr)            { Console::Log("KEYWORD: shr"); }
(?i:string)         { Console::Log("KEYWORD: string"); }
(?i:then)           { Console::Log("KEYWORD: then"); }
(?i:to)             { Console::Log("KEYWORD: to"); }
(?i:type)           { Console::Log("KEYWORD: type"); }
(?i:unit)           { Console::Log("KEYWORD: unit"); }
(?i:until)          { Console::Log("KEYWORD: until"); }
(?i:uses)           { Console::Log("KEYWORD: uses"); }
(?i:var)            { Console::Log("KEYWORD: var"); }
(?i:while)          { Console::Log("KEYWORD: while"); }
(?i:with)           { Console::Log("KEYWORD: with"); }
(?i:xor)            { Console::Log("KEYWORD: xor"); }

    /* ---------- Специфичные для Object Pascal ---------- */
(?i:as)             { Console::Log("KEYWORD: as"); }
(?i:class)          { Console::Log("KEYWORD: class"); }
(?i:dispinterface)  { Console::Log("KEYWORD: dispinterface"); }
(?i:except)         { Console::Log("KEYWORD: except"); }
(?i:exports)        { Console::Log("KEYWORD: exports"); }
(?i:finalization)   { Console::Log("KEYWORD: finalization"); }
(?i:finally)        { Console::Log("KEYWORD: finally"); }
(?i:initialization) { Console::Log("KEYWORD: initialization"); }
(?i:inline)         { Console::Log("KEYWORD: inline"); }
(?i:is)             { Console::Log("KEYWORD: is"); }
(?i:library)        { Console::Log("KEYWORD: library"); }
(?i:on)             { Console::Log("KEYWORD: on"); }
(?i:out)            { Console::Log("KEYWORD: out"); }
(?i:packed)         { Console::Log("KEYWORD: packed"); }
(?i:property)       { Console::Log("KEYWORD: property"); }
(?i:raise)          { Console::Log("KEYWORD: raise"); }
(?i:resourcestring) { Console::Log("KEYWORD: resourcestring"); }
(?i:threadvar)      { Console::Log("KEYWORD: threadvar"); }
(?i:try)            { Console::Log("KEYWORD: try"); }

    /* ---------- Операторы ---------- */
    /* ---------- Длинные операторы ---------- */
\<\<    { Console::Log("OPERATOR: <<"); }
\>\>    { Console::Log("OPERATOR: <<"); }
\*\*    { Console::Log("OPERATOR: **"); }
\<\>    { Console::Log("OPERATOR: <>"); }
\>\<    { Console::Log("OPERATOR: ><"); }
\<\=    { Console::Log("OPERATOR: <="); }
\>\=    { Console::Log("OPERATOR: >="); }
\:\=    { Console::Log("OPERATOR: :="); }
\+\=    { Console::Log("OPERATOR: +="); }
\-\=    { Console::Log("OPERATOR: -="); }
\*\=    { Console::Log("OPERATOR: *="); }
\/\=    { Console::Log("OPERATOR: :="); }
\(\.    { Console::Log("OPERATOR: (*"); }
\.\)    { Console::Log("OPERATOR: :="); }
\.\.        { Console::Log("OPERATOR: .."); }
\*\*        { Console::Log("OPERATOR: **"); }


    /* ---------- Односимвольные операторы ---------- */
\+  { Console::Log("OPERATOR: +"); }
\-  { Console::Log("OPERATOR: -"); }
\*  { Console::Log("OPERATOR: *"); }
\/  { Console::Log("OPERATOR: /"); }
\=  { Console::Log("OPERATOR: ="); }
\<  { Console::Log("OPERATOR: <"); }
\>  { Console::Log("OPERATOR: >"); }
\[  { Console::Log("OPERATOR: ["); }
\]  { Console::Log("OPERATOR: ]"); }
\;  { Console::Log("OPERATOR: ;"); }
\.  { Console::Log("OPERATOR: ."); }
\,  { Console::Log("OPERATOR: ,"); }
\(  { Console::Log("OPERATOR: ("); }
\)  { Console::Log("OPERATOR: )"); }
\:  { Console::Log("OPERATOR: :"); }
\^  { Console::Log("OPERATOR: ^"); }
\@  { Console::Log("OPERATOR: @"); }

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
<COMMENT_TWO_CHAR>\(+[^*(]* {
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\*+[^)*]* {
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

    const char* numStart = yytext + 1;
    int base = 10;

    if (yytext[1] == '$') {
        base = 16;
        numStart = yytext + 2;
    } else if (yytext[1] == '&') {
        base = 8;
        numStart = yytext + 2;
    } else if (yytext[1] == '%') {
        base = 2;
        numStart = yytext + 2;
    }

    stringBuf.append(string(1, (char) strtoll(numStart, nullptr, base)));
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
<STRING><<EOF>> {
    Console::Error("Line " + std::to_string(stringBuf.getStartLine()) + ": unterminated string");
    BEGIN(INITIAL);
}


<STRING_CONT>\' {
    BEGIN(STRING);
}
<STRING_CONT>{CONTROL_CODE} {
    const char* numStart = yytext + 1;
    int base = 10;
    if (yytext[1] == '$') {
        base = 16;
        numStart = yytext + 2;
    } else if (yytext[1] == '&') {
        base = 8;
        numStart = yytext + 2;
    } else if (yytext[1] == '%') {
        base = 2;
        numStart = yytext + 2;
    }

    stringBuf.append(string(1, (char) strtoll(numStart, nullptr, base)));
}
<STRING_CONT>{CONTROL_CARET_CODE} {
    stringBuf.append(string(1, (char) (toupper(yytext[1]) - 'A' + 1)));
}
<STRING_CONT>(.|\n) {
    yyless(0);
    Console::Log("STRING: " + stringBuf.current());
    BEGIN(INITIAL);
}
<STRING_CONT><<EOF>> {
    Console::Log("STRING: " + stringBuf.current());
    BEGIN(INITIAL);
}

{ID}                    { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
<*>. {
    Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN CHARACTER: " + string(yytext));
}

%%
