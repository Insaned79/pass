unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ComCtrls, ExtCtrls, md5, Types, LazUTF8, INIFiles, StrUtils, Clipbrd ;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    ExitButton: TLabel;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    GenerateButton: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Master: TLabeledEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Site: TLabeledEdit;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ToggleBox1: TToggleBox;
    username: TLabeledEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FloatSpinEdit1Change(Sender: TObject);
    procedure FloatSpinEdit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ExitButtonClick(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure MasterChange(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure SiteChange(Sender: TObject);
    procedure TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: boolean);
    procedure ToggleBox1Change(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure usernameChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  IniF: TINIFile;
  IniF2: TINIFile;
  digit_mass:TStringList;
  word1_mass:TStringList;
  word2_mass:TStringList;
  word3_mass:TStringList;
  phase_count:Integer;
  vipnet_loaded:Boolean;
implementation

{$R *.lfm}

{ TMainForm }



function SplitString(Source: string; Delim: TSysCharSet) : TStringList ;
var
  Count_str,i : Integer;
  L :  TStringList;

begin
  Count_str:= WordCount(Source, Delim);
  phase_count:=Count_str;
  L:=TStringList.Create;
  if Count_str > 1 then
     for i := 1 to Count_str do
          L.Add(ExtractWord(i,Source,Delim));


    Result:=L;



end;

function ReplaceRusToLat(const RusChar: String): String;
var
  i,len:Integer;
  search1:String;
  replace1: String;
  temp1: String;
begin
   search1:='qwertyuiop[]asdfghjkl;''zxcvbnm,./QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>?1234567890';
   replace1:='йцукенгшщзхъфывапролджэячсмитьбю.ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ,1234567890';
   Result:='';
   len:= UTF8Length(replace1);
   for i:=1 to len do
   begin
       temp1:=UTF8Copy(replace1,i,1);
       if RusChar = temp1 then
        begin
            Result:=search1[i];
            Break;
        end
       else
       begin
         Result:= RusChar;
       end;

   end;

end;

function RusToLat(const RusText: String): String;
var
  len,i: Integer;
  temp_string:String;
begin
   len:= UTF8Length(RusText);
   temp_string:='';
   for i:=1 to len do
   begin
       temp_string:=temp_string+ReplaceRusToLat(UTF8Copy(RusText,i,1));
   end;
   Result:= temp_string;
end;



function Get_md5hash(aStr: UTF8String): ansistring;
var
  a: TMDDigest;
  i: integer;
begin
  Result := '';
  a := MD5String(aStr);
  for i := Low(a) to High(a) do
    Result := Result + IntToHex(a[i], 1);
end;

function trim(s: UTF8String): ansistring;

begin

  if length(s) > 0 then
    try
      while s[1] = ' ' do
        if length(s) > 0 then
          Delete(s, 1, 1);
      while s[length(s)] = ' ' do
        if length(s) > 0 then
          Delete(s, length(s), 1);
    except

    end;
  Result := s;

end;


procedure TMainForm.Button1Click(Sender: TObject);


begin
  Clipboard.AsText := edit2.text;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
   Clipboard.AsText := edit1.text;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
   Clipboard.AsText := edit3.text;
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
    Clipboard.AsText := edit5.text;
end;

procedure TMainForm.CheckBox1Change(Sender: TObject);
begin
    inif.WriteBool('Main', 'Numbers', CheckBox1.Checked);

end;

procedure TMainForm.CheckBox2Change(Sender: TObject);
begin
  inif.WriteBool('Main', 'Symbols', CheckBox2.Checked);
end;

procedure TMainForm.Edit1Change(Sender: TObject);
begin

end;

procedure TMainForm.FloatSpinEdit1Change(Sender: TObject);
begin
  inif.WriteInteger('Main', 'Length', round(floatspinedit1.Value));
end;

procedure TMainForm.FloatSpinEdit2Change(Sender: TObject);
begin
  inif.WriteInteger('Main', 'Simple_Length', round(floatspinedit2.Value));
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure load_vipnet();
var
  inifile: string;
  inipass: string;
  f: textfile;
  fp: textfile;
  digit:String;
  word1:String;
  word2:String;
  word3:String;
  i:Integer;
  delemiter:TSysCharSet;
  a: string;
begin

   inipass:=ExtractFileDir(paramstr(0));
   inipass := inipass + '/vipnetpass.ini';


  try
    //check vipnet ini file
    if (FileExists(inipass)) then
    begin
      Inif2 := TINIFile.Create(inipass);

    end
    else
    begin
      if not DirectoryExists(ExtractFileDir(inipass)) then
        CreateDir(ExtractFileDir(inipass));
      AssignFile(fp, inipass);
      rewrite(fp);
      closefile(fp);
      Inif2 := TINIFile.Create(inipass);
    end;
    digit := Inif2.ReadString('main', 'digit','');
    word1 := Inif2.ReadString('main', 'word1','');
    word2 := Inif2.ReadString('main', 'word2','');
    word3 := Inif2.ReadString('main', 'word3','');

    delemiter := [','];
    digit_mass := SplitString(digit, delemiter);
    word1_mass := SplitString(word1,delemiter);
    word2_mass := SplitString(word2,delemiter);
    word3_mass := SplitString(word3,delemiter);
    vipnet_loaded:=True;
  except
  end;

end;

procedure TMainForm.FormCreate(Sender: TObject);


var
  inifile: string;
  inipass: string;
  f: textfile;
  fp: textfile;
  digit:String;
  word1:String;
  word2:String;
  word3:String;
  i:Integer;
  delemiter:TSysCharSet;
  a: string;

begin
  edit1.Text := '';
  edit2.Text := '';
  mainform.PageControl1.ActivePageIndex := 0;


  vipnet_loaded:=False;


  inifile := GetAppConfigDir(False);
  inifile := inifile + 'settings.ini';


  try
    if (FileExists(inifile)) then
    begin
      Inif := TINIFile.Create(inifile);

    end
    else
    begin
      if not DirectoryExists(ExtractFileDir(inifile)) then
        CreateDir(ExtractFileDir(inifile));
      AssignFile(f, inifile);
      rewrite(f);
      closefile(f);
      Inif := TINIFile.Create(inifile);
    end;
    site.Text := inif.ReadString('Main', 'Site', '');
    username.Text := inif.ReadString('Main', 'Username', '');
    floatspinedit1.Value := inif.ReadInteger('Main', 'Length', 2);
    floatspinedit2.Value := inif.ReadInteger('Main', 'Simple_Length', 12);
    togglebox1.Checked := inif.ReadBool('Main', 'Asterisk', True);
    CheckBox1.Checked := inif.ReadBool('Main', 'Numbers', True);
    CheckBox2.Checked := inif.ReadBool('Main', 'Symbols', True);
    mainform.PageControl1.TabIndex := inif.ReadInteger('Main', 'Mode', 0);
    mainform.ToggleBox1Change(nil);



  except
  end;

end;

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  halt(0);
end;


function create_password_from_master (master,site,username: string) : string;

begin
  create_password_from_master := Get_md5hash(trim(master)+trim(utf8uppercase(site))+trim(utf8uppercase(username)))
end;

procedure TMainForm.GenerateButtonClick(Sender: TObject);
var
  sep, gl, sl, s,passw,ruspassw: string;
  k, i, d1,w1,w2,w3: integer;


begin
     Randomize;
  //if mainform.PageControl1.TabIndex = 0 then
  case mainform.PageControl1.TabIndex of
  //Phonteic password generation
    0: begin
    gl := 'bdghklmnprstz';
    sl := 'aeiou';
    sep := '-=+!@#$%^&*1234567890~_';
    s := '';

    for k := 1 to round(floatspinedit1.Value) do
    begin
      for i := 1 to 4 do
      begin
        s := s + gl[random(13) + 1] + sl[random(5) + 1];
      end;
      if k < floatspinedit1.Value then
        s := s + sep[random(length(sep)) + 1];
    end;
    edit1.Text := s;
  end;
  //from master password generation
  1: begin
      //s := trim(master.Text) + trim(utf8uppercase(site.Text)) + trim(utf8uppercase(username.Text));
      //edit2.Text := Get_md5hash(s);
      Edit2.Text:= create_password_from_master(master.text,site.text,username.text);

  end;
  // Vipnet way
  2: begin
       if not vipnet_loaded then
       begin
            MainForm.Cursor:=CrHourGlass;
            GenerateButton.Cursor:=crHourGlass;
            application.ProcessMessages;
            load_vipnet();
            MainForm.Cursor:=CrDefault;
            GenerateButton.Cursor:=crHandPoint;
       end;
       d1:=Random(phase_count);
       w1:=Random(phase_count);
       w2:=Random(phase_count);
       w3:=Random(phase_count);
       ruspassw:=  digit_mass[d1] + ' ' + word1_mass[w1] + ' ' + word2_mass[w2] + ' ' + word3_mass[w3];
       Edit4.Text:=  ruspassw;
       passw:= UTF8Copy(word1_mass[w1],1,3) + UTF8Copy(word2_mass[w2],1,3) + UTF8Copy(word3_mass[w3],1,3);
       passw:=RusToLat(passw);
       Edit3.Text:=digit_mass[d1]+passw;
     end;
  3: begin
          s:='QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm';
          if checkbox1.Checked then s:=s+'1234567890';
          if checkbox2.Checked then s:=s+'~!@#$%^&*()_+=<>?';
          edit5.text:='';
          for i:=1 to round(FloatSpinEdit2.Value) do
          begin
               edit5.Text:=edit5.Text+s[Random(length(s))+1];
          end;
     end;
  end;
end;



procedure TMainForm.Label4Click(Sender: TObject);
begin

end;

procedure TMainForm.MasterChange(Sender: TObject);
begin
  Edit2.Text:= create_password_from_master(master.text,site.text,username.text);
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
  inif.WriteInteger('Main', 'Mode', mainform.PageControl1.TabIndex);
end;

procedure TMainForm.Panel1Click(Sender: TObject);
begin

end;

procedure TMainForm.SiteChange(Sender: TObject);
begin
  inif.WriteString('Main', 'Site', site.Text);
end;

procedure TMainForm.TabSheet2ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: boolean);
begin

end;

procedure TMainForm.ToggleBox1Change(Sender: TObject);
begin
  if togglebox1.Checked then
    master.PasswordChar := '*'
  else
    master.PasswordChar := #0;
  inif.WriteBool('Main', 'Asterisk', togglebox1.Checked);

end;

procedure TMainForm.TrayIcon1Click(Sender: TObject);
begin

end;

procedure TMainForm.usernameChange(Sender: TObject);
begin
  inif.WriteString('Main', 'Username', username.Text);
end;




end.
