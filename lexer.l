%option noyywrap
%option never-interactive
%option yylineno
%option c++
%option case-insensitive


%{
    #include <string>
    #include <algorithm>
    #include <cctype>
    #include "core/Console.h"
    #include "core/Buffer.h"
    #include <cstdlib>

    using std::string;

    string toLower(const string& s);
%}


/* ----------------------------
   States
   ---------------------------- */

%x COMMENT_ONE_CHAR
%x COMMENT_TWO_CHAR
%x STRING
%x STRING_CONT


/* ----------------------------
   Macros
   ---------------------------- */

DIGIT               [0-9]
HEX_DIGIT           [0-9A-Fa-f]
OCT_DIGIT           [0-7]
BIN_DIGIT           [01]

SCALE               [Ee][+-]?{DIGIT}+
REAL                ({DIGIT}+\.{DIGIT}+{SCALE}?)|({DIGIT}+{SCALE})

LETTER              [A-Za-z_]
ID                  {LETTER}({LETTER}|{DIGIT})*

CONTROL_CODE        \#({DIGIT}+|\${HEX_DIGIT}+|\&{OCT_DIGIT}+|\%{BIN_DIGIT}+)
CONTROL_CARET_CODE  \^[A-Za-z]

%%

%{
    int commentDepth = 0;
    bool isDirective = false;
    Buffer commentBuf;
    Buffer stringBuf;
%}


    /* ---------- Ключевые слова  ---------- */
array           { Console::Log(lineno(), "KEYWORD: array"); }
asm             { Console::Log(lineno(), "KEYWORD: asm"); }
absolute        { Console::Log(lineno(), "KEYWORD: absolute"); }
begin           { Console::Log(lineno(), "KEYWORD: begin"); }
case            { Console::Log(lineno(), "KEYWORD: case"); }
const           { Console::Log(lineno(), "KEYWORD: const"); }
constructor     { Console::Log(lineno(), "KEYWORD: constructor"); }
destructor      { Console::Log(lineno(), "KEYWORD: destructor"); }
do              { Console::Log(lineno(), "KEYWORD: do"); }
downto          { Console::Log(lineno(), "KEYWORD: downto"); }
else            { Console::Log(lineno(), "KEYWORD: else"); }
end             { Console::Log(lineno(), "KEYWORD: end"); }
file            { Console::Log(lineno(), "KEYWORD: file"); }
for             { Console::Log(lineno(), "KEYWORD: for"); }
function        { Console::Log(lineno(), "KEYWORD: function"); }
goto            { Console::Log(lineno(), "KEYWORD: goto"); }
if              { Console::Log(lineno(), "KEYWORD: if"); }
implementation  { Console::Log(lineno(), "KEYWORD: implementation"); }
inherited       { Console::Log(lineno(), "KEYWORD: inherited"); }
interface       { Console::Log(lineno(), "KEYWORD: interface"); }
label           { Console::Log(lineno(), "KEYWORD: label"); }
nil             { Console::Log(lineno(), "KEYWORD: nil"); }
object          { Console::Log(lineno(), "KEYWORD: object"); }
of              { Console::Log(lineno(), "KEYWORD: of"); }
operator        { Console::Log(lineno(), "KEYWORD: operator"); }
procedure       { Console::Log(lineno(), "KEYWORD: procedure"); }
program         { Console::Log(lineno(), "KEYWORD: program"); }
record          { Console::Log(lineno(), "KEYWORD: record"); }
repeat          { Console::Log(lineno(), "KEYWORD: repeat"); }
reintroduce     { Console::Log(lineno(), "KEYWORD: reintroduce"); }
self            { Console::Log(lineno(), "KEYWORD: self"); }
set             { Console::Log(lineno(), "KEYWORD: set"); }
string          { Console::Log(lineno(), "KEYWORD: string"); }
then            { Console::Log(lineno(), "KEYWORD: then"); }
to              { Console::Log(lineno(), "KEYWORD: to"); }
type            { Console::Log(lineno(), "KEYWORD: type"); }
unit            { Console::Log(lineno(), "KEYWORD: unit"); }
until           { Console::Log(lineno(), "KEYWORD: until"); }
uses            { Console::Log(lineno(), "KEYWORD: uses"); }
var             { Console::Log(lineno(), "KEYWORD: var"); }
while           { Console::Log(lineno(), "KEYWORD: while"); }
with            { Console::Log(lineno(), "KEYWORD: with"); }

    /* ---------- Специфичные для Object Pascal ---------- */
