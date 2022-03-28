unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ExtCtrls, SynEdit,
  ToolWin, StdCtrls, ShellAPI,

  ResString,

  JvMenus,
  JvExControls, JvArrowButton,
  madExceptVcl, HTMLUn2, HtmlView, JvAppInst, JvExStdCtrls, JvMemo,
  JvLabel, JvEdit, ImgList, JvBaseDlg, JvPageSetup, JvPageSetupTitled,
  JvComponentBase, JvFindReplace, JvDialogs, SynEditMiscClasses,
  SynEditRegexSearch, JvGradientCaption, Mask, JvExMask, JvToolEdit,
  JvXPCore, XPMan, JvExComCtrls, JvStatusBar, SynCompletionProposal,
  SynEditHighlighter, SynHighlighterHelpNdoc, JvCreateProcess;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    Splitter2: TSplitter;
    Panel1: TPanel;
    TreeView1: TTreeView;
    JvArrowButton1: TJvArrowButton;
    JvPopupMenu1: TJvPopupMenu;
    JvOfficeMenuItemPainter1: TJvOfficeMenuItemPainter;
    NewTopic1: TMenuItem;
    NewProperty1: TMenuItem;
    NewItem1: TMenuItem;
    Image1: TMenuItem;
    HTMLText1: TMenuItem;
    NormalTopic1: TMenuItem;
    Hidden1: TMenuItem;
    JvPopupMenu2: TJvPopupMenu;
    JvOfficeMenuItemPainter2: TJvOfficeMenuItemPainter;
    NewKeyword1: TMenuItem;
    N3: TMenuItem;
    FileList1: TMenuItem;
    JvMainMenu1: TJvMainMenu;
    JvOfficeMenuItemPainter3: TJvOfficeMenuItemPainter;
    MainMenu_File: TMenuItem;
    MainMenu_Edit: TMenuItem;
    MainMenu_Help: TMenuItem;
    MainMenu_Edit_About: TMenuItem;
    MainMenu_File_New: TMenuItem;
    MainMenu_File_OpenFile: TMenuItem;
    MainMenu_File_Save: TMenuItem;
    MainMenu_File_SaveAs: TMenuItem;
    N4: TMenuItem;
    MainMenu_File_Close: TMenuItem;
    N5: TMenuItem;
    MainMenu_File_Exit: TMenuItem;
    MainMenu_Edit_Settings: TMenuItem;
    MainMenu_Edit_Settings_Project: TMenuItem;
    N1: TMenuItem;
    MainMenu_Edit_Settings_Language: TMenuItem;
    MainMenu_Edit_Settings_Language_English: TMenuItem;
    MainMenu_Edit_Settings_Language_German: TMenuItem;
    JvAppInstances1: TJvAppInstances;
    ImageList1: TImageList;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    JvSaveDialog1: TJvSaveDialog;
    JvOpenDialog1: TJvOpenDialog;
    N2: TMenuItem;
    FindReplaceText1: TMenuItem;
    FindDialog1: TFindDialog;
    ReplaceDialog1: TReplaceDialog;
    ReplaceText1: TMenuItem;
    JvComboEdit1: TJvComboEdit;
    JvLabel7: TJvLabel;
    JvXPStyleManager1: TJvXPStyleManager;
    Panel3: TPanel;
    Splitter1: TSplitter;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    PageControl4: TPageControl;
    TabSheet6: TTabSheet;
    SynEdit1: TSynEdit;
    TabSheet7: TTabSheet;
    Panel5: TPanel;
    HtmlViewer1: THtmlViewer;
    TabSheet3: TTabSheet;
    ScrollBox1: TScrollBox;
    PageControl3: TPageControl;
    TabSheet4: TTabSheet;
    ScrollBox3: TScrollBox;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvEdit1: TJvEdit;
    JvEdit2: TJvEdit;
    JvEdit3: TJvEdit;
    JvEdit4: TJvEdit;
    JvEdit5: TJvEdit;
    JvMemo1: TJvMemo;
    TabSheet5: TTabSheet;
    ScrollBox2: TScrollBox;
    Splitter3: TSplitter;
    Panel4: TPanel;
    JvArrowButton2: TJvArrowButton;
    TreeView2: TTreeView;
    XPManifest1: TXPManifest;
    JvGradientCaption1: TJvGradientCaption;
    JvStatusBar1: TJvStatusBar;
    ProgressBar1: TProgressBar;
    SynAutoComplete1: TSynAutoComplete;
    SynHelpNdocSyn1: TSynHelpNdocSyn;
    Memo1: TMemo;
    procedure NewTopic1Click(Sender: TObject);
    procedure MainMenu_File_ExitClick(Sender: TObject);
    procedure MainMenu_Edit_AboutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MainMenu_Edit_Settings_Language_GermanClick(Sender: TObject);
    procedure MainMenu_Edit_Settings_Language_EnglishClick(
      Sender: TObject);
    procedure MainMenu_Edit_Settings_ProjectClick(Sender: TObject);
    procedure PageControl2Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure SynEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure FindReplaceText1Click(Sender: TObject);
    procedure ReplaceText1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure ReplaceDialog1Find(Sender: TObject);
    procedure MainMenu_FileMeasureItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer);
    procedure JvMainMenu1MeasureItem(Sender: TMenu; Item: TMenuItem;
      var Width, Height: Integer);
    procedure ToolButton2Click(Sender: TObject);
    procedure JvOpenDialog1Error(Sender: TObject; ErrorCode: Cardinal);
    procedure ToolButton3Click(Sender: TObject);
  private
  public
    FileOut : TextFile;
    FileName: String;

    function writeFileContent: String;

  end;


