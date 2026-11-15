{ Левая ассоциативность: a - b - c = (a - b) - c, a / b / c = (a / b) / c }

program ExprLeftAssoc;
var
  a, b, c, r1, r2, r3: integer;
begin
  r1 := a - b - c;
  r2 := a / b / c;
  r3 := a div b mod c
end.