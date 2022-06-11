unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.NumberBox, System.StrUtils;

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
  const param = ParamStr(1);
  const runingDir = ExtractFilePath(Application.ExeName);

  var o: TProcessOptions;
  with o do begin
    output := lstOutput.Items;
    leaveAlone := nmbrbxLeaveAlone.Value;
    span2 := nmbrbx2min.Value;
    span5 := nmbrbx5min.Value;
    span10 := nmbrbx10min.Value;
    span15 := nmbrbx15min.Value;
    path := IfThen(param <> '', param, runingDir);
  end;

  try
    const p = ProcessFiles(o);
    Caption := p.processResult;
  except
    on E: Exception do begin
      const i = lstOutput.Items;
      i.Add('There was an error while processing files:');
      i.Add(e.Message);
      i.Add('');
      i.Add('Are you sure you are running this in your saves folder and have proper permissions?');
    end;
  end;
end;

end.

