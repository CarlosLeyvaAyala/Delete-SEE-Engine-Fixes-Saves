unit Backend;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, System.DateUtils, System.Generics.Collections, Functions.Strings, System.StrUtils, Winapi.ShellAPI;

type
  TProcessOptions = record
    output: TStrings;
    path: string;
    leaveAlone: Real;
    span2: Real;
    span5: Real;
    span10: Real;
    span15: Real;
  end;

function ProcessFiles(o: TProcessOptions): Integer;

implementation

const
  extFilter = '*.ess';

function IfThen(AValue: Boolean; const ATrue: Boolean; const AFalse: Boolean): Boolean;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function FilterByTime(lastSaved: TDateTime; moreThanHours: Real; lessThanHours:
  Real = -1): TDirectory.TFilterPredicate;

  function HrToMin(hr: Real): Int64;
  begin
    Result := Round(60 * hr);
  end;

begin
  const lessThanMinutes = HrToMin(lessThanHours);
  const moreThanMinutes = HrToMin(moreThanHours);
  Result :=
    function(const p: string; const r: TSearchRec): Boolean
    begin
      const thisDate = r.TimeStamp;
      const min = MinuteSpan(lastSaved, thisDate) <= lessThanMinutes;
      const max = MinuteSpan(lastSaved, thisDate) > moreThanMinutes;
      Result := max and IfThen(lessThanMinutes < 0, true, min);
    end;
end;

function GetFileDate(fileName: string): TDateTime;
begin
//  var data: TSearchRec;
//  FindFirst(fileName, faAnyFile, data);
//  Result := data.TimeStamp;
  Result := TFile.GetCreationTime(fileName);
end;

function GetLastSaved(dir: string): TDateTime;
begin
  const all = TDirectory.GetFiles(dir, extFilter);
  const n = Length(all);
  const last = all[n - 1];
  Result := GetFileDate(last);
end;

function SortDesc(List: TStringList; Index1, Index2: Integer):
Integer;
begin
  // Negate the result so a descending sort is done.
  Result := -AnsiCompareText(List[Index1], List[Index2]);
end;

function ChangeDir(fileName: string): string;
begin
  if not FileExists(fileName) then Exit;

  const s = 'F:\Skyrim SE\MO2\profiles\3BBB\saves\test\';
  Result := s + ExtractFileName(fileName);
  TFile.Move(fileName, Result);
end;

procedure SendToBin(fileName: string);
begin
  if not FileExists(fileName) then Exit;

  var Op: TSHFileOpStruct;
  FillChar(Op, SizeOf(Op), 0);

  Op.wFunc := FO_DELETE;
  Op.pFrom := PChar(fileName + #0);
  Op.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOERRORUI;
  ShFileOperation(Op);
end;

procedure DoDelete(allFiles, deletedFiles: TStringList; minSpan: Integer);
begin
  // Gather files to delete
  var i := 1;
  while i < allFiles.Count do begin
    const d2 = GetFileDate(allFiles[i]);
    const d1 = GetFileDate(allFiles[i - 1]);
    const span = MinuteSpan(d1, d2);
    if span < minSpan then begin
      deletedFiles.Add(allFiles[i]);
      allFiles.Delete(i);
    end
    else
      Inc(i);
  end;

  // Time to delete files
  for var del in deletedFiles do begin
    const cosave =TPath.ChangeExtension(del, 'skse');
    const bak = TPath.ChangeExtension(del, 'bak');
    SendToBin(del);
    SendToBin(cosave);
    SendToBin(bak);
  end;
end;

function DeleteFiles(path: string; output: TStrings; lastSave: TDateTime;
  minSpan: Integer; moreThanHours: Real; lessThanHours: Real = -1): Integer;
begin
  var r := 0;
  const f = FilterByTime(lastSave, moreThanHours, lessThanHours);
  const files = TDirectory.GetFiles(path, extFilter, f);
  output.Add(Format('Files deleted because they were out of the %d minute span', [minSpan]));
  output.Add(DupeString('*', 60));

  OnStringList(procedure (allFiles: TStringList) begin
    for var p in files do allFiles.Add(p);
    allFiles.CustomSort(SortDesc);

    OnStringList(procedure (deletedFiles: TStringList) begin
      DoDelete(allFiles, deletedFiles, minSpan);
      for var l in deletedFiles do output.Add(ExtractFileName(l));
      r := deletedFiles.Count;
    end);
  end);

  output.Add('');

  Result := r;
end;

function ProcessFiles(o: TProcessOptions): Integer;
begin
  const last = GetLastSaved(o.path);
  const p = o.path;
  const oo = o.output;
//  DeleteFiles(p, oo, last, 0, 0, o.leaveAlone);
  Result := DeleteFiles(p, oo, last, 2, o.leaveAlone, o.span2);
  Result := Result + DeleteFiles(p, oo, last, 5, o.span2, o.span5);
  Result := Result + DeleteFiles(p, oo, last, 10, o.span5, o.span10);
  Result := Result + DeleteFiles(p, oo, last, 15, o.span10, o.span15);
  Result := Result + DeleteFiles(p, oo, last, 24 * 60, o.span15);
end;

end.

