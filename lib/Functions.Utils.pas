unit Functions.Utils;

interface

uses
  System.SysUtils, Data.DB, Functional.FuncFactory,
  System.Generics.Collections, Vcl.Menus;

function Identity(s: string): string; overload;

function Identity(i: Integer): Integer; overload;

function NotNullStr(const s: string): Boolean;

function NotNullStrField(const aField: string): Functional.FuncFactory.TPredicate
  <TDataSet>;

function MenuToList(aMenu: TMenuItem): TList<TMenuItem>;

function DataSetFixControls(ds: TDataSet; f: TFunc<TDataSet, Integer>): Integer;
  overload; deprecated;

procedure DataSetFixControls(ds: TDataSet; f: TProc<TDataSet>); overload; deprecated;

function ChangeField(field: string; value: Variant): TProc<TDataSet>;

procedure Identity; overload;

implementation

function MenuToList(aMenu: TMenuItem): TList<TMenuItem>;
var
  i: Integer;
begin
  Result := TList<TMenuItem>.Create;
  for i := 0 to aMenu.Count - 1 do
    Result.Add(aMenu[i]);
end;

function NotNullStrField(const aField: string): Functional.FuncFactory.TPredicate
  <TDataSet>;
begin
  Result :=
    function(const ds: TDataSet): Boolean
    begin
      Result := NotNullStr(ds.FieldByName(aField).AsString);
    end;
end;

function Identity(s: string): string;
begin
  Result := s;
end;

function Identity(i: Integer): Integer;
begin
  Result := i;
end;

procedure Identity;
begin
  // Blank procedure. Does nothing.
end;

function NotNullStr(const s: string): Boolean;
begin
  Result := Trim(s) <> '';
end;

function DataSetFixControls(ds: TDataSet; f: TFunc<TDataSet, Integer>): Integer;
begin
  var bmk := ds.GetBookmark;
  ds.DisableControls;
  try
    Result := f(ds);
  finally
    ds.GotoBookmark(bmk);
    ds.FreeBookmark(bmk);
    ds.EnableControls;
  end;
end;

procedure DataSetFixControls(ds: TDataSet; f: TProc<TDataSet>);
begin
  var bmk := ds.GetBookmark;
  ds.DisableControls;
  try
    f(ds);
  finally
    ds.GotoBookmark(bmk);
    ds.FreeBookmark(bmk);
    ds.EnableControls;
  end;
end;

function ChangeField(field: string; value: Variant): TProc<TDataSet>;
begin
  Result :=
    procedure(ds: TDataSet)
    begin
      ds.FieldByName(field).AsVariant := value;
    end;
end;

end.

