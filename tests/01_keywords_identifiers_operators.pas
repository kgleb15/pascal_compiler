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