{ Параметры подпрограмм: value, var, const, список имён, значение по умолчанию }

program DeclParams;
procedure P(a, b: integer; var c: integer; const d: integer);
begin end;
function F(x: integer = 5; s: string): integer;
begin F := x end;
procedure Q(data: array of integer);
begin end;
begin P(1, 2, 3, 4); F(1, 'a'); Q(1) end.