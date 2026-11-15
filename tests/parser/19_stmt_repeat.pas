{ Цикл repeat..until: несколько операторов в теле и вложенный repeat }

program StmtRepeat;
var
  i, j: integer;
begin
  repeat
    i := i + 1;
    j := j * 2
  until i > 10;
  repeat
    repeat
      i := i - 1
    until i = 0
  until j = 0
end.