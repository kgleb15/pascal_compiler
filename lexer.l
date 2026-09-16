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
(?i:exports)        { Console::Log("KEYWORD: exports"); }

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

    /* ---------- Turbo Pascal ---------- */
(?i:asm)            { Console::Log("KEYWORD: asm"); }
(?i:string)         { Console::Log("KEYWORD: string"); }
(?i:operator)       { Console::Log("KEYWORD: operator"); }

    /* ---------- Специфичные для Object Pascal ---------- */
(?i:out)            { Console::Log("KEYWORD: out"); }

    /* ---------- Устаревшие ключевые слова (Turbo Pascal / ранние Delphi) ----------
       Эти слова зарезервированы в Turbo Pascal и ранних версиях Delphi,
       но почти не встречаются в современном коде.

       near, far  — модификаторы указателей времён 16-битного DOS.
                    В современном Object Pascal не используются.
       local      — устаревший модификатор процедур/функций.
       varargs    — устаревший модификатор для функций с переменным
                    числом аргументов (заменён на array of const).
       ---------------------------------------------------------------------- */
(?i:near)           { Console::Log("KEYWORD: near"); }
(?i:far)            { Console::Log("KEYWORD: far"); }
(?i:local)          { Console::Log("KEYWORD: local"); }
(?i:varargs)        { Console::Log("KEYWORD: varargs"); }


    /* ============================================================
       ОСТОРОЖНО: exit, break, continue, new, dispose

       Формально это НЕ зарезервированные слова Object Pascal,
       а встроенные процедуры. В официальном списке key words
       их нет. Но в Delphi и Free Pascal они работают как
       «магические» процедуры — компилятор обрабатывает их
       особым образом, и синтаксически они ведут себя иначе,
       чем обычные идентификаторы.

       Возможны два подхода в лексере:

       1) Распознавать как KEYWORD (например, (?i:exit)).
          Плюс: парсер сразу видит, что это специальная
          конструкция, и может обработать её отдельно.
          Минус: в Pascal эти имена можно переопределить
          (объявить свою процедуру с именем exit) — тогда
          лексер ошибётся, потому что вызовет KEYWORD там,
          где на самом деле IDENTIFIER.

       2) Распознавать как IDENTIFIER.
          Плюс: лексер не берёт на себя лишнюю ответственность,
          а семантический анализ решает, «магическая» это
          процедура или нет.
          Минус: парсер должен уметь различать контекст
          (объявление vs вызов).

       Если считать их ключевыми словами нужно добавить правила (?i:exit) и т.п.
       Если нет — оставить как IDENTIFIER, это безопаснее.
       ============================================================ */
    /* ---------- Директивы и модификаторы ---------- */
(?i:sealed)         { Console::Log("KEYWORD: sealed"); }
(?i:dispose)        { Console::Log("KEYWORD: dispose"); }
(?i:exit)           { Console::Log("KEYWORD: exit"); }
(?i:new)            { Console::Log("KEYWORD: new"); }
(?i:break)          { Console::Log("KEYWORD: break"); }
(?i:continue)       { Console::Log("KEYWORD: continue"); }

    /* ---------- Операторы ---------- */
    /* ---------- Длинные операторы (2+ символа)  ---------- */
":="              { Console::Log("OPERATOR: :="); }
"<>"              { Console::Log("OPERATOR: <>"); }
"<="              { Console::Log("OPERATOR: <="); }
">="              { Console::Log("OPERATOR: >="); }
".."              { Console::Log("OPERATOR: .."); }
"**"              { Console::Log("OPERATOR: **"); }
"><"              { Console::Log("OPERATOR: ><"); }

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
    /* ---------- Escape-символ & (ВНИМАНИЕ, см. комментарий) ----------
       В Object Pascal & — это НЕ настоящий оператор, а escape-символ
       для идентификаторов, совпадающих с ключевыми словами:
           &type, &begin, &end, &class  →  обычные идентификаторы
       То есть «type» после & — это имя переменной, а не ключевое слово.

       Строго говоря, правильнее было бы обрабатывать & вместе с
       идентификатором, например: "&"?{ID} { ... IDENTIFIER ... }
       Но пока оставляем & как отдельный токен OPERATOR. Если в тестах встретится
       &type, лексер выдаст: OPERATOR: & , IDENTIFIER: type.
       При необходимости правило легко переделать на "&"?{ID}.
       ----------------------------------------------------------------- */
"&"               { Console::Log("OPERATOR: &"); }


{DIGIT}+                { Console::Log("NUMBER: " + string(yytext)); }
{ID}                    { Console::Log("IDENTIFIER: " + string(yytext)); }
[ \t\r\n]+              { /* ignore */ }
.                       {
                            /* Пример вывода ошибки (с номером строки через lineno()) */
                            Console::Error("Line " + std::to_string(lineno()) + ": UNKNOWN: " + string(yytext));
                        }

%%
