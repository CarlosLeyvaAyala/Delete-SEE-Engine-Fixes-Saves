unit Backend;

interface

uses
  System.Classes, System.IOUtils, System.SysUtils, System.DateUtils, System.Generics.Collections, Functions.Strings, System.StrUtils, Winapi.ShellAPI, System.Math;

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

  TProcessOutput = record
    deletedCount: Integer;
    deletedSize: Int64;
    leftCount: Integer;
    leftSize: Int64;
    function leftSizePretty: string;
    function deletedSizePretty: string;
    function processResult: string;
  end;

function ProcessFiles(o: TProcessOptions): TProcessOutput;

implementation

uses
  Functional.Sequence, Functions.Math;

const
  extFilter = '*.ess';
  skseFilter = '*.skse';

var
  deleteTheseFiles: TStringList;

function IfThen(AValue: Boolean; const ATrue: Boolean; const AFalse: Boolean): Boolean;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function FileSize(fileName : string) : Int64;
begin
  var sr : TSearchRec;
  if FindFirst(fileName, faAnyFile, sr ) = 0 then
    Result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
  else
  Result := -1;
  FindClose(sr);
end;

function BytesToStr(bytes: Int64): string;
const
  Description: Array [0 .. 8] of string = ('Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB');
begin
  var i := 0;
  while bytes > Power(1024, i + 1) do Inc(i);
  Result := FormatFloat('###0.##', bytes / Power(1024, i)) + #32 + Description[i];
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
  Result := TFile.GetCreationTime(fileName);
end;

function GetLastSaved(dir: string): TDateTime;
begin
  const all = TDirectory.GetFiles(dir, extFilter);
  var mx: TDateTime := -1;
  for var f in all do
    mx := Max(mx, GetFileDate(f));
  Result := mx;
end;

function FilesListSize(list: TStringList): Int64;
begin
  Result := TSeq.From(list).Map<Int64>(FileSize).Fold<Int64>(SumF, 0);
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

function FileNameToPChar(fileName: string): string;
  procedure AddOther(ext: string);
  begin
    const other = TPath.ChangeExtension(fileName, ext);
    if FileExists(other) then Result := Result + #0 + other;
  end;
begin
  Result := fileName;
  AddOther('skse');
  AddOther('bak');
end;

procedure SendToBin(markedForDelete: TStringList);
begin
  if markedForDelete.Count < 1 then Exit;

  const files = TSeq.From(markedForDelete)
    .Map(FileNameToPChar)
    .Fold<string>(ReduceStr(#0), '');

  var Op: TSHFileOpStruct;
  FillChar(Op, SizeOf(Op), 0);

  Op.wFunc := FO_DELETE;
  Op.pFrom := PChar(files + #0);
  Op.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  ShFileOperation(Op);
end;

procedure DoDelete(allFiles, deletedFiles: TStringList; minSpan: Integer;
  output: TStrings);
begin
  // Gather files to delete
  var i := 1;
  while i < allFiles.Count do begin
    const d2 = GetFileDate(allFiles[i]);
    const d1 = GetFileDate(allFiles[i - 1]);
    const span = MinuteSpan(d1, d2);
    if span < minSpan then begin
      const fn = allFiles[i];
      deletedFiles.Add(fn);
      allFiles.Delete(i);
      output.Add(ExtractFileName(fn))
    end
    else
      Inc(i);
  end;
end;

procedure DeleteFiles(path: string; output: TStrings; lastSave: TDateTime;
  minSpan: Integer; moreThanHours: Real; lessThanHours: Real = -1; doSortDesc: boolean = true);
begin
  const f = FilterByTime(lastSave, moreThanHours, lessThanHours);
  const files = TDirectory.GetFiles(path, extFilter, f);
  output.Add(Format('Files deleted because they were out of the %d minute span', [minSpan]));
  output.Add(DupeString('*', 60));

  OnStringList(procedure (allFiles: TStringList) begin
    for var p in files do allFiles.Add(p);
    if doSortDesc then allFiles.CustomSort(SortDesc)
    else allFiles.Sort;

    DoDelete(allFiles, deleteTheseFiles, minSpan, output);
  end);

  output.Add('');
end;

procedure FilesLeft(const path: string; var o: TProcessOutput);
  function CalcSize(arr: TArray<string>): Int64;
  begin
//    const a = arr;
    var r: Int64 := 0;
    OnStringList(procedure(lst: TStringList) begin
      for var p in arr do lst.Add(p);
      r := FilesListSize(lst);
    end);
    Result := r;
  end;
begin
  const ess = TDirectory.GetFiles(path, extFilter);
  const skse = TDirectory.GetFiles(path, skseFilter);
  o.leftCount := Length(ess) + Length(skse);
  o.leftSize := CalcSize(ess) + CalcSize(skse);
end;

function ProcessFiles(o: TProcessOptions): TProcessOutput;
begin
  const last = GetLastSaved(o.path);
  const p = o.path;
  const oo = o.output;
  DeleteFiles(p, oo, last, 2, o.leaveAlone, o.span2);
  DeleteFiles(p, oo, last, 5, o.span2, o.span5);
  DeleteFiles(p, oo, last, 10, o.span5, o.span10);
  DeleteFiles(p, oo, last, 15, o.span10, o.span15);
  DeleteFiles(p, oo, last, 24 * 60, o.span15, -1, false);

  Result.deletedCount := deleteTheseFiles.Count;
  Result.deletedSize := FilesListSize(deleteTheseFiles);

  SendToBin(deleteTheseFiles);

  FilesLeft(p, Result);
end;

{ TProcessOutput }

function TProcessOutput.deletedSizePretty: string;
begin
  Result := BytesToStr(deletedSize);
end;

function TProcessOutput.leftSizePretty: string;
begin
  Result := BytesToStr(leftSize);
end;

function TProcessOutput.processResult: string;
begin
  const fmt = '%d files sent to the trash bin (%s). Saves left: %d (%s).';
  Result := Format(fmt, [deletedCount, deletedSizePretty, leftCount, leftSizePretty]);
end;

initialization
  deleteTheseFiles := TStringList.Create;

finalization
  deleteTheseFiles.Free;

end.

