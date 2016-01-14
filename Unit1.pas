unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, SHellApi, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Edit_Filename: TEdit;
    SpeedButton1: TSpeedButton;
    OD: TOpenDialog;
    Button4: TButton;
    StatusBar1: TStatusBar;
    Button6: TButton;
    GroupBox1: TGroupBox;
    cb_compression: TCheckBox;
    cb_decompression: TCheckBox;
    cb_keep: TCheckBox;
    cb_overwrite: TCheckBox;
    cb_test: TCheckBox;
    cb_output: TCheckBox;
    cb_suppress: TCheckBox;
    cb_memory: TCheckBox;
    cb_block: TComboBox;
    cb_blocksize: TCheckBox;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    rb_none: TRadioButton;
    rb_simple: TRadioButton;
    rb_more: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure cb_blocksizeClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    function Launchbzip(Args: string; var Output: TStringList): Boolean;
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  end;

var
  Form1: TForm1;
  Output: TStringList;
  BZIP_FILE, Args: string;
  Cancel: Boolean;
  
implementation

{$R *.dfm}
{$R bzip.res}

Function AddSlash(Filename: String): String;
begin
  if length(Filename) > 1 then
  if FileName[length(FileName)] <> '\' then
    FileName := FileName + '\';
  result := FileName;
end;

Function GetFileSize(FileName: String): LongInt;
var
  Search: TSearchRec;
begin
  If FindFirst(ExpandFileName(FileName), faAnyFile, Search) = 0 then
  Result := Search.Size else result := 0
end;

function GetTempDir: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  Result := StrPas(Buffer);
end;

function ExtractRes(ResType, ResName, ResNewName: string): Boolean;
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, Resname, PChar(ResType));
  try
    Res.SavetoFile(ResNewName);
    Result := True;
  finally
    Res.Free;
  end;
end;

function ExecAndGetConsoleOutput (const CommandLine : string; Args: string;
  var Output : TStringList) : boolean;
var
  Sa : TSecurityAttributes;
  StartInfo : TStartupInfo;
  ProcInfo : TProcessInformation;
  StdOutFile, AppProc, AppThread : LongWord;
  RootDir, WorkDir, StdOutFn : string;
begin
  Cancel := False;
  Result := FileExists(ExtractFilePath (CommandLine) +
    ExtractFileName (CommandLine));
  if Result then
  begin
    StdOutFile := INVALID_HANDLE_VALUE;
    AppProc := INVALID_HANDLE_VALUE;
    AppThread := INVALID_HANDLE_VALUE;

    try
      RootDir := ExtractFilePath (ParamStr(0));
      WorkDir := ExtractFilePath (CommandLine);

      if not (FileSearch (ExtractFileName (CommandLine), WorkDir) <> '') then
        WorkDir := RootDir;

      FillChar (Sa, SizeOf(Sa), #0);
      Sa.nLength := SizeOf (Sa);
      Sa.lpSecurityDescriptor := nil;
      Sa.bInheritHandle := TRUE;

      StdOutFn := RootDir + '_tmpoutp.tmp';
      StdOutFile := CreateFile (PChar(StdOutFn), GENERIC_READ or GENERIC_WRITE,
        FILE_SHARE_READ or FILE_SHARE_WRITE, @Sa, CREATE_ALWAYS,
        FILE_ATTRIBUTE_TEMPORARY or FILE_FLAG_WRITE_THROUGH, 0);

      if StdOutFile <> INVALID_HANDLE_VALUE then
      begin
        FillChar (StartInfo, SizeOf(StartInfo), #0);
        with StartInfo do
        begin
          cb := SizeOf (StartInfo);
          dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
          wShowWindow := SW_HIDE;
          hStdInput := GetStdHandle (STD_INPUT_HANDLE);
          hStdError := StdOutFile;
          hStdOutput := stdOutFile;
        end;

        if CreateProcess (nil, PChar(CommandLine + Args), nil, nil, TRUE, 0,
          nil, PChar(WorkDir), StartInfo, ProcInfo) then
        begin
          AppProc := ProcInfo.hProcess;
          AppThread := ProcInfo.hThread;

          while (WaitForSingleObject (AppProc, 0) <> WAIT_OBJECT_0)
            and (Cancel = False) do
              begin
               // Output.LoadFromFile (StdOutFn);
                Application.ProcessMessages;
              end;
         // if Cancel then stop

          CloseHandle (StdOutFile);
          StdOutFile := INVALID_HANDLE_VALUE;

          Output.LoadFromFile (StdOutFn);
        end;
      end;
    finally
      if StdOutFile <> INVALID_HANDLE_VALUE then
        CloseHandle (StdOutFile);
      if AppProc <> INVALID_HANDLE_VALUE then
        CloseHandle (AppProc);
      if AppThread <> INVALID_HANDLE_VALUE then
        CloseHandle (AppThread);

      if FileExists (StdOutFn) then
        SysUtils.DeleteFile (StdOutFn);
    end;
  end;
end;

function TForm1.Launchbzip(Args: string; var Output: TStringList): Boolean;
begin
  if not FileExists(BZIP_FILE) then
  ExtractRes('EXEFILE', 'BZIP', BZIP_FILE);
  result := ExecAndGetConsoleOutput(BZIP_FILE, Args, Output);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Args := '';
  Memo1.Clear;
  StatusBar1.Panels[0].Text := 'Operation in progress ...';
  StatusBar1.Panels[1].Text := 'Size: ' + IntToStr(GetFileSize(
    Edit_Filename.Text) div 1024) + ' KB';
  StatusBar1.Panels[2].Text := 'Received: 0 KB';

  if cb_decompression.Checked then Args := Args + ' -d';
  if cb_compression.Checked then Args := Args + ' -z';
  if cb_keep.Checked then Args := Args + ' -k';
  if cb_overwrite.Checked then Args := Args + ' -f';
  if cb_test.Checked then Args := Args + ' -t';
  if cb_output.Checked then Args := Args + ' -c';
  if cb_suppress.Checked then Args := Args + ' -q';
  if rb_simple.Checked then Args := Args + ' -v';
  if rb_more.Checked then Args := Args + ' -v -v';
  if cb_memory.Checked then Args := Args + ' -s';
  if cb_blocksize.Checked then
    Args := Args + ' -' + IntToStr(cb_block.ItemIndex + 1);
  Args := Args + ' "' + Edit_Filename.Text + '"';

  Launchbzip(Args, Output);
  Memo1.Lines := Output;
  StatusBar1.Panels[0].Text := 'Operation finiched';
  StatusBar1.Panels[1].Text := '';
  StatusBar1.Panels[2].Text := '';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BZIP_FILE := AddSlash(GetTempDir) + 'bzip.exe';
  Output := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if FileExists(BZIP_FILE) then
    DeleteFile(BZIP_FILE);
  Output.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Launchbzip(' -h', Output);
  ShowMessage(Output.Text);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Launchbzip(' -L', Output);
  ShowMessage(Output.Text);
end;

procedure TForm1.cb_blocksizeClick(Sender: TObject);
begin
  cb_block.Enabled := cb_blocksize.Checked;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OD.Execute then
    Edit_Filename.Text := OD.FileName;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  ShellExecute(0, 'Open', Pchar(ExtractFilePath(Edit_Filename.Text)), nil, nil,
    Sw_Show);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Cancel := True;
end;

end.
