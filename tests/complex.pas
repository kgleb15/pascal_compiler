// Некоторые ключевые слова
and in mod then xor as class inline try

// Идентификаторы
x y z index name read MyVar _private var123 CamelCase snake_case
&if &begin &do &else

// Некоторые операторы
<< += <> >< <=
+ / < ] ; . ( ^


Program Test;
x = 42;
&if x = 42 then
begin
    y := x + 1;
    x := x - 1;
end
else
begin
    y := 0;
    x += 1; x -= 1;
    a := b << 2; e := f * 2;
    &begin := 1; &do := 2; &else := &17;
    type PInt = ^Integer;
    p^.x := 1;
    var index, name, read, &write, &class, &else: integer;
end;

0
1
255
999999999
0234
000000123

// Шестнадцатеричные
$0 $1
$FF
$ff
$41
$DEADBEEF

// Восьмеричные
&0 &7
&17
&777

// Двоичные
%0 %1
%1111
%1000001

// Вещественные
0.5 3.14 5e2.5e2
500.000
5E2 5e2
5E+2
3.14E-2
1E-300
1E+300


// границы диапазонов
a1 := 9223372036854775807;
a2 := 9223372036854775808;  // ошибка
a3 := $FFFFFFFFFFFFFFF;
a4 := $FFFFFFFFFFFFFFFF;

r1 := 1E-300;
r2 := 1E-500;   // ошибка
r3 := 1E500;    // ошибка

// однострочный комментарий
h := 1;
hh := 11; // после кода


{ комментарий в фигурных скобках }
i := 2; { после текста }
{ 123
    многострочный комментарий
    на несколько строк
}



(* комментарий в круглых скобках *)
j := 3; (* после текста *)
(* 123
    многострочный комментарий
    на несколько строк
*)



{ comment 1 (* comment 2 *) }
(* comment 1 { comment 2 } *)
(* comment 1 (* comment 2 *) *)
{ comment 1 { comment 2 } }
// comment 1 (* comment 2 *)
(* a **)
(((* x *) y *) z *)

{$IOCHECKS ON}
{$MODE OBJFPC}

// С ошибками

{ comment 1 } comment 2 }
(* comment 1 ( * comment 2 *) comment 3 *)
{ незакрытый комментарий в фигурных скобках

q := 'Hello, world!';
r := '';
s := 'a'; ss := 'b';


t := 'it''s a test';
u := '''';
v := '''quoted''';


w := #77;
x := #13#10;
pp := #$41;
rr := #&101;
ss := #%1000001;


y := 'Tab:'#9'End';
z := 'Line1'#13#10'Line2';
zz := 'a'#62'b';


zzz := 'a' #62 'b';

// Caret-нотация
kk := ^Z;
kkk := ^ZZ; // >1 символа


aa := 'contains // not a comment';
bb := 'contains { not a comment }';
cc := 'contains (* not a comment *)';
dd := '42 and 3.14';


ff := #300;
gg := #abc;
q  := 'abc

q := 'Hello, world!';
r := '';
s := 'a'; ss := 'b';


t := 'it''s a test';
u := '''';
v := '''quoted''';


w := #77;
x := #13#10;
pp := #$41;
rr := #&101;
ss := #%1000001;


y := 'Tab:'#9'End';
z := 'Line1'#13#10'Line2';
zz := 'a'#62'b';


zzz := 'a' #62 'b';

// Caret-нотация
kk := ^Z;
kkk := ^ZZ; // >1 символа


aa := 'contains // not a comment';
bb := 'contains { not a comment }';
cc := 'contains (* not a comment *)';
dd := '42 and 3.14';


ff := #300;
gg := #abc;
q  := 'abc
