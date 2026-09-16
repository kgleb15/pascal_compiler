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


    /* ---------- Ключевые слова  ---------- */
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

    /* ---------- ООП ---------- */
(?i:class)          { Console::Log("KEYWORD: class"); }
(?i:object)         { Console::Log("KEYWORD: object"); }
(?i:record)         { Console::Log("KEYWORD: record"); }
(?i:constructor)    { Console::Log("KEYWORD: constructor"); }
(?i:destructor)     { Console::Log("KEYWORD: destructor"); }
(?i:inherited)      { Console::Log("KEYWORD: inherited"); }
(?i:property)       { Console::Log("KEYWORD: property"); }
(?i:self)           { Console::Log("KEYWORD: self"); }
(?i:helper)         { Console::Log("KEYWORD: helper"); }

    /* ---------- Видимость ---------- */
(?i:private)        { Console::Log("KEYWORD: private"); }
(?i:protected)      { Console::Log("KEYWORD: protected"); }
(?i:public)         { Console::Log("KEYWORD: public"); }
(?i:published)      { Console::Log("KEYWORD: published"); }
(?i:automated)      { Console::Log("KEYWORD: automated"); }
(?i:strict)         { Console::Log("KEYWORD: strict"); }

    /* ---------- Модификаторы методов ---------- */
(?i:virtual)        { Console::Log("KEYWORD: virtual"); }
(?i:override)       { Console::Log("KEYWORD: override"); }
(?i:abstract)       { Console::Log("KEYWORD: abstract"); }
(?i:dynamic)        { Console::Log("KEYWORD: dynamic"); }
(?i:overload)       { Console::Log("KEYWORD: overload"); }
(?i:reintroduce)    { Console::Log("KEYWORD: reintroduce"); }
(?i:message)        { Console::Log("KEYWORD: message"); }
(?i:static)         { Console::Log("KEYWORD: static"); }
(?i:inline)         { Console::Log("KEYWORD: inline"); }
(?i:assembler)      { Console::Log("KEYWORD: assembler"); }
(?i:register)       { Console::Log("KEYWORD: register"); }
(?i:cdecl)          { Console::Log("KEYWORD: cdecl"); }
(?i:stdcall)        { Console::Log("KEYWORD: stdcall"); }
(?i:safecall)       { Console::Log("KEYWORD: safecall"); }
(?i:pascal)         { Console::Log("KEYWORD: pascal"); }
(?i:export)         { Console::Log("KEYWORD: export"); }
(?i:varargs)        { Console::Log("KEYWORD: varargs"); }

    /* ---------- Свойства ---------- */
(?i:read)           { Console::Log("KEYWORD: read"); }
(?i:write)          { Console::Log("KEYWORD: write"); }
(?i:default)        { Console::Log("KEYWORD: default"); }
(?i:stored)         { Console::Log("KEYWORD: stored"); }
(?i:index)          { Console::Log("KEYWORD: index"); }
(?i:nodefault)      { Console::Log("KEYWORD: nodefault"); }
(?i:readonly)       { Console::Log("KEYWORD: readonly"); }
(?i:writeonly)      { Console::Log("KEYWORD: writeonly"); }
(?i:implements)     { Console::Log("KEYWORD: implements"); }
(?i:dispid)         { Console::Log("KEYWORD: dispid"); }
(?i:name)           { Console::Log("KEYWORD: name"); }

    /* ---------- Исключения ---------- */
(?i:try)            { Console::Log("KEYWORD: try"); }
(?i:except)         { Console::Log("KEYWORD: except"); }
(?i:finally)        { Console::Log("KEYWORD: finally"); }
(?i:raise)          { Console::Log("KEYWORD: raise"); }
(?i:on)             { Console::Log("KEYWORD: on"); }
(?i:at)             { Console::Log("KEYWORD: at"); }

    /* ---------- Управляющие конструкции ---------- */
