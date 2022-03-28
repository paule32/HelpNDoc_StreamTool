program strmtool;

uses
  SysUtils,
  Forms,
  Dialogs,
  Unit1 in 'Unit1.pas' {Form1},
  ResString in 'ResString.pas',
  HelpNdocException in 'HelpNdocException.pas';

{$E exe}

{$R *.res}

begin
  try
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Application.Run;
  except
    on e: NoErrorException    do begin if Form1 <> nil then Form1.Memo1.Lines.Insert(0,'no error.');  end;
    on e: yyErrorException    do begin if Form1 <> nil then Form1.Memo1.Lines.Insert(0,Format('Error: %s', [e.Message])); end;

    on e: EofCheckException   do begin if Form1 <> nil then Form1.Memo1.Lines.Insert(0,'eof reached.'); end;

    on e: SaveDialogException do begin if Form1 <> nil then Form1.Memo1.Lines.Insert(0,Format('Save-Error: %s', [e.Message])); end;
    on e: LoadDialogException do begin if Form1 <> nil then Form1.Memo1.Lines.Insert(0,Format('Load-Error: %s', [e.Message])); end;

    on e: Exception do
    begin
      Form1.Memo1.Lines.Insert(0,e.Message);
    end;
  end;
end.

