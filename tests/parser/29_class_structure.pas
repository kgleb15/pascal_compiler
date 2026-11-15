{ Классы: пустой, с наследованием, с полями и методами с модификаторами }

program ClassStructure;
type
  TEmpty = class
  end;
  TChild = class(TParent)
  x, y: integer;
  procedure Foo; virtual;
  function Bar(a: integer): integer; override;
  end;
begin end.