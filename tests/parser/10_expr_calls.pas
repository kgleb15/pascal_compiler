{ Вызовы в выражениях: f(), f(1), f(1, g(2), 3 + 4), obj.m(1), obj.m, self.x }

program ExprCalls;
var
  x: integer;
  o: TObj;
begin
  x := f();
  x := f(1);
  x := f(1, g(2), 3 + 4);
  x := o.m(1);
  x := o.m;
  x := self.x
end.