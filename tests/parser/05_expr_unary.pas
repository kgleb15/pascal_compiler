{ Унарные операторы: -a, +a, - -a, -a * b, -a + b, not not a }

program ExprUnary;
var
  a, b, r1, r2, r3, r4, r5: integer;
  f: boolean;
begin
  r1 := -a;
  r2 := +a;
  r3 := - -a;
  r4 := -a * b;
  r5 := -a + b;
  f := not not f
end.