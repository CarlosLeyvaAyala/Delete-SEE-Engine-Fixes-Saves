unit Functions.Math;

interface

uses
  System.SysUtils, System.Math;

function Sum(n: Integer): TFunc<Integer, Integer>; overload;

function Sum(n: Int64): TFunc<Int64, Int64>; overload;

function SumF(const item, acc: Int64): Int64;

function LinCurve(x1, y1, x2, y2: Real): TFunc<Real, Real>;

function ForceMin(aMin: Real): TFunc<Real, Real>;

function ForceMax(cap: Real): TFunc<Real, Real>;

function ForceRange(min, max: Real): TFunc<Real, Real>;

function ForcePercent(x: Real): Real;

// Sample usage:
  //  var counter: TFunc<Integer>;
  //  counter := Count();
  //  counter().ToString;  // 1
  //  counter().ToString;  // 2
function Count(start: Integer = 0; step: Integer = 1): TFunc<Integer>;

implementation

function ForcePercent(x: Real): Real;
begin
  Result := ForceRange(0, 1)(x);
end;

function SumF(const item, acc: Int64): Int64;
begin
  Result := item + acc;
end;

function Sum(n: Integer): TFunc<Integer, Integer>;
begin
  Result :=
    function(x: Integer): Integer
    begin
      Result := x + n;
    end;
end;

function Sum(n: Int64): TFunc<Int64, Int64>;
begin
  Result :=
    function(x: Int64): Int64
    begin
      Result := x + n;
    end;
end;

function Count(start, step: Integer): TFunc<Integer>;
var
  count: Integer;
begin
  count := start;

  Result :=
    function(): Integer
    begin
      count := count + step;
      Result := count;
    end;
end;

function LinCurve(x1, y1, x2, y2: Real): TFunc<Real, Real>;
begin
  Result :=
    function(x: Real): Real
    begin
      const m = (y2 - y1) / (x2 - x1);
      Result := (m * (x - x1)) + y1;
    end;
end;

function ForceMin(aMin: Real): TFunc<Real, Real>;
begin
  Result :=
    function(x: Real): Real
    begin
      Result := Max(x, aMin);
    end;
end;

function ForceMax(cap: Real): TFunc<Real, Real>;
begin
  Result :=
    function(x: Real): Real
    begin
      Result := Min(x, cap);
    end;
end;

function ForceRange(min, max: Real): TFunc<Real, Real>;
begin
  Result :=
    function(x: Real): Real
    begin
      Result := ForceMin(min)(ForceMax(max)(x));
    end;
end;

end.

