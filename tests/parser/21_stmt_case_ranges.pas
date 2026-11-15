{ case по диапазонам, ветки else и otherwise, точка с запятой перед end и без }

program StmtCaseRanges;
var
  a, b: integer;
begin
  case a of
    1..5: b := 1;
    6..10: b := 2;
    else b := 0
  end;
  case a of
    -5..-1: b := 3;
    0: b := 4;
    otherwise b := 5
  end
end.