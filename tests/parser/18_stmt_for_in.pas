{ Цикл for по элементам перечисления: for i in a }

program StmtForIn;
var
  i: integer;
  a: array[1..3] of integer;
begin
  for i in a do
    i := i + 1;
  for i in a do
  begin
    i := 1
  end
end.