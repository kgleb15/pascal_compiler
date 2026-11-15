{ Присваивания: :=, +=, -=, *=, /= и присваивание полю и элементу массива }

program StmtAssign;
var
  a, b: integer;
  o: TObj;
begin
  a := 1;
  a += 2;
  a -= 3;
  a *= 4;
  a /= 5;
  o.f := 6;
  o[1] := o[2]
end.