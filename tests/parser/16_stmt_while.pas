{ Цикл while с телом из одного оператора и из begin..end, вложенный while }

program StmtWhile;
var
  i, j: integer;
begin
  while i < 10 do
    i := i + 1;
  while i > 0 do
  begin
    j := 0;
    while j < i do
      j := j + 1;
    i := i - 1
  end
end.