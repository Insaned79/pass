unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ComCtrls, ExtCtrls,md5, Types,LazUTF8,INIFiles;

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
    ToggleBox1: TToggleBox;
    username: TLabeledEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SiteChange(Sender: TObject);
    procedure TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure ToggleBox1Change(Sender: TObject);
    procedure usernameChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  IniF:TINIFile;

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

function trim(s: UTF8String): ansistring;

begin

if length(s)>0 then
try
   while s[1]=' ' do if length(s)>0 then delete (s,1,1);
   while s[length(s)]=' ' do  if length(s)>0 then delete (s,length(s),1);
except

end;
result:=s;

end;

procedure TMainForm.Button1Click(Sender: TObject);
begin


end;

procedure TMainForm.FloatSpinEdit1Change(Sender: TObject);
begin
  inif.WriteInteger('Main','Length', round(floatspinedit1.Value) );
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  inifile: string;
  f: textfile;
begin
  edit1.text:='';
  edit2.text:='';
  mainform.PageControl1.ActivePageIndex:=0;

//inifile:=ExtractFileDir(paramstr(0));
inifile:=GetAppConfigDir(False);
inifile:=inifile+'settings.ini';


try
IF(FileExists(inifile))then
    begin
         Inif := TINIFile.Create(inifile);
         //Writeln(INiF.ReadString('s1','Key1',''));
    End
else
    begin
      if not DirectoryExists(ExtractFileDir(inifile)) then CreateDir(ExtractFileDir(inifile));
      AssignFile(f,inifile);
      rewrite(f);
      closefile(f);
      Inif := TINIFile.Create(inifile);
    end;
site.Text:=inif.ReadString('Main','Site','');
username.Text:=inif.ReadString('Main','Username','');
floatspinedit1.Value:=inif.ReadInteger('Main','Length',2);
togglebox1.Checked:=inif.ReadBool('Main','Asterisk',true);
mainform.ToggleBox1Change(nil);
except
end;


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

begin
  s:=trim(master.Text)+trim(utf8uppercase(site.Text))+trim(utf8uppercase(username.Text));
  edit2.Text:=Get_md5hash(s);
end;


end;

procedure TMainForm.Label4Click(Sender: TObject);
begin

end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin

end;

procedure TMainForm.SiteChange(Sender: TObject);
begin
  inif.WriteString('Main','Site',site.Text);
end;

procedure TMainForm.TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TMainForm.ToggleBox1Change(Sender: TObject);
begin
if togglebox1.Checked then  master.PasswordChar:='*'
   else master.PasswordChar:=#0;
inif.WriteBool('Main','Asterisk',togglebox1.Checked);

end;

procedure TMainForm.usernameChange(Sender: TObject);
begin
inif.WriteString('Main','Username',username.Text);
end;

end.

