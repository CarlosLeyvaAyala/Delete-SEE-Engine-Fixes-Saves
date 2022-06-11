unit Functions.DB;

interface

uses
  System.SysUtils, Data.DB, Data.Win.ADODB, Vcl.DBGrids;

procedure BatchOperation(ds: TDataSet; f: TProc<TDataSet>);

procedure ADOTransaction(c: TADOConnection; ds: TDataSet; f: TProc<TDataSet>); overload;

procedure ADOTransaction(c: TADOConnection; ds: TDataSet; f: TProc); overload;

procedure ADOBatchTransaction(c: TADOConnection; ds: TDataSet; f: TProc<TDataSet
  >); overload;

procedure ADOBatchTransaction(c: TADOConnection; ds: TDataSet; f: TProc); overload;

procedure BookmarkOperation(ds: TDataSet; f: TProc<TDataSet>);

procedure ForEachBookmark(ds: TDataSet; bookmarks: TBookmarkList; f: TProc<TDataSet>);

procedure SetQuerySql(q: TADOQuery; sql: string);

implementation

procedure SetQuerySql(q: TADOQuery; sql: string);
begin
  q.Close;
  q.SQL.Text := sql;
  q.Open;
end;

procedure ForEachBookmark(ds: TDataSet; bookmarks: TBookmarkList; f: TProc<TDataSet>);
begin
  BookmarkOperation(ds, procedure (_: TDataSet) begin
    for var i := 0 to bookmarks.Count - 1 do begin
      ds.GotoBookmark(bookmarks[i]);
      f(ds);
    end;
  end);
end;

procedure BookmarkOperation(ds: TDataSet; f: TProc<TDataSet>);
begin
  BatchOperation(ds,
    procedure(_: Tdataset)
    begin
      const b = ds.GetBookmark;
      try
        f(ds);
      finally
        if (ds.BookmarkValid(b)) then
          ds.GotoBookmark(b);
        ds.FreeBookmark(b);
      end;
    end);
end;

procedure BatchOperation(ds: TDataSet; f: TProc<TDataSet>);
begin
  ds.DisableControls;
  try
    f(ds);
  finally
    ds.EnableControls;
  end;
end;

procedure ADOTransaction(c: TADOConnection; ds: TDataSet; f: TProc<TDataSet>);
begin
  c.BeginTrans;
  try
    f(ds);
    c.CommitTrans;
  except
    c.RollbackTrans;
    raise;
  end;
end;

procedure ADOTransaction(c: TADOConnection; ds: TDataSet; f: TProc); overload;
begin
  c.BeginTrans;
  try
    f;
    c.CommitTrans;
  except
    c.RollbackTrans;
    raise;
  end;
end;

procedure ADOBatchTransaction(c: TADOConnection; ds: TDataSet; f: TProc<TDataSet>);
begin
  BatchOperation(ds,
    procedure(_: TDataSet)
    begin
      ADOTransaction(c, ds, f);
    end);
end;

procedure ADOBatchTransaction(c: TADOConnection; ds: TDataSet; f: TProc);
begin
  BatchOperation(ds,
    procedure(_: TDataSet)
    begin
      ADOTransaction(c, ds, f);
    end);
end;

end.

