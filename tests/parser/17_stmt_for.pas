{ Цикл for: с to, с downto и тело в begin..end }

program StmtFor;
var
  i, s: integer;
begin
  for i := 1 to 10 do
    s := s + i;
  for i := 10 downto 1 do
    s := s - i;
  for i := 1 to 3 do
  begin
    s := s * 2;
    s := s + 1
  end
end.