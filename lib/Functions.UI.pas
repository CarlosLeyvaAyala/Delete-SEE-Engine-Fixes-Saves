unit Functions.UI;

interface

uses
  Vcl.Forms, Vcl.Controls, System.SysUtils;

type
  TFormClass = class of TCustomForm;

procedure ExecuteDlg(dlgClass: TFormClass; f: TProc<TCustomForm>; parent: TControl = nil);

implementation

procedure ExecuteDlg(dlgClass: TFormClass; f: TProc<TCustomForm>; parent: TControl);
var
  frm: TCustomForm;
begin
  frm := dlgClass.Create(parent);
  try
    f(frm);
  finally
    frm.Free;
  end;
end;

end.

