{ Висячий else: else относится к ближайшему if }

program StmtIfDangling;
var
  a, x: integer;
begin
  if a > 0 then
    if a > 1 then
      x := 1
    else
      x := 2
end.