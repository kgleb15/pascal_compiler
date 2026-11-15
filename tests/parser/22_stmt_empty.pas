{ Пустые и составные операторы: пустые ;, begin end, вложенные begin..end }

program StmtEmpty;
var
  a: integer;
begin
  ;;
  begin end;
  begin begin a := 1 end end;
  if a > 0 then
  else
    a := 2
end.