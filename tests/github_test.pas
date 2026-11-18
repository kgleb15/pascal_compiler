{
  Тест на реальном коде с GitHub: за основу взят CastleScriptParser.pas
  из Castle Game Engine (https://github.com/castle-engine/castle-engine).

  Из исходного unit-а убрано всё, что не поддерживается нашим компилятором:
  unit/interface/implementation/uses, классы и объекты, множества,
  оператор case, try..except/finally, raise, директивы overload/forward,
  записи, указатели и приведение типов.

  Оставлен и переписан под наше подмножество сам алгоритм: рекурсивный
  спуск по уровням приоритета Factor -> Term -> Sum -> Comparison.
}

program CastleScriptParserTest;

const
  TokEnd = 0;
  TokNumber = 1;
  TokPlus = 2;
  TokMinus = 3;
  TokMultiply = 4;
  TokFloatDivide = 5;
  TokIntDivide = 6;
  TokModulo = 7;
  TokGreater = 8;
  TokLesser = 9;
  TokGreaterEqual = 10;
  TokLesserEqual = 11;
  TokEqual = 12;
  TokNotEqual = 13;
  TokLParen = 14;
  TokRParen = 15;
  MaxTokens = 64;

type
  TTokenKinds = array[1..MaxTokens] of integer;
  TTokenValues = array[1..MaxTokens] of real;

var
  Token: integer;
  TokenValue: real;
  Position: integer;
  Count: integer;
  Errors: integer;
  Kinds: TTokenKinds;
  Values: TTokenValues;
  Last: real;

procedure Fail(const Message: string);
begin
  Errors := Errors + 1
end;

procedure Push(kind: integer; value: real);
begin
  if Count < MaxTokens then
  begin
    Count := Count + 1;
    Kinds[Count] := kind;
    Values[Count] := value
  end
  else
    Fail('too many tokens')
end;

procedure NextToken;
begin
  if Position <= Count then
  begin
    Token := Kinds[Position];
    TokenValue := Values[Position];
    Position := Position + 1
  end
  else
  begin
    Token := TokEnd;
    TokenValue := 0
  end
end;

procedure Expect(kind: integer);
begin
  if Token = kind then
    NextToken
  else
    Fail('unexpected token')
end;

function ApplyBinary(kind: integer; a, b: real): real;
var
  r: real;
begin
  if kind = TokPlus then
    r := a + b
  else if kind = TokMinus then
    r := a - b
  else if kind = TokMultiply then
    r := a * b
  else if kind = TokFloatDivide then
    r := a / b
  else if kind = TokIntDivide then
    r := (a - a mod b) / b
  else if kind = TokModulo then
    r := a mod b
  else
  begin
    Fail('not a binary operator');
    r := 0
  end;
  ApplyBinary := r
end;

function Factor: real;
var
  r: real;
begin
  if Token = TokNumber then
  begin
    r := TokenValue;
    NextToken
  end
  else if Token = TokMinus then
  begin
    NextToken;
    r := -Factor
  end
  else if Token = TokLParen then
  begin
    NextToken;
    r := Comparison;
    Expect(TokRParen)
  end
  else
  begin
    Fail('expected number, minus or left bracket');
    r := 0
  end;
  Factor := r
end;

function Term: real;
var
  r, right: real;
  op: integer;
begin
  r := Factor;
  while (Token = TokMultiply) or (Token = TokFloatDivide) or
        (Token = TokIntDivide) or (Token = TokModulo) do
  begin
    op := Token;
    NextToken;
    right := Factor;
    r := ApplyBinary(op, r, right)
  end;
  Term := r
end;

function Sum: real;
var
  r, right: real;
  op: integer;
begin
  r := Term;
  while (Token = TokPlus) or (Token = TokMinus) do
  begin
    op := Token;
    NextToken;
    right := Term;
    r := ApplyBinary(op, r, right)
  end;
  Sum := r
end;

function Comparison: real;
var
  left, right: real;
  op: integer;
begin
  left := Sum;
  while (Token = TokGreater) or (Token = TokLesser) or
        (Token = TokGreaterEqual) or (Token = TokLesserEqual) or
        (Token = TokEqual) or (Token = TokNotEqual) do
  begin
    op := Token;
    NextToken;
    right := Sum;
    if op = TokGreater then
      if left > right then left := 1 else left := 0
    else if op = TokLesser then
      if left < right then left := 1 else left := 0
    else if op = TokGreaterEqual then
      if left >= right then left := 1 else left := 0
    else if op = TokLesserEqual then
      if left <= right then left := 1 else left := 0
    else if op = TokEqual then
      if left = right then left := 1 else left := 0
    else
      if left <> right then left := 1 else left := 0
  end;
  Comparison := left
end;

function Evaluate: real;
begin
  Position := 1;
  Errors := 0;
  NextToken;
  Evaluate := Comparison
end;

begin
  Last := 0;
  Errors := 0;
  Count := 0;
  Push(TokLParen, 0);
  Push(TokNumber, 1);
  Push(TokPlus, 0);
  Push(TokNumber, 2);
  Push(TokRParen, 0);
  Push(TokMultiply, 0);
  Push(TokNumber, 3);
  Last := Evaluate;

  Count := 0;
  Push(TokNumber, 5);
  Push(TokMinus, 0);
  Push(TokNumber, 2);
  Push(TokMultiply, 0);
  Push(TokNumber, 3);
  Last := Evaluate;

  Count := 0;
  Push(TokNumber, 4);
  Push(TokLesser, 0);
  Push(TokNumber, 7);
  Last := Evaluate
end.