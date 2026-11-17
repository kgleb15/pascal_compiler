{ Алгоритмы с глубокой вложенностью: перебор ферзей и быстрая сортировка }

program Algorithms;

const
  N = 8;
  MaxSize = 20;

type
  TBoard = array[1..MaxSize] of boolean;
  TDigits = array[1..MaxSize] of integer;

var
  column, diagUp, diagDown: TBoard;
  pos, data: TDigits;
  solutions: integer;

procedure Place(row: integer);
var
  col: integer;
begin
  if row > N then
    solutions := solutions + 1
  else
    for col := 1 to N do
      if not column[col] and not diagUp[row + col] and not diagDown[row - col + N] then
      begin
        column[col] := true;
        diagUp[row + col] := true;
        diagDown[row - col + N] := true;
        pos[row] := col;
        Place(row + 1);
        column[col] := false;
        diagUp[row + col] := false;
        diagDown[row - col + N] := false
      end
end;

procedure Swap(var a, b: integer);
var
  t: integer;
begin
  t := a;
  a := b;
  b := t
end;

function Partition(lo, hi: integer): integer;
var
  pivot, i, j: integer;
begin
  pivot := data[hi];
  i := lo - 1;
  for j := lo to hi - 1 do
    if data[j] <= pivot then
    begin
      i := i + 1;
      Swap(data[i], data[j])
    end;
  Swap(data[i + 1], data[hi]);
  Partition := i + 1
end;

procedure QuickSort(lo, hi: integer);
var
  p: integer;
begin
  if lo < hi then
  begin
    p := Partition(lo, hi);
    QuickSort(lo, p - 1);
    QuickSort(p + 1, hi)
  end
end;

function Factorial(n: integer): integer;
begin
  if n <= 1 then
    Factorial := 1
  else
    Factorial := n * Factorial(n - 1)
end;

begin
  solutions := 0;
  Place(1);
  data[1] := 5;
  data[2] := 3;
  data[3] := 8;
  data[4] := 1;
  QuickSort(1, 4);
  data[5] := Factorial(5)
end.