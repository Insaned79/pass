unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ComCtrls, ExtCtrls,md5, Types;

type

  { TMainForm }

  TMainForm = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    ExitButton: TLabel;
    FloatSpinEdit1: TFloatSpinEdit;
    GenerateButton: TLabel;
    Label3: TLabel;
    Master: TLabeledEdit;
    Site: TLabeledEdit;
    username: TLabeledEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }


function Get_md5hash(aStr: UTF8String): ansistring;
var
  a: TMDDigest;
  i: integer;
begin
  Result := '';
  a      := MD5String(aStr);
  for i := Low(a) to High(a) do
    Result := Result + IntToHex(a[i], 1);
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  ExitButton.Caption:='Привет мир';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  edit1.text:='';
  mainform.PageControl1.ActivePageIndex:=0;
end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  halt(0);
end;

procedure TMainForm.GenerateButtonClick(Sender: TObject);
var
  sep,gl,sl,s: string;
  k,i: integer;
begin
if mainform.PageControl1.TabIndex=0 then
begin
//Phonteic password generation
  gl:='bdghklmnprstz';
  sl:='aeiou';
  sep:='-=+!@#$%^&*1234567890~_';
  s:='';
  Randomize;
  for k:=1 to round(floatspinedit1.Value) do
  begin
    for i:=1 to 4 do
        begin
            s:=s+gl[random(13)+1]+sl[random(5)+1]
        end;
    if k<floatspinedit1.Value then s:=s+sep[random(length(sep))+1];
  end;
  edit1.Text:=s;
end
else
//from master password generation

s:=master.Text+site.Text+username.Text;
edit2.Text:=Get_md5hash(s);

begin
end;

 // label1.Caption:=Get_md5hash(s);
end;

procedure TMainForm.Label4Click(Sender: TObject);
begin

end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin

end;

procedure TMainForm.TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

end.