var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  HelpNdocException;

var
  // these 2 vars for search/replace dialogs
  fPos : Integer;
  found: Boolean;


  function TForm1.writeFileContent: String;
  var i, len: Integer;
  begin
    result := '';
    if JvSaveDialog1.Execute then
    begin
      FileName := JvSaveDialog1.FileName;
      len := Length(SynEdit1.Lines.Text);

      if Length(FileName) < 1 then
      raise Exception.Create('no input file available.');

      PageControl2.Pages[0].Caption :=
      ExtractFileName(FileName);

      ProgressBar1.Position := 0;
      ProgressBar1.Max := len;

      AssignFile(FileOut, FileName);
      ReWrite(FileOut);

      for i := 1 to len do
      begin
        Write(FileOut, SynEdit1.Lines.Text[i]);
        ProgressBar1.Position := i;
      end;

      SynEdit1.Modified := false;
      CloseFile(FileOut);
    end else
    begin
      raise SaveDialogException.Create('something goes wrong.' +
      #13#10 + 'Translation aborted.');
    end;
    result := FileName;
  end;

procedure setSelLength(var textComponent:TSynEdit; newValue:integer);
begin
  textComponent.SelEnd := textComponent.SelStart + newValue;
end;

procedure TForm1.NewTopic1Click(Sender: TObject);
begin
  if TreeView1.Selected <> nil then
  begin
    if APP_LANGUAGE = LANG_ENG then
    TreeView1.Items.Add(TreeView1.Selected, ENG_STR_NEW_TOPIC) else
    TreeView1.Items.Add(TreeView1.Selected, DEU_STR_NEW_TOPIC)
  end;
end;

procedure TForm1.MainMenu_File_ExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MainMenu_Edit_AboutClick(Sender: TObject);
begin
  ShowMessage('HelpNdoc stream Tool' +
  #13#10 + 'Version 1.0' +
  #13#10 +
  #13#10 + 'copyright (c) 2022 IBE-Software');
end;

{ set the defualt application language to "english" }
{ the most textual items should be changed to the new language }
procedure TForm1.FormCreate(Sender: TObject);
begin
  { Options-Tabsheet }
  PageControl2.Pages[1].Caption := ENG_STR_TABSHEET_PROJECT_OPTIONS;
  PageControl2.Pages[1].TabVisible := false;

  MainMenu_Edit_Settings_Language_English.Checked := true;
  MainMenu_File.Caption := ENG_STR_MAINMENU_FILE;

  MainMenu_Edit                           .Caption := ENG_STR_MAINMENU_EDIT;
  MainMenu_Edit_Settings                  .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS;
  MainMenu_Edit_Settings_Project          .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_PROJECT;
  MainMenu_Edit_Settings_Language         .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE;
  MainMenu_Edit_Settings_Language_English .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_ENGLISH;
  MainMenu_Edit_Settings_Language_German  .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_GERMAN;

  MainMenu_Help.Caption := ENG_STR_MAINMENU_HELP;

  { button category "left" }
  JvArrowButton1.Caption := ENG_STR_SET_CATEGORY;

  { Editor }
  PageControl4.ActivePageIndex := 0;
end;

{ set the application language to "german" }
{ the most textual items should be changed to the new language }
procedure TForm1.MainMenu_Edit_Settings_Language_GermanClick(
  Sender: TObject);
begin
  MainMenu_Edit_Settings_Language_English.Checked := false;
  MainMenu_Edit_Settings_Language_German .Checked := true;

  MainMenu_File.Caption := DEU_STR_MAINMENU_FILE;

  MainMenu_Edit                           .Caption := DEU_STR_MAINMENU_EDIT;
  MainMenu_Edit_Settings                  .Caption := DEU_STR_MAINMENU_EDIT_SETTINGS;
  MainMenu_Edit_Settings_Project          .Caption := DEU_STR_MAINMENU_EDIT_SETTINGS_PROJECT;
  MainMenu_Edit_Settings_Language         .Caption := DEU_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE;
  MainMenu_Edit_Settings_Language_English .Caption := DEU_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_ENGLISH;
  MainMenu_Edit_Settings_Language_German  .Caption := DEU_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_GERMAN;

  MainMenu_Help.Caption := DEU_STR_MAINMENU_HELP;

  { button category "left" }
  JvArrowButton1.Caption := DEU_STR_SET_CATEGORY;
  JvArrowButton2.Caption := DEU_STR_SET_CATEGORY;

  { Options-Tabsheet }
  PageControl2.Pages[1].Caption := DEU_STR_TABSHEET_PROJECT_OPTIONS;
end;

{ set the application language to "english" }
{ the most textual items should be changed to the new language }
procedure TForm1.MainMenu_Edit_Settings_Language_EnglishClick(
  Sender: TObject);
begin
  MainMenu_Edit_Settings_Language_German .Checked := false;
  MainMenu_Edit_Settings_Language_English.Checked := true;

  MainMenu_File.Caption := ENG_STR_MAINMENU_FILE;

  MainMenu_Edit                           .Caption := ENG_STR_MAINMENU_EDIT;
  MainMenu_Edit_Settings                  .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS;
  MainMenu_Edit_Settings_Project          .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_PROJECT;
  MainMenu_Edit_Settings_Language         .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE;
  MainMenu_Edit_Settings_Language_English .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_ENGLISH;
  MainMenu_Edit_Settings_Language_German  .Caption := ENG_STR_MAINMENU_EDIT_SETTINGS_LANGUAGE_GERMAN;

  MainMenu_Help.Caption := ENG_STR_MAINMENU_HELP;

  { button category "left" }
  JvArrowButton1.Caption := ENG_STR_SET_CATEGORY;
  JvArrowButton2.Caption := ENG_STR_SET_CATEGORY;

  { Options-Tabsheet }
  PageControl2.Pages[1].Caption := ENG_STR_TABSHEET_PROJECT_OPTIONS;
end;

procedure TForm1.MainMenu_Edit_Settings_ProjectClick(Sender: TObject);
begin
  { Options-Tabsheet }
  PageControl2.Pages[1].TabVisible := true;
  PageControl2.ActivePageIndex := 1;
end;

procedure TForm1.PageControl2Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  { Options-Tabsheet }
  if (PageControl2.ActivePage.Caption = ENG_STR_TABSHEET_PROJECT_OPTIONS)
  or (PageControl2.ActivePage.Caption = DEU_STR_TABSHEET_PROJECT_OPTIONS) then
  PageControl2.Pages[1].TabVisible := false;
end;

procedure TForm1.SynEdit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  len     : Integer;

  procedure CaptureConsoleOutput(const ACommand, AParameters: String; AMemo: TMemo);
  const
    CReadBuffer = 2400;
  var
    saSecurity: TSecurityAttributes;
    hRead: THandle;
    hWrite: THandle;
    suiStartup: TStartupInfo;
    piProcess: TProcessInformation;
    pBuffer: array[0..CReadBuffer] of Char;
    dRead: DWord;
    dRunning: DWord;
  begin
    saSecurity.nLength := SizeOf(TSecurityAttributes);
    saSecurity.bInheritHandle := True;
    saSecurity.lpSecurityDescriptor := nil;

    if CreatePipe(hRead, hWrite, @saSecurity, 0) then
    begin
      SetHandleInformation(hRead, HANDLE_FLAG_INHERIT, 0);
      FillChar(suiStartup, SizeOf(TStartupInfo), #0);
      suiStartup.cb := SizeOf(TStartupInfo);
      suiStartup.hStdOutput := hWrite;
      suiStartup.hStdError := hWrite;
      suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      suiStartup.wShowWindow := SW_HIDE;

      if CreateProcess(nil, PChar(ACommand + ' ' + AParameters), @saSecurity,
        @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup, piProcess)
        then
      begin
        repeat
          dRunning  := WaitForSingleObject(piProcess.hProcess, 100);
          Application.ProcessMessages();
          repeat
            dRead := 0;
            ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
            pBuffer[dRead] := #0;

            OemToAnsi(pBuffer, pBuffer);
            AMemo.Lines.Add(String(pBuffer));
          until (dRead < CReadBuffer);
        until (dRunning <> WAIT_TIMEOUT);
        CloseHandle(piProcess.hProcess);
        CloseHandle(piProcess.hThread);
      end;

      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;
  end;
  procedure ExecuteShellCommand(cmdline: string; hidden: Boolean);
  const
    flags: array [Boolean] of Integer = (SW_SHOWNORMAL, SW_HIDE);
  var
    cmdbuffer: array [0..MAX_PATH] of Char;
  begin
    GetEnvironmentVariable('COMSPEC', cmdBUffer, SizeOf(cmdBuffer));
    StrCat(cmdbuffer, ' /C ');
    StrPCopy(StrEnd(cmdbuffer), cmdline);
    WinExec(cmdbuffer, flags[hidden]);
  end;
var
  res    : Integer;
  buf    : PChar  ;
  exe,bat: String ;
  prg,quo: String ;
  smsg   : String ;
  path   : String ;
  stream : TFileStream;
begin
  if key = VK_F2 then
  begin
    if (SynEdit1.Modified)
    or (PageControl2.Pages[0].Caption = 'Unknown') then
    FileName := writeFileContent;

    Memo1.Lines.Clear;

    // TODO: example of translate application:
    path := ExtractFilePath(Application.ExeName);
    quo  := '"';
    exe  := quo + path + 'test\parser.exe' + quo + #32;
    prg  := quo + FileName + quo ;

    CaptureConsoleOutput(exe, prg, Form1.Memo1);

  end;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
var key: Word;
begin
  key := VK_F2;
  SynEdit1KeyDown(Sender, key, []);
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
  if (SynEdit1.Modified) and (PageControl2.Pages[0].Caption = 'Unknown') then
  begin
    writeFileContent;
    SynEdit1.Lines.Clear;
    PageControl2.Pages[0].Caption := 'Unknown';
    exit;
  end;

  if (SynEdit1.Modified) then
  begin
    writeFileContent;
    SynEdit1.Lines.Clear;
    PageControl2.Pages[0].Caption := 'Unknown';
    exit;
  end;

  SynEdit1.Lines.Clear;
  PageControl2.Pages[0].Caption := 'Unknown';

end;

procedure TForm1.FindReplaceText1Click(Sender: TObject);
var s: String;
begin
  findDialog1.execute;
end;

procedure TForm1.ReplaceText1Click(Sender: TObject);
begin
  replaceDialog1.execute;
end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
begin
  if TreeView1.Selected.Parent <> nil then
  begin
    if TreeView1.Selected.Parent.Text = 'Topic Index' then
    begin
    end;
  end;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  FindS: String;
  IPos, FLen, SLen: Integer;
  Res : integer;
begin
  {FPos is global}
  Found := False;
  FLen  := Length(FindDialog1.FindText);
  SLen  := Length(SynEdit1.Text);
  FindS := FindDialog1.FindText;

  if frMatchcase in FindDialog1.Options then
  IPos := Pos(FindS, Copy(SynEdit1.Text,FPos+1,SLen-FPos)) else
  IPos := Pos(AnsiUpperCase(FindS),AnsiUpperCase( Copy(SynEdit1.Text,FPos+1,SLen-FPos)));

  dec(Fpos);
  If IPos > 0 then
  begin
    FPos := FPos + IPos;
    SynEdit1.SetFocus;
    Self.ActiveControl := SynEdit1;
    SynEdit1.SelStart:= FPos;
    setSelLength(SynEdit1, FLen);
    Found := True;
    FPos  := FPos + FLen-1;
  end else
  begin
    If not (FindDialog1.Options*[frReplaceAll] = [frReplaceAll]) then
      Res := Application.MessageBox('Text was not found!', 'Replace',
      mb_OK + mb_ICONWARNING);
    FPos := 0;
  end;
end;

procedure TForm1.ReplaceDialog1Replace(Sender: TObject);
var
    Res, replaceCount:integer;   //added by mike
    countInfo:string;
begin
  If Found = False then       {If no search for string took place}
  begin
    ReplaceDialog1Find(Sender); {Search for string, replace if found}
    If Length(SynEdit1.SelText) > 0 then
        SynEdit1.SelText :=  ReplaceDialog1.ReplaceText;
  end
  Else                          {If search ran, replace string}
  begin
    If Length(SynEdit1.SelText) > 0 then
        SynEdit1.SelText := ReplaceDialog1.ReplaceText;
  end;
  Found := False;
  setSelLength(SynEdit1, 0);    //Memo1.SelLength := 0;
  {Hvis Erstatt alle...}
  If (ReplaceDialog1.Options*[frReplaceAll] = [frReplaceAll]) then begin
      replaceCount:=0;
      Repeat
        ReplaceDialog1Find(Sender); {Search for string, replace if found}
        If Length(SynEdit1.SelText) > 0 then begin
            SynEdit1.SelText := ReplaceDialog1.ReplaceText;
            replaceCount:=replaceCount+1;
        end;                                   //laz, syn
      until Found = False;
      if replaceCount>0 then
         replaceCount:=replaceCount+1;   //the first 1, then loop for rest  - mike
      countInfo:=inttostr(replaceCount)+'  replacements made.';
      Res := Application.MessageBox(pchar(countInfo),
             'Replace', mb_OK + mb_ICONINFORMATION);

  end;
end;

procedure TForm1.ReplaceDialog1Find(Sender: TObject);
var
  FindS: String;
  IPos, FLen, SLen: Integer; {Internpos, Lengde søkestreng, lengde memotekst}
  Res : integer;
begin
  {FPos is global}
  Found:= False;
  FLen := Length(ReplaceDialog1.FindText);
  SLen := Length(SynEdit1.Text);
  FindS := ReplaceDialog1.FindText;

 //following 'if' added by mike
  if frMatchcase in ReplaceDialog1.Options then
     IPos := Pos(FindS, Copy(SynEdit1.Text,FPos+1,SLen-FPos))
  else
     IPos := Pos(AnsiUpperCase(FindS),AnsiUpperCase( Copy(SynEdit1.Text,FPos+1,SLen-FPos)));

  If IPos > 0 then begin
    FPos := FPos + IPos;
    SynEdit1.SetFocus;
    Self.ActiveControl := SynEdit1;
    SynEdit1.SelStart:= FPos;
    setSelLength(SynEdit1, FLen);
    Found := True;
    FPos  := FPos+FLen-1;
  end else
  begin
    If not (ReplaceDialog1.Options*[frReplaceAll] = [frReplaceAll]) then
      Res := Application.MessageBox('Text was not found!', 'Replace',
      mb_OK + mb_ICONWARNING);
    FPos := 0;
  end;
end;

procedure TForm1.MainMenu_FileMeasureItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
begin
  ACanvas.Font.Size  := 10;
  ACanvas.Font.Name  := 'Comic Sans MS';
  ACanvas.Font.Color := clBlack;

  if APP_LANGUAGE = LANG_DEU then Width  := ACanvas.TextWidth(DEU_STR_MAINMENU_FILE) else
  if APP_LANGUAGE = LANG_ENG then Width  := ACanvas.TextWidth(ENG_STR_MAINMENU_FILE) ;

  if APP_LANGUAGE = LANG_DEU then Height := ACanvas.TextHeight(DEU_STR_MAINMENU_FILE) else
  if APP_LANGUAGE = LANG_ENG then Height := ACanvas.TextHeight(ENG_STR_MAINMENU_FILE) ;

end;

procedure TForm1.JvMainMenu1MeasureItem(Sender: TMenu; Item: TMenuItem;
  var Width, Height: Integer);
begin
  if item = MainMenu_File then Height := 20;
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  if JvOpenDialog1.Execute then
  begin
    SynEdit1.Lines.Clear;
    SynEdit1.Lines.LoadFromFile(JvOpenDialog1.FileName);
  end else
  raise LoadDialogException.Create('could not open file.');
end;

procedure TForm1.JvOpenDialog1Error(Sender: TObject; ErrorCode: Cardinal);
begin
  raise LoadDialogException.Create('something goes wrong - load error.');
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  if JvOpenDialog1.Execute then
  begin
    SynEdit1.Lines.SaveToFile(JvOpenDialog1.FileName);
  end else
  raise LoadDialogException.Create('could not save file.');
end;

end.

