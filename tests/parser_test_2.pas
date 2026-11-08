program t6;

type
  TPoint = class
  x: integer;
  constructor Create(ax: integer);
  end;

constructor TPoint.Create(ax: integer);
begin
  x := ax;
end;

var p: TPoint;
begin
  p := TPoint.Create(5);
  writeln(p.x);
end.
