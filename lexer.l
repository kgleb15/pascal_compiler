    /* не поддерживаем сканирование нескольких файлов */
%option noyywrap
    /* не вводим тексты с клавиатуры */
%option never-interactive
    /* автоматическое отслеживание номера строки */
%option yylineno
%option c++
%option case-insensitive


%{
    #include <string>
    #include <cctype>   // для tolower / toupper
    #include "core/Console.h"
    #include "core/Buffer.h"
    #include "parser.hpp"   // коды токенов и yylval
    #include <cstdlib>  // функции общего назначения
    #include <cerrno>   // для макроса errno
    using std::string;

    string toLower(const string& s);
    void logIntToken(int line, const char* kind, const char* lexeme, const char* digits, int base);
    void logRealToken(int line, const char* lexeme);
%}


/* Состояния */

%x COMMENT_ONE_CHAR
%x COMMENT_TWO_CHAR
%x STRING_BODY
%x STRING_CONT


/* Макросы */

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
array           { return ARRAY; }
asm             { return ASM; }
absolute        { return ABSOLUTE; }
begin           { return BEGIN_KW; }
case            { return CASE; }
const           { return CONST; }
constructor     { return CONSTRUCTOR; }
destructor      { return DESTRUCTOR; }
do              { return DO; }
downto          { return DOWNTO; }
else            { return ELSE; }
end             { return END; }
file            { return FILE_KW; }
for             { return FOR; }
forward         { return FORWARD; }
function        { return FUNCTION; }
goto            { return GOTO; }
if              { return IF; }
inherited       { return INHERITED; }
label           { return LABEL; } /**/
nil             { return NIL; }
object          { return OBJECT; }
of              { return OF; }
operator        { return OPERATOR; }
procedure       { return PROCEDURE; }
program         { return PROGRAM; }
repeat          { return REPEAT; }
reintroduce     { return REINTRODUCE; }
self            { return SELF; }
string          { return STRING; }
then            { return THEN; }
to              { return TO; }
type            { return TYPE; }
unit            { return UNIT; }
until           { return UNTIL; }
uses            { return USES; }
var             { return VAR; }
while           { return WHILE; }

    /* ---------- Специфичные для Object Pascal ---------- */
class           { return CLASS; }
otherwise       { return OTHERWISE; }
out             { return OUT; }
packed          { return PACKED; }
property        { return PROPERTY; }

    /* ---------- Ключевые слова, являющиеся операторами ---------- */
and             { return AND; }
as              { return AS; }
div             { return DIV; }
in              { return IN; }
or              { return OR; }
mod             { return MOD; }
not             { return NOT; }
is              { return IS; }
shl             { return SHL; }
shr             { return SHR; }
xor             { return XOR; }

    /* ---------- Операторы ---------- */
    /* ---------- Длинные операторы ---------- */
\<\<    { return SHL; }
\>\>    { return SHR; }
\*\*    { return POWER; }
\<\>    { return NOT_EQUAL; }
\<\=    { return LESS_OR_EQUAL; }
\>\=    { return GREATER_OR_EQUAL; }
\:\=    { return ASSIGN; }
\+\=    { return ADD_ASSIGN; }
\-\=    { return SUB_ASSIGN; }
\*\=    { return MUL_ASSIGN; }
\/\=    { return DIV_ASSIGN; }
\(\.    { return '['; }
\.\)    { return ']'; }
\.\.    { return RANGE; }

    /* ---------- Односимвольные операторы ---------- */
\+  { return '+'; }
\-  { return '-'; }
\*  { return '*'; }
\/  { return '/'; }
\=  { return '='; }
\<  { return '<'; }
\>  { return '>'; }
\[  { return '['; }
\]  { return ']'; }
\;  { return ';'; }
\.  { return '.'; }
\,  { return ','; }
\(  { return '('; }
\)  { return ')'; }
\:  { return ':'; }
\^  { return '^'; }
\@  { return '@'; }


        /* ---------- Числовые константы ---------- */
\${HEX_DIGIT}+ {
    logIntToken(lineno(), "HEX_INT", yytext, yytext + 1, 16);
    return INT_L;
}

\&{OCT_DIGIT}+ {
    logIntToken(lineno(), "OCT_INT", yytext, yytext + 1, 8);
    return INT_L;
}

\%{BIN_DIGIT}+ {
    logIntToken(lineno(), "BIN_INT", yytext, yytext + 1, 2);
    return INT_L;
}

{REAL} {
    logRealToken(lineno(), yytext);
    return REAL_L;
}

{DIGIT}+ {
    logIntToken(lineno(), "INTEGER", yytext, yytext, 10);
    return INT_L;
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
    BEGIN(STRING_BODY);
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


<STRING_BODY>[^'\n]* {
    stringBuf.append(yytext);
}
<STRING_BODY>\'\' {
    stringBuf.append("'");
}
<STRING_BODY>\' {
    BEGIN(STRING_CONT);
}
<STRING_BODY>\n {
    Console::Error(stringBuf.getStartLine(), "string contains a line break");
    BEGIN(INITIAL);
}
<STRING_BODY><<EOF>> {
    Console::Error(stringBuf.getStartLine(), "unterminated string");
    BEGIN(INITIAL);
}


<STRING_CONT>\' {
    BEGIN(STRING_BODY);
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
    unput(yytext[0]); // возвращаем символ обратно во входной поток
    yylval.f_liter_str = new string(stringBuf.current());
    BEGIN(INITIAL);
    return STRING_L;
}
<STRING_CONT><<EOF>> {
    yylval.f_liter_str = new string(stringBuf.current());
    BEGIN(INITIAL);
    return STRING_L;
}


    /* ---------- Идентификаторы ---------- */
{ID} {
    yylval.f_id = new string(toLower(yytext));
    return ID;
}

\&{ID} {
    yylval.f_id = new string(toLower(yytext + 1));
    return ID;
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
    for (int i = 0; i < lowStr.size(); i++)
        lowStr[i] = std::tolower(lowStr[i]);
    return lowStr;
}

void logIntToken(int line, const char* kind, const char* lexeme, const char* digits, int base) {
    errno = 0;
    long long v = strtoll(digits, nullptr, base);
    if (errno == ERANGE)
        Console::Error(line, string("integer literal is out of range: ") + lexeme);
    yylval.f_liter_int = v;
}

void logRealToken(int line, const char* lexeme) {
    errno = 0;
    double v = strtod(lexeme, nullptr);
    if (errno == ERANGE)
        Console::Error(line, string("real literal is out of range: ") + lexeme);
    yylval.f_liter_float = v;
}
