unit Functions.Graphics;

interface

uses
  Vcl.Graphics, Vcl.ExtCtrls, System.SysUtils;

type
  TDrawProc = TProc<TCanvas, Integer, Integer>;

procedure DrawOnImage(img: TImage; DrawProc: TDrawProc);

implementation

procedure DrawOnBitmap(const bmp: TBitmap; const w, h: Integer; DrawProc: TDrawProc);
begin
  var output := TBitmap.Create;
  try
    output.Width := w;
    output.Height := h;
    DrawProc(output.Canvas, w, h);
    bmp.Assign(output);
  finally
    output.Free;
  end;
end;

procedure DrawOnImage(img: TImage; DrawProc: TDrawProc);
begin
  DrawOnBitmap(img.Picture.Bitmap, img.ClientWidth - 1, img.ClientHeight - 1, DrawProc);
end;

end.
