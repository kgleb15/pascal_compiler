{ Условный оператор: if, if-else, цепочка else if и тело в begin..end }

program StmtIf;
var
  a, b: integer;
begin
  if a > 0 then
    b := 1;
  if a > 0 then
    b := 1
  else
    b := 2;
  if a = 1 then
    b := 1
  else if a = 2 then
    b := 2
  else
    b := 3;
  if a > 0 then
  begin
    b := 1;
    a := 2
  end
end.