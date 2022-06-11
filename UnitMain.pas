unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.NumberBox, System.IOUtils;

type
  TfrmMain = class(TForm)
    ctgrypnlgrp1: TCategoryPanelGroup;
    ctgrypnlOptions: TCategoryPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl41: TLabel;
    lbl411: TLabel;
    lbl412: TLabel;
    nmbrbxLeaveAlone: TNumberBox;
    nmbrbx2min: TNumberBox;
    nmbrbx5min: TNumberBox;
    nmbrbx10min: TNumberBox;
    nmbrbx15min: TNumberBox;
    lstOutput: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Backend;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  var o: TProcessOptions;
  with o do begin
    output := lstOutput.Items;
    leaveAlone := nmbrbxLeaveAlone.Value;
    span2 := nmbrbx2min.Value;
    span5 := nmbrbx5min.Value;
    span10 := nmbrbx10min.Value;
    span15 := nmbrbx15min.Value;
    path := 'F:\Skyrim SE\MO2\profiles\3BBB\saves';
  end;
  const f = ProcessFiles(o);
  Caption := f.ToString;
end;

end.
