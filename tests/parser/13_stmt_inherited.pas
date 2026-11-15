{ Обращение к методам родительского класса: inherited; и inherited Create(1) }

program StmtInherited;
type
  TChild = class(TParent)
  procedure Foo; override;
  end;
procedure TChild.Foo;
begin
  inherited;
  inherited Create(1)
end;
begin end.