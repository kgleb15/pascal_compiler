program p1;


function Expression(const Lexer: TCasScriptLexer;
  const Variables: array of TCasScriptValue): TCasScriptExpression; forward;

function NonAssignmentExpression(const Lexer: TCasScriptLexer;
  const AllowFullExpressionInFactor: Boolean;
  const Variables: array of TCasScriptValue): TCasScriptExpression; forward;

function PossiblyAssignmentExpression(const Lexer: TCasScriptLexer;
  const Variables: array of TCasScriptValue): TCasScriptExpression; forward;

function BinaryOper(tok: TToken): TCasScriptFunctionClass;
begin
  Result := nil;
  if tok = tokPlus then Result := TCasScriptAdd
  else if tok = tokMinus then Result := TCasScriptSubtract
  else if tok = tokMultiply then Result := TCasScriptMultiply
  else if tok = tokFloatDivide then Result := TCasScriptFloatDivide
  else if tok = tokIntDivide then Result := TCasScriptIntDivide
  else if tok = tokPower then Result := TCasScriptPower
  else if tok = tokModulo then Result := TCasScriptModulo
  else if tok = tokGreater then Result := TCasScriptGreater
  else if tok = tokLesser then Result := TCasScriptLesser
  else if tok = tokGreaterEqual then Result := TCasScriptGreaterEq
  else if tok = tokLesserEqual then Result := TCasScriptLesserEq
  else if tok = tokEqual then Result := TCasScriptEqual
  else if tok = tokNotEqual then Result := TCasScriptNotEqual;
end;

function Operand(const Lexer: TCasScriptLexer;
  const Variables: array of TCasScriptValue): TCasScriptValue;
var
  I: Integer;
begin
  Result := nil;
  if Lexer.Token <> tokIdentifier then Exit;

  for I := 0 to Length(Variables) - 1 do
    if SameText(Variables[I].Name, Lexer.TokenString) then
    begin
      Result := Variables[I];
      Break;
    end;

  if Result = nil then Exit;

  Lexer.NextToken;
end;