class            { Console::Log(lineno(), "KEYWORD: class"); }
dispinterface    { Console::Log(lineno(), "KEYWORD: dispinterface"); }
except           { Console::Log(lineno(), "KEYWORD: except"); }
exports         { Console::Log(lineno(), "KEYWORD: exports"); }
finalization    { Console::Log(lineno(), "KEYWORD: finalization"); }
finally          { Console::Log(lineno(), "KEYWORD: finally"); }
initialization  { Console::Log(lineno(), "KEYWORD: initialization"); }
inline           { Console::Log(lineno(), "KEYWORD: inline"); }
library         { Console::Log(lineno(), "KEYWORD: library"); }
on               { Console::Log(lineno(), "KEYWORD: on"); }
out              { Console::Log(lineno(), "KEYWORD: out"); }
packed          { Console::Log(lineno(), "KEYWORD: packed"); }
property        { Console::Log(lineno(), "KEYWORD: property"); }
raise            { Console::Log(lineno(), "KEYWORD: raise"); }
resourcestring  { Console::Log(lineno(), "KEYWORD: resourcestring"); }
threadvar       { Console::Log(lineno(), "KEYWORD: threadvar"); }
try              { Console::Log(lineno(), "KEYWORD: try"); }

    /* ---------- Ключевые слова, являющиеся операторами ---------- */
and             { Console::Log(lineno(), "OPERATOR: and"); }
as              { Console::Log(lineno(), "OPERATOR: as"); }
div             { Console::Log(lineno(), "OPERATOR: div"); }
in              { Console::Log(lineno(), "OPERATOR: in"); }
or              { Console::Log(lineno(), "OPERATOR: or"); }
mod             { Console::Log(lineno(), "OPERATOR: mod"); }
not             { Console::Log(lineno(), "OPERATOR: not"); }
or              { Console::Log(lineno(), "OPERATOR: or"); }
is              { Console::Log(lineno(), "OPERATOR: is"); }
shl             { Console::Log(lineno(), "OPERATOR: shl"); }
shr             { Console::Log(lineno(), "OPERATOR: shr"); }
xor             { Console::Log(lineno(), "OPERATOR: xor"); }

    /* ---------- Операторы ---------- */
    /* ---------- Длинные операторы ---------- */
\<\<    { Console::Log(lineno(), "OPERATOR: <<"); }
\>\>    { Console::Log(lineno(), "OPERATOR: >>"); }
\*\*    { Console::Log(lineno(), "OPERATOR: **"); }
\<\>    { Console::Log(lineno(), "OPERATOR: <>"); }
\>\<    { Console::Log(lineno(), "OPERATOR: ><"); }
\<\=    { Console::Log(lineno(), "OPERATOR: <="); }
\>\=    { Console::Log(lineno(), "OPERATOR: >="); }
\:\=    { Console::Log(lineno(), "OPERATOR: :="); }
\+\=    { Console::Log(lineno(), "OPERATOR: +="); }
\-\=    { Console::Log(lineno(), "OPERATOR: -="); }
\*\=    { Console::Log(lineno(), "OPERATOR: *="); }
\/\=    { Console::Log(lineno(), "OPERATOR: /="); }
\(\.    { Console::Log(lineno(), "OPERATOR: (."); }
\.\)    { Console::Log(lineno(), "OPERATOR: .)"); }
\.\.    { Console::Log(lineno(), "OPERATOR: .."); }

    /* ---------- Односимвольные операторы ---------- */
\+  { Console::Log(lineno(), "OPERATOR: +"); }
\-  { Console::Log(lineno(), "OPERATOR: -"); }
\*  { Console::Log(lineno(), "OPERATOR: *"); }
\/  { Console::Log(lineno(), "OPERATOR: /"); }
\=  { Console::Log(lineno(), "OPERATOR: ="); }
\<  { Console::Log(lineno(), "OPERATOR: <"); }
\>  { Console::Log(lineno(), "OPERATOR: >"); }
\[  { Console::Log(lineno(), "OPERATOR: ["); }
\]  { Console::Log(lineno(), "OPERATOR: ]"); }
\;  { Console::Log(lineno(), "DELIMITER: ;"); }
\.  { Console::Log(lineno(), "OPERATOR: ."); }
\,  { Console::Log(lineno(), "DELIMITER: ,"); }
\(  { Console::Log(lineno(), "OPERATOR: ("); }
\)  { Console::Log(lineno(), "OPERATOR: )"); }
\:  { Console::Log(lineno(), "OPERATOR: :"); }
\^  { Console::Log(lineno(), "OPERATOR: ^"); }
\@  { Console::Log(lineno(), "OPERATOR: @"); }


        /* ---------- Числовые константы ---------- */
