{ Скобки меняют порядок вычислений: (a + b) * c, ((a)), a - (b - c) }

program ExprParens;
var
  a, b, c, r1, r2, r3: integer;
begin
  r1 := (a + b) * c;
  r2 := ((a));
  r3 := a - (b - c)
end.