function ExpressionInsideFactor(const Lexer: TCasScriptLexer;
  const AllowFullExpressionInFactor: Boolean;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
begin
  if AllowFullExpressionInFactor then
    Result := Expression(Lexer, Variables)
  else
    Result := NonAssignmentExpression(Lexer, AllowFullExpressionInFactor, Variables);
end;

function Factor(const Lexer: TCasScriptLexer;
  const AllowFullExpressionInFactor: Boolean;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  FC: TCasScriptFunctionClass;
  FParams: TCasScriptExpressionList;
  ParamExpr: TCasScriptExpression;
  ParseOk: Boolean;
begin
  Result := nil;

  if Lexer.Token = tokIdentifier then
  begin
    Result := Operand(Lexer, Variables);
    Exit;
  end;

  if Lexer.Token = tokInteger then
  begin
    Result := TCasScriptInteger.Create(false, Lexer.TokenInteger);
    Lexer.NextToken;
    Exit;
  end;

  if Lexer.Token = tokFloat then
  begin
    Result := TCasScriptFloat.Create(false, Lexer.TokenFloat);
    Lexer.NextToken;
    Exit;
  end;

  if Lexer.Token = tokBoolean then
  begin
    Result := TCasScriptBoolean.Create(false, Lexer.TokenBoolean);
    Lexer.NextToken;
    Exit;
  end;

  if Lexer.Token = tokString then
  begin
    Result := TCasScriptString.Create(false, Lexer.TokenString);
    Lexer.NextToken;
    Exit;
  end;

  if Lexer.Token = tokMinus then
  begin
    Lexer.NextToken;
    ParamExpr := Factor(Lexer, AllowFullExpressionInFactor, Variables);
    if ParamExpr <> nil then
      Result := TCasScriptNegate.Create(ParamExpr);
    Exit;
  end;

  if Lexer.Token = tokLParen then
  begin
    Lexer.NextToken;
    Result := ExpressionInsideFactor(Lexer, AllowFullExpressionInFactor, Variables);
    if Result <> nil then
    begin
      if Lexer.Token = tokRParen then
        Lexer.NextToken
      else
      begin
        Result.FreeByParentExpression;
        Result := nil;
      end;
    end;
    Exit;
  end;

  if Lexer.Token = tokFuncName then
  begin
    FC := Lexer.TokenFunctionClass;
    Lexer.NextToken;

    FParams := TCasScriptExpressionList.Create(false);
    ParseOk := Lexer.Token = tokLParen;

    if ParseOk then
    begin
      Lexer.NextToken;

      if Lexer.Token <> tokRParen then
      begin
        while True do
        begin
          ParamExpr := ExpressionInsideFactor(Lexer, AllowFullExpressionInFactor, Variables);
          if ParamExpr = nil then
          begin
            ParseOk := False;
            Break;
          end;

          FParams.Add(ParamExpr);

          if Lexer.Token = tokRParen then Break;

          if Lexer.Token <> tokComma then
          begin
            ParseOk := False;
            Break;
          end;

          Lexer.NextToken;
        end;
      end;

      if ParseOk then
      begin
        if Lexer.Token = tokRParen then
        begin
          Lexer.NextToken;
          Result := FC.Create(FParams);
        end
        else
          ParseOk := False;
      end;
    end;

    if not ParseOk then
      FParams.FreeContentsByParentExpression;

    FParams.Free;
    Exit;
  end;
end;

function Term(const Lexer: TCasScriptLexer;
  const AllowFullExpressionInFactor: Boolean;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  FC: TCasScriptFunctionClass;
  Right: TCasScriptExpression;
begin
  Result := Factor(Lexer, AllowFullExpressionInFactor, Variables);

  while (Result <> nil) do
  begin
    FC := BinaryOper(Lexer.Token);
    if FC = nil then Break;

    Lexer.NextToken;
    Right := Factor(Lexer, AllowFullExpressionInFactor, Variables);

    if Right = nil then
    begin
      Result.FreeByParentExpression;
      Result := nil;
      Break;
    end;

    Result := FC.Create(Result, Right);
  end;
end;

function ComparisonArgument(const Lexer: TCasScriptLexer;
  const AllowFullExpressionInFactor: Boolean;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  FC: TCasScriptFunctionClass;
  Right: TCasScriptExpression;
begin
  Result := Term(Lexer, AllowFullExpressionInFactor, Variables);

  while (Result <> nil) do
  begin
    FC := BinaryOper(Lexer.Token);
    if FC = nil then Break;

    Lexer.NextToken;
    Right := Term(Lexer, AllowFullExpressionInFactor, Variables);

    if Right = nil then
    begin
      Result.FreeByParentExpression;
      Result := nil;
      Break;
    end;

    Result := FC.Create(Result, Right);
  end;
end;

function NonAssignmentExpression(const Lexer: TCasScriptLexer;
  const AllowFullExpressionInFactor: Boolean;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  FC: TCasScriptFunctionClass;
  Right: TCasScriptExpression;
begin
  Result := ComparisonArgument(Lexer, AllowFullExpressionInFactor, Variables);

  while (Result <> nil) do
  begin
    FC := BinaryOper(Lexer.Token);
    if FC = nil then Break;

    Lexer.NextToken;
    Right := ComparisonArgument(Lexer, AllowFullExpressionInFactor, Variables);

    if Right = nil then
    begin
      Result.FreeByParentExpression;
      Result := nil;
      Break;
    end;

    Result := FC.Create(Result, Right);
  end;
end;

function PossiblyAssignmentExpression(const Lexer: TCasScriptLexer;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  OperandExpr, AssignedValue: TCasScriptExpression;
begin
  Result := NonAssignmentExpression(Lexer, True, Variables);
  if Result = nil then Exit;

  if Lexer.Token = tokAssignment then
  begin
    Lexer.NextToken;

    AssignedValue := PossiblyAssignmentExpression(Lexer, Variables);
    if AssignedValue = nil then
    begin
      Result.FreeByParentExpression;
      Result := nil;
      Exit;
    end;

    OperandExpr := Result;
    Result := TCasScriptAssignment.Create(OperandExpr, AssignedValue);
  end;
end;

function Expression(const Lexer: TCasScriptLexer;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  SequenceArgs: TCasScriptExpressionList;
  NextExpr: TCasScriptExpression;
  ParseOk: Boolean;
begin
  Result := PossiblyAssignmentExpression(Lexer, Variables);
  if Result = nil then Exit;

  if Lexer.Token = tokSemicolon then
  begin
    SequenceArgs := TCasScriptExpressionList.Create(false);
    SequenceArgs.Add(Result);
    Result := nil;

    ParseOk := True;

    while Lexer.Token = tokSemicolon do
    begin
      Lexer.NextToken;

      NextExpr := PossiblyAssignmentExpression(Lexer, Variables);
      if NextExpr = nil then
      begin
        ParseOk := False;
        Break;
      end;

      SequenceArgs.Add(NextExpr);
    end;

    if ParseOk then
      Result := TCasScriptSequence.Create(SequenceArgs);

    if Result = nil then
      SequenceArgs.FreeContentsByParentExpression;

    SequenceArgs.Free;
  end;
end;

function Expression(const Lexer: TCasScriptLexer;
  const Variables: TCasScriptValueList): TCasScriptExpression;
begin
  Result := Expression(Lexer, Variables.ToArray);
end;

function AFunction(const Lexer: TCasScriptLexer;
  const GlobalVariables: array of TCasScriptValue): TCasScriptUserFunction;
var
  BodyVariables: TCasScriptValueList;
  Parameter: TCasScriptValue;
  BodyExpr: TCasScriptExpression;
  ParseOk: Boolean;
begin
  Result := TCasScriptUserFunction.Create;
  if Result = nil then Exit;

  ParseOk := Lexer.Token = tokIdentifier;

  if ParseOk then
  begin
    Result.Name := Lexer.TokenString;
    Lexer.NextToken;
  end;

  BodyVariables := TCasScriptValueList.Create(false);

  if ParseOk then
  begin
    ParseOk := Lexer.Token = tokLParen;

    if ParseOk then
    begin
      Lexer.NextToken;

      if Lexer.Token <> tokRParen then
      begin
        while True do
        begin
          if Lexer.Token <> tokIdentifier then
          begin
            ParseOk := False;
            Break;
          end;

          Parameter := TCasScriptParameterValue.Create(true);
          if Parameter = nil then
          begin
            ParseOk := False;
            Break;
          end;

          Parameter.Name := Lexer.TokenString;
          Parameter.OwnedByParentExpression := false;

          Result.Parameters.Add(Parameter);
          BodyVariables.Add(Parameter);

          Lexer.NextToken;

          if Lexer.Token = tokRParen then Break;

          if Lexer.Token <> tokComma then
          begin
            ParseOk := False;
            Break;
          end;

          Lexer.NextToken;
        end;
      end;

      if ParseOk then
      begin
        if Lexer.Token = tokRParen then
          Lexer.NextToken
        else
          ParseOk := False;
      end;
    end;
  end;

  if ParseOk then
  begin
    BodyVariables.AddRange(GlobalVariables);

    BodyExpr := Expression(Lexer, BodyVariables.ToArray);
    if BodyExpr = nil then
      ParseOk := False
    else
      Result.Body := BodyExpr;
  end;

  BodyVariables.Free;

  if not ParseOk then
  begin
    Result.Free;
    Result := nil;
  end;
end;

function AProgram(const Lexer: TCasScriptLexer;
  const GlobalVariables: array of TCasScriptValue): TCasScriptProgram;
var
  F: TCasScriptUserFunction;
begin
  Result := TCasScriptProgram.Create;

  while Lexer.Token = tokFunctionKeyword do
  begin
    Lexer.NextToken;

    F := AFunction(Lexer, GlobalVariables);
    if F = nil then
    begin
      Result.Free;
      Result := nil;
      Exit;
    end;

    Result.Functions.Add(F);
  end;
end;

function ParseSimpleExpression(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  Lexer: TCasScriptLexer;
  I: Integer;
begin
  for I := 0 to Length(Variables) - 1 do
    Variables[I].OwnedByParentExpression := false;

  Lexer := TCasScriptLexer.Create(S);
  Result := NonAssignmentExpression(Lexer, False, Variables);

  if Result <> nil then
  begin
    if Lexer.Token <> tokEnd then
    begin
      Result.FreeByParentExpression;
      Result := nil;
    end;
  end;

  Lexer.Free;
end;

function ParseFloatExpression(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  Inner: TCasScriptExpression;
begin
  Inner := ParseSimpleExpression(S, Variables);
  if Inner = nil then
    Result := nil
  else
  begin
    Result := TCasScriptFloatFun.Create(Inner);
    if Result = nil then
      Inner.FreeByParentExpression;
  end;
end;

function ParseIntExpression(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  Inner: TCasScriptExpression;
begin
  Inner := ParseSimpleExpression(S, Variables);
  if Inner = nil then
    Result := nil
  else
  begin
    Result := TCasScriptInt.Create(Inner);
    if Result = nil then
      Inner.FreeByParentExpression;
  end;
end;

function ParseStringExpression(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  Inner: TCasScriptExpression;
begin
  Inner := ParseSimpleExpression(S, Variables);
  if Inner = nil then
    Result := nil
  else
  begin
    Result := TCasScriptStringFun.Create(Inner);
    if Result = nil then
      Inner.FreeByParentExpression;
  end;
end;

function ParseBoolExpression(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  Inner: TCasScriptExpression;
begin
  Inner := ParseSimpleExpression(S, Variables);
  if Inner = nil then
    Result := nil
  else
  begin
    Result := TCasScriptBool.Create(Inner);
    if Result = nil then
      Inner.FreeByParentExpression;
  end;
end;

function ParseExpression(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptExpression;
var
  Lexer: TCasScriptLexer;
  I: Integer;
begin
  for I := 0 to Length(Variables) - 1 do
    Variables[I].OwnedByParentExpression := false;

  Lexer := TCasScriptLexer.Create(S);

  Result := Expression(Lexer, Variables);

  if Result <> nil then
  begin
    if Lexer.Token <> tokEnd then
    begin
      Result.FreeByParentExpression;
      Result := nil;
    end;
  end;

  Lexer.Free;
end;

function ParseConstantFloatExpression(const S: string): Float;
var
  Expr: TCasScriptExpression;
  V: TCasScriptFloat;
begin
  Result := 0;

  Expr := ParseFloatExpression(S);
  if Expr = nil then Exit;

  V := Expr.Execute as TCasScriptFloat;
  if V <> nil then
    Result := V.Value;

  Expr.Free;
end;

function ParseConstantIntExpression(const S: string): Int64;
var
  Expr: TCasScriptExpression;
  V: TCasScriptInteger;
begin
  Result := 0;

  Expr := ParseIntExpression(S);
  if Expr = nil then Exit;

  V := Expr.Execute as TCasScriptInteger;
  if V <> nil then
    Result := V.Value;

  Expr.Free;
end;

function ParseProgram(const S: string;
  const Variables: TCasScriptValueList): TCasScriptProgram;
begin
  Result := ParseProgram(S, Variables.ToArray);
end;

function ParseProgram(const S: string;
  const Variables: array of TCasScriptValue): TCasScriptProgram;
var
  Lexer: TCasScriptLexer;
  I: Integer;
begin
  for I := 0 to Length(Variables) - 1 do
    Variables[I].OwnedByParentExpression := false;

  Lexer := TCasScriptLexer.Create(S);

  Result := AProgram(Lexer, Variables);

  if Result <> nil then
  begin
    if Lexer.Token <> tokEnd then
    begin
      Result.Free;
      Result := nil;
    end;
  end;

  Lexer.Free;
end;
begin end.