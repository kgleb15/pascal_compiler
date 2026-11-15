{ Предварительное объявление forward и вложенная подпрограмма }

program DeclForward;
procedure A; forward;
procedure A;
begin
  B
end;
procedure B;
  procedure C;
  begin end;
begin C end;
begin A end.