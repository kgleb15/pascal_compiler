{ Доступ к вложенным полям и элементам: a.b.c, a[1], a[i, j], a[i][j], a.b[1].c }

program ExprAccess;
var
  a, b, i, j: TObj;
begin
  b := a.b.c;
  b := a[1];
  b := a[i, j];
  b := a[i][j];
  b := a.b[1].c
end.