\${HEX_DIGIT}+ {
    long long value = strtoll(yytext + 1, nullptr, 16);
    Console::LogInt(lineno(), "HEX_INT", value);
}

\&{OCT_DIGIT}+ {
    long long value = strtoll(yytext + 1, nullptr, 8);
    Console::LogInt(lineno(), "OCT_INT", value);
}

\%{BIN_DIGIT}+ {
    long long value = strtoll(yytext + 1, nullptr, 2);
    Console::LogInt(lineno(), "BIN_INT", value);
}

{REAL} {
    double value = strtod(yytext, nullptr);
    Console::LogReal(lineno(), "REAL", value);
}

{DIGIT}+ {
    long long value = strtoll(yytext, nullptr, 10);
    Console::LogInt(lineno(), "INTEGER", value);
}


    /* ---------- Комментарии ---------- */
\/\/[^\n]* {
    Console::Log(lineno(), "COMMENT: " + string(yytext));
}


\{ {
    commentDepth = 1;
    commentBuf.reset();
    commentBuf.setStartLine(lineno());
    isDirective = false;
    BEGIN(COMMENT_ONE_CHAR);
}
\{\$ {
    commentDepth = 1;
    commentBuf.reset();
    commentBuf.setStartLine(lineno());
    commentBuf.append("$");
    isDirective = true;
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
        Console::Log(commentBuf.getStartLine(), string(isDirective ? "DIRECTIVE" : "COMMENT") + ": {" + commentBuf.current() + "}");
        BEGIN(INITIAL);
    } else {
        commentBuf.append(yytext);
    }
}
<COMMENT_ONE_CHAR><<EOF>> {
    Console::Error(commentBuf.getStartLine(), "unclosed comment '{'");
    BEGIN(INITIAL);
}


\(\* {
    commentDepth = 1;
    commentBuf.reset();
    commentBuf.setStartLine(lineno());
    BEGIN(COMMENT_TWO_CHAR);
}
<COMMENT_TWO_CHAR>[^*(]+ {
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>[*(] {
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\(\* {
    commentDepth++;
    commentBuf.append(yytext);
}
<COMMENT_TWO_CHAR>\*\) {
    commentDepth--;
    if (commentDepth == 0) {
        Console::Log(commentBuf.getStartLine(), "COMMENT: (*" + commentBuf.current() + "*)");
        BEGIN(INITIAL);
    } else {
        commentBuf.append(yytext);
    }
}
<COMMENT_TWO_CHAR><<EOF>> {
    Console::Error(commentBuf.getStartLine(), "unclosed comment '(*'");
    BEGIN(INITIAL);
}


    /* ---------- Строковые константы ---------- */
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
{CONTROL_CARET_CODE}/[^A-Za-z0-9_] {
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
    Console::Error(stringBuf.getStartLine(), "string contains a line break");
    BEGIN(INITIAL);
}
<STRING><<EOF>> {
    Console::Error(stringBuf.getStartLine(), "unterminated string");
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
<STRING_CONT>{CONTROL_CARET_CODE}/[^A-Za-z0-9_] {
    stringBuf.append(string(1, (char) (toupper(yytext[1]) - 'A' + 1)));
}
<STRING_CONT>(.|\n) {
    yyless(0);
    Console::Log(stringBuf.getStartLine(), "STRING: " + stringBuf.current());
    BEGIN(INITIAL);
}
<STRING_CONT><<EOF>> {
    Console::Log(stringBuf.getStartLine(), "STRING: " + stringBuf.current());
    BEGIN(INITIAL);
}


    /* ---------- Идентификаторы ---------- */
{ID} {
    Console::Log(lineno(), "IDENTIFIER: " + toLower(yytext));
}

\&{ID} {
    Console::Log(lineno(), "IDENTIFIER: " + toLower(yytext + 1));
}


    /* ------------------------------------- */
[ \t\r\n]+ { }

\# {
    Console::Error(lineno(), "'#' must be followed by a character code");
}
\$ {
    Console::Error(lineno(), "hex digits expected after '$'");
}
\% {
    Console::Error(lineno(), "binary digits expected after '%'");
}
\& {
    Console::Error(lineno(), "octal digits or identifier expected after '&'");
}
<*>. {
    Console::Error(lineno(), "UNKNOWN CHARACTER: " + string(yytext));
}


%%


string toLower(const string& s) {
    string lowStr = s;
    std::transform(lowStr.begin(), lowStr.end(), lowStr.begin(), [](unsigned char c) { return std::tolower(c); });
    return lowStr;
}
