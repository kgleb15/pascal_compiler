{ Логические операторы: and, or, not и смесь со сравнениями без скобок }

program ExprLogic;
var
  a, b, c: integer;
  f: boolean;
begin
  f := a < b and c;
  f := f or not f;
  f := not (a = b) and (b <> c)
end.