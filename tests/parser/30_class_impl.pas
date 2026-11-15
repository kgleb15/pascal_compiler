{ Реализация методов класса: constructor, destructor, method и inherited }

program ClassImpl;
type
  TPoint = class(TParent)
  x: integer;
  constructor Create(ax: integer);
  destructor Destroy; override;
  procedure Move(dx: integer);
  end;
constructor TPoint.Create(ax: integer);
begin
  inherited Create(ax);
  x := ax
end;
destructor TPoint.Destroy; begin inherited end;
procedure TPoint.Move(dx: integer);
begin
  x := x + dx
end;
var p: TPoint;
begin
  p := TPoint.Create(1);
  p.Move(2)
end.