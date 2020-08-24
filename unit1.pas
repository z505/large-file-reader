unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    edFile: TEdit;
    edFrom: TEdit;
    edTo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    mStatus: TMemo;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    SynEdit1: TSynEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { private declarations }
    function ReadFirstLines(fname: string): integer;
    function ReadLines(fname: string; nFrom, nTo: integer): integer;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.ReadFirstLines(fname: string): integer;
var s: string;
    F : TextFile;
    counter: integer;
begin
  counter := 0;
  AssignFile(F, fname);
  Reset(F);
  while not Eof(f) do
  begin
    readln(F, s);
    SynEdit1.Lines.add(s);
    inc(counter);
    if counter = 20 then break;
  end;
  result := counter;
  CloseFile(F);
end;

function TForm1.ReadLines(fname: string; nFrom, nTo: integer): integer;
var s: string;
    F : TextFile;
    counter, linestocount: integer;
    i: integer;
    Buf: Array[1..100000] of byte;
begin
  counter := 0;
  AssignFile(F, fname);
  Reset(F);
  System.SetTextBuf(F,Buf);
//  showmessage(inttostr(nTo - (nFrom-1)));

  // skip to starting line
  for i := 1 to nFrom-1 do readln(F);

  linestocount := nTo - (nFrom-1);

  // now read lines
  while not Eof(f) do
  begin
    readln(F, s);
    SynEdit1.Lines.add(s);
    inc(counter);
    if counter >= linestocount then break;
  end;

  result := counter;
  CloseFile(F);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  linesread: integer;
  fname: string;
begin
  fname := edFile.text;
  if fname = '' then exit;
  if not FileExists(fname) then begin
    showmessage('file not found: '+ fname);
    exit;
  end;
  synedit1.text := '';
  linesread := ReadFirstLines(fname);
  mStatus.Lines.Add('Read ' + inttostr(linesread) + ' lines in ' + fname);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then edFile.text := OpenDialog1.Filename;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  linesread: integer;
  fname: string;
  nFrom, nTo: integer;
begin
  fname := edFile.text;
  if fname = '' then exit;
  if not FileExists(fname) then begin
    showmessage('file not found: '+ fname);
    exit;
  end;
  if not TryStrToInt(edFrom.Text, nFrom) then begin
    showmessage('invalid "from" line number');
    exit;
  end;
  if not TryStrToInt(edTo.Text, nTo) then begin
    showmessage('invalid "to" number');
    exit;
  end;
  synedit1.Text:='';
  linesread := ReadLines(fname, nFrom, nTo);
  mStatus.Lines.Add('Read ' + inttostr(linesread) + ' lines in ' + fname);
end;

end.

