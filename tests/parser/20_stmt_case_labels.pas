{ case по меткам: числа, идентификаторы, строки и списки меток через запятую }

program StmtCaseLabels;
var
  a, b: integer;
begin
  case a of
    1: b := 1;
    2, 3, 4: b := 2;
    'x': b := 3;
    red: b := 4
  end
end.