(?i:if)             { Console::Log("KEYWORD: if"); }
(?i:then)           { Console::Log("KEYWORD: then"); }
(?i:else)           { Console::Log("KEYWORD: else"); }
(?i:case)           { Console::Log("KEYWORD: case"); }
(?i:of)             { Console::Log("KEYWORD: of"); }
(?i:for)            { Console::Log("KEYWORD: for"); }
(?i:to)             { Console::Log("KEYWORD: to"); }
(?i:downto)         { Console::Log("KEYWORD: downto"); }
(?i:do)             { Console::Log("KEYWORD: do"); }
(?i:while)          { Console::Log("KEYWORD: while"); }
(?i:repeat)         { Console::Log("KEYWORD: repeat"); }
(?i:until)          { Console::Log("KEYWORD: until"); }
(?i:with)           { Console::Log("KEYWORD: with"); }
(?i:goto)           { Console::Log("KEYWORD: goto"); }

    /* ---------- Логические и битовые ---------- */
(?i:and)            { Console::Log("KEYWORD: and"); }
(?i:or)             { Console::Log("KEYWORD: or"); }
(?i:not)            { Console::Log("KEYWORD: not"); }
(?i:xor)            { Console::Log("KEYWORD: xor"); }
(?i:shl)            { Console::Log("KEYWORD: shl"); }
(?i:shr)            { Console::Log("KEYWORD: shr"); }
(?i:div)            { Console::Log("KEYWORD: div"); }
(?i:mod)            { Console::Log("KEYWORD: mod"); }
(?i:in)             { Console::Log("KEYWORD: in"); }
(?i:is)             { Console::Log("KEYWORD: is"); }
(?i:as)             { Console::Log("KEYWORD: as"); }

    /* ---------- Константы ---------- */
(?i:true)           { Console::Log("KEYWORD: true"); }
(?i:false)          { Console::Log("KEYWORD: false"); }
(?i:nil)            { Console::Log("KEYWORD: nil"); }

    /* ---------- Типы-заготовки и прочее ---------- */
(?i:array)          { Console::Log("KEYWORD: array"); }
(?i:set)            { Console::Log("KEYWORD: set"); }
(?i:file)           { Console::Log("KEYWORD: file"); }
(?i:pointer)        { Console::Log("KEYWORD: pointer"); }
(?i:packed)         { Console::Log("KEYWORD: packed"); }
(?i:threadvar)      { Console::Log("KEYWORD: threadvar"); }
(?i:resourcestring) { Console::Log("KEYWORD: resourcestring"); }
(?i:dispinterface)  { Console::Log("KEYWORD: dispinterface"); }
(?i:deprecated)     { Console::Log("KEYWORD: deprecated"); }
(?i:experimental)   { Console::Log("KEYWORD: experimental"); }
(?i:platform)       { Console::Log("KEYWORD: platform"); }

    /* ---------- Операторы ---------- */
    /* ---------- Длинные операторы (2+ символа)  ---------- */
":="              { Console::Log("OPERATOR: :="); }
"<>"              { Console::Log("OPERATOR: <>"); }
"<="              { Console::Log("OPERATOR: <="); }
">="              { Console::Log("OPERATOR: >="); }
".."              { Console::Log("OPERATOR: .."); }

    /* ---------- Односимвольные операторы ---------- */
"+"               { Console::Log("OPERATOR: +"); }
"-"               { Console::Log("OPERATOR: -"); }
"*"               { Console::Log("OPERATOR: *"); }
"/"               { Console::Log("OPERATOR: /"); }
"="               { Console::Log("OPERATOR: ="); }
"<"               { Console::Log("OPERATOR: <"); }
">"               { Console::Log("OPERATOR: >"); }
";"               { Console::Log("OPERATOR: ;"); }
","               { Console::Log("OPERATOR: ,"); }
":"               { Console::Log("OPERATOR: :"); }
"."               { Console::Log("OPERATOR: ."); }
"("               { Console::Log("OPERATOR: ("); }
")"               { Console::Log("OPERATOR: )"); }
"["               { Console::Log("OPERATOR: ["); }
"]"               { Console::Log("OPERATOR: ]"); }
"^"               { Console::Log("OPERATOR: ^"); }
"@"               { Console::Log("OPERATOR: @"); }

{DIGIT}+                { Console::Log("NUMBER: " + string(yytext)); }
{ID}                    { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
.                       {
                            /* Пример вывода ошибки (с номером строки через lineno()) */
                            Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN: " + string(yytext));
                        }

%%
