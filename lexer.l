%option noyywrap
%option never-interactive
%option yylineno
%option c++
%option case-insensitive

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
and             { Console::Log("KEYWORD: and"); }
array           { Console::Log("KEYWORD: array"); }
asm             { Console::Log("KEYWORD: asm"); }
begin           { Console::Log("KEYWORD: begin"); }
case            { Console::Log("KEYWORD: case"); }
const           { Console::Log("KEYWORD: const"); }
constructor     { Console::Log("KEYWORD: constructor"); }
destructor      { Console::Log("KEYWORD: destructor"); }
div             { Console::Log("KEYWORD: div"); }
do              { Console::Log("KEYWORD: do"); }
downto          { Console::Log("KEYWORD: downto"); }
else            { Console::Log("KEYWORD: else"); }
end             { Console::Log("KEYWORD: end"); }
file            { Console::Log("KEYWORD: file"); }
for             { Console::Log("KEYWORD: for"); }
function        { Console::Log("KEYWORD: function"); }
goto            { Console::Log("KEYWORD: goto"); }
if              { Console::Log("KEYWORD: if"); }
implementation  { Console::Log("KEYWORD: implementation"); }
in              { Console::Log("KEYWORD: in"); }
inherited       { Console::Log("KEYWORD: inherited"); }
interface       { Console::Log("KEYWORD: interface"); }
label           { Console::Log("KEYWORD: label"); }
mod             { Console::Log("KEYWORD: mod"); }
nil             { Console::Log("KEYWORD: nil"); }
not             { Console::Log("KEYWORD: not"); }
object          { Console::Log("KEYWORD: object"); }
of              { Console::Log("KEYWORD: of"); }
operator        { Console::Log("KEYWORD: operator"); }
or              { Console::Log("KEYWORD: or"); }
procedure       { Console::Log("KEYWORD: procedure"); }
program         { Console::Log("KEYWORD: program"); }
record          { Console::Log("KEYWORD: record"); }
repeat          { Console::Log("KEYWORD: repeat"); }
self            { Console::Log("KEYWORD: self"); }
set             { Console::Log("KEYWORD: set"); }
shl             { Console::Log("KEYWORD: shl"); }
shr             { Console::Log("KEYWORD: shr"); }
string          { Console::Log("KEYWORD: string"); }
then            { Console::Log("KEYWORD: then"); }
to              { Console::Log("KEYWORD: to"); }
type            { Console::Log("KEYWORD: type"); }
unit            { Console::Log("KEYWORD: unit"); }
until           { Console::Log("KEYWORD: until"); }
uses            { Console::Log("KEYWORD: uses"); }
var             { Console::Log("KEYWORD: var"); }
while           { Console::Log("KEYWORD: while"); }
with            { Console::Log("KEYWORD: with"); }
xor             { Console::Log("KEYWORD: xor"); }

    /* ---------- Специфичные для Object Pascal ---------- */
as               { Console::Log("KEYWORD: as"); }
class            { Console::Log("KEYWORD: class"); }
dispinterface    { Console::Log("KEYWORD: dispinterface"); }
except           { Console::Log("KEYWORD: except"); }
exports         { Console::Log("KEYWORD: exports"); }
finalization    { Console::Log("KEYWORD: finalization"); }
finally          { Console::Log("KEYWORD: finally"); }
initialization  { Console::Log("KEYWORD: initialization"); }
inline           { Console::Log("KEYWORD: inline"); }
is               { Console::Log("KEYWORD: is"); }
library         { Console::Log("KEYWORD: library"); }
on               { Console::Log("KEYWORD: on"); }
out              { Console::Log("KEYWORD: out"); }
packed          { Console::Log("KEYWORD: packed"); }
property        { Console::Log("KEYWORD: property"); }
raise            { Console::Log("KEYWORD: raise"); }
resourcestring  { Console::Log("KEYWORD: resourcestring"); }
threadvar       { Console::Log("KEYWORD: threadvar"); }
try              { Console::Log("KEYWORD: try"); }

    /* ---------- Операторы ---------- */
    /* ---------- Длинные операторы ---------- */
\<\<    { Console::Log("OPERATOR: <<"); }
\>\>    { Console::Log("OPERATOR: >>"); }
\*\*    { Console::Log("OPERATOR: **"); }
\<\>    { Console::Log("OPERATOR: <>"); }
\>\<    { Console::Log("OPERATOR: ><"); }
\<\=    { Console::Log("OPERATOR: <="); }
\>\=    { Console::Log("OPERATOR: >="); }
\:\=    { Console::Log("OPERATOR: :="); }
\+\=    { Console::Log("OPERATOR: +="); }
\-\=    { Console::Log("OPERATOR: -="); }
\*\=    { Console::Log("OPERATOR: *="); }
\/\=    { Console::Log("OPERATOR: /="); }
\(\.    { Console::Log("OPERATOR: (."); }
\.\)    { Console::Log("OPERATOR: .)"); }
\.\.        { Console::Log("OPERATOR: .."); }


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

{ID} {
    Console::Log("IDENTIFIER: " + string(yytext));
}

\&(and|array|asm|begin|case|const|constructor|destructor|div|do|downto|else|end|file|for|function|goto|if|implementation|in|inherited|interface|label|mod|nil|not|object|of|operator|or|procedure|program|record|repeat|self|set|shl|shr|string|then|to|type|unit|until|uses|var|while|with|xor|as|class|dispinterface|except|exports|finalization|finally|initialization|inline|is|library|on|out|packed|property|raise|resourcestring|threadvar|try) {
    Console::Log("IDENTIFIER: " + string(yytext + 1));
}


[ \t\r\n]+ { }
<*>. {
    Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN CHARACTER: " + string(yytext));
}

%%
