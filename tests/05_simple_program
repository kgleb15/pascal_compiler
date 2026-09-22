{$MODE OBJFPC}
program TwoClasses;

type
    TShape = class    // Абстрактная фигура
    private
        fName: string;
    public
        constructor Create(const aName: string);
        procedure Show; virtual;
        function Area: Real;
    end;

    TCircle = class(TShape)   // Круг
    private
        fRadius: Real;
    public
        constructor Create(const aName: string; aRadius: Real);
        procedure Show; override;
        function Area: Real;
    end;

constructor TShape.Create(const aName: string);
begin
    fName := aName;
end;

procedure TShape.Show;
begin
    Write('Shape: ', fName);
end;

function TShape.Area: Real;
begin
    Area := 0.0;
end;

constructor TCircle.Create(const aName: string; aRadius: Real);
begin
    inherited Create(aName);
    fRadius := aRadius;
end;

procedure TCircle.Show;
begin
    Writeln('');
    inherited Show;
    Writeln('   Radius = ', fRadius);
end;

function TCircle.Area: Real;
begin
    Area := 3.14159 * fRadius * fRadius;
end;

var
    s: TShape;
    c: TCircle;
    r: Real;
begin
    Write('Enter radius: ');
    ReadLn(r);
    Writeln(''); Writeln('');

    s := TShape.Create('base');
    c := TCircle.Create('circle', r);

    s.Show;
    Writeln('');
    c.Show;
    Writeln('');

    WriteLn('Shape area:  ', s.Area);
    WriteLn('Circle area: ', c.Area);
end.