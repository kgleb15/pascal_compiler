{ Полная программа: задействованы все конструкции поддерживаемой грамматики }

program AllFeatures;

const
  MaxCount = 10;
  Half: real = 0.5;
  Mask = 1 + 2 * 3;

type
  TDigit = 0..9;
  TLetter = 'a'..'z';
  TSigned = -5..5;
  TColor = (red, green, blue);
  TLine = array[1..MaxCount] of integer;
  TGrid = array[1..3, 1..4] of integer;
  TDyn = array of integer;
  TWords = array[1..3] of array of string;
  TBig = array[1..2 * 3] of integer;
  TBigger = array[1..2 + 3] of integer;
  TPalette = array[TColor.red..TColor.blue] of integer;
  TRange = array[1..5 - 2] of integer;
  TRange2 = array[1..6 div 2] of integer;
  TRange3 = array[+1..5] of integer;

  TForward = class;

  TShape = class
    x, y: integer;
    name: string;
    constructor Create(ax, ay: integer);
    destructor Destroy; override;
    procedure Move(dx: integer; var dy: integer);
    procedure Freeze;
    function Area: real; virtual;
    function Calc(k: integer): integer; virtual;
  end;

  TSquare = class(TShape)
    side: integer;
    procedure Move(dx: integer; var dy: integer); override;
    procedure Freeze; override;
    procedure Reset; virtual; abstract;
    function Area: real; override;
    function Calc(k: integer): integer; override;
  end;

  TDerived = class(TShape);
  TSub = class(TShape) end;
  TEmpty = class end;

  TPoint = class
    x, y: integer;
  end;

  TBag = class
    var items: integer;
    const K = 1;
    type TInner = 1..5;
    destructor Cleanup();
  end;

var
  a, b, c: integer;
  ratio: real = 0.5;
  table: array[1..3] of integer = (1, 2, 3);
  words: TWords;
  shape: TShape;
  square: TSquare;
  digit: TDigit;
  flag: boolean;
  text: string;

procedure Swap(var a, b: integer);
var
  t: integer;
begin
  t := a;
  a := b;
  b := t
end;

function Max3(a, b, c: integer): integer;
begin
  if a > b then
    if a > c then
      Max3 := a
    else
      Max3 := c
  else if b > c then
    Max3 := b
  else
    Max3 := c
end;

procedure Countdown(n: integer = 3);
begin
  while n > 0 do
    n := n - 1
end;

procedure Fill(data: array of integer; const origin: integer);
var
  idx: integer;
begin
  for idx in data do
    idx := origin
end;

procedure NoArgs();
begin end;

procedure Show(s: string);
begin end;

procedure Sum(const a, b: integer; const k: integer = 7);
begin end;

procedure Later; forward;

procedure Outer(n: integer);
  procedure Inner(m: integer);
  begin
    m := m + 1
  end;
begin
  Inner(n)
end;

procedure Later;
begin end;

constructor TShape.Create(ax, ay: integer);
begin
  inherited;
  x := ax;
  y := ay;
  name := 'shape'
end;

destructor TShape.Destroy;
begin
  inherited
end;

procedure TShape.Move(dx: integer; var dy: integer);
begin
  self.x := x + dx;
  y := y + dy;
  dy := 0
end;

procedure TShape.Freeze;
begin
  name := 'frozen'
end;

function TShape.Area: real;
begin
  Area := 0
end;

procedure TSquare.Move(dx: integer; var dy: integer);
begin
  inherited Move(dx, dy);
  side := side + dx
end;

procedure TSquare.Freeze;
begin
  inherited Freeze;
  side := 0
end;

function TShape.Calc(k: integer): integer;
begin
  Calc := k + x
end;

function TSquare.Area: real;
begin
  Area := inherited Area + side * side
end;

function TSquare.Calc(k: integer): integer;
begin
  Calc := inherited Calc(k) + side
end;

destructor TBag.Cleanup();
begin end;

begin
  a := 1;
  b := 2;
  c := 3;

  a := a + b * c - b div c mod 2;
  b := -a + +b;
  c := (a + b) * (c - a) / ((b + 1));
  c := $FF + &17 + %101 + 42;
  ratio := 1.5 + 2e10 + 1.5e-3;

  flag := (a < b) and (b <= c) or not (a = c) or (a <> b) or (a >= b);
  flag := not not flag;
  flag := shape is TShape;

  text := 'it''s' + #65;
  text := 'plain';
  words[1][2] := text;

  table[1] := table[2] + table[3];
  table[a] := b;

  a := Max3(1, 2, 3);
  a := Max3(b, c, a) + Max3(a, b, c);
  Countdown;
  Countdown();
  Countdown(5);
  Swap(a, b);
  Fill(table, 0);
  Show(text);
  Sum(1, 2);

  shape := TShape.Create(1, 2);
  square := TSquare.Create(1, 2);
  square := shape as TSquare;
  shape.Move(1, a);
  square.Move(b, c);
  shape.Freeze;
  shape.x := 5;
  square.side := shape.x + square.y;
  ratio := square.Area + shape.Area;
  shape := nil;
  flag := shape = nil;

  a += 1;
  a -= 1;
  a *= 2;
  a /= 2;

  if a > 0 then
    b := 1
  else if a < 0 then
    b := -1
  else
    b := 0;

  if flag then
    if a = b then
      c := 1
    else
      c := 2;

  while a > 0 do
  begin
    a := a - 1;
    if a = 5 then
      b := 5
  end;

  repeat
    a := a + 1;
    b := b * 2
  until a >= MaxCount;

  for digit := 1 to MaxCount do
    table[digit] := digit;

  for digit := MaxCount downto 1 do
    b := b - digit;

  for digit in table do
    a := a + digit;

  case a of
    0: b := 0;
    1, 2, 3: b := 1;
    4..6: b := 2;
    -5..-1: b := 3;
    red: b := 4;
    'x': b := 5;
    else b := 6
  end;

  case b of
    1: begin
         a := 1;
         c := 2
       end;
    2: b := 2
    otherwise b := 0
  end;

  case c of
    1: b := 1;
    2: b := 2
  end;

  begin end;
  ;;
  begin
    begin
      a := table[1]
    end
  end
end.