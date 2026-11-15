{ Вызов подпрограммы и метода как отдельный оператор: p; p(); p(1, 2); obj.m; obj.m(1) }

program StmtCalls;
var
  o: TObj;
begin
  p;
  p();
  p(1, 2);
  o.m;
  o.m(1)
end.