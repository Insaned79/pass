unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin;

type

  { TMainForm }

  TMainForm = class(TForm)
    Edit1: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    ExitButton: TLabel;
    GenerateButton: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  ExitButton.Caption:='Привет мир';
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  edit1.text:='';
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

end;

procedure TMainForm.Label4Click(Sender: TObject);
begin

end;

end.

