{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                Cobian Backup Black Moon                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 2000-2006 by Luis Cobian              ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

// Extracts the resource and unzips all the distribution's files


unit setup_Extractor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CobBarW, StdCtrls, TntForms, TntStdCtrls, TntClasses, ZipForge;

const
  INT_POSTSHOW = WM_USER + 987;

type
  Tform_Extractor = class(TTntForm)
    l_Operation: TTntLabel;
    cb_Main: TCobBarW;
    Unzip: TZipForge;
    procedure UnzipOverallProgress(Sender: TObject; Progress: Double;
      Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
      var Cancel: Boolean);
    procedure UnzipFileProgress(Sender: TObject; FileName: string;
      Progress: Double; Operation: TZFProcessOperation;
      ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FTemp: WideString;
    FS: TFormatSettings;
    FFirstTime: boolean;
    FZipFile: WideString;
    function GetDistroTempDir(): WideString;
    procedure Log(const Msg: WideString);
    function ExtractProgramResource(): boolean;
    function ExtractFiles(): boolean;
  public
    { Public declarations }
    DistroDir: WideString;
    ZippedFiles: WideString;
  protected
    procedure PostShow(var Msg: TMessage); message INT_POSTSHOW;
  end;

implementation

uses bmConstants, CobCommonW, setup_Constants, TntSysUtils, CobDialogsW,
  bmCustomize;

{$R *.dfm}
{$R DISTRORES.RES}

const
  RT_RCDATAW = PWideChar(10);

function Tform_Extractor.ExtractFiles(): boolean;
begin
  Result := true;
  try
    Unzip.FileMasks.Clear();
    Unzip.ExclusionMasks.Clear();
    Unzip.NoCompressionMasks.Clear();
    Unzip.BaseDir := DistroDir;
    Unzip.ExtractCorruptedFiles := true;
    Unzip.FileName := AnsiString(FZipFile);
    Unzip.InMemory := false;
    Unzip.Options.CreateDirs := true;
    Unzip.Options.FlushBuffers := true;
    Unzip.Options.OEMFileNames := true;
    Unzip.Options.OverwriteMode := omAlways;
    Unzip.Options.Recurse := true;
    Unzip.Options.SearchAttr := 10431;
    Unzip.Options.SetAttributes := true;
    Unzip.Options.ShareMode := smShareExclusive;
    Unzip.Options.StorePath := spRelativePath;
    Unzip.Password := AnsiString(WS_NIL);
    Unzip.SpanningMode := smNone;
    Unzip.Zip64Mode := zmDisabled;
    Unzip.OpenArchive(fmOpenRead or fmShareDenyNone); //changed from Exclusively
    try
      Unzip.ExtractFiles(AnsiString(WS_ALLFILES));
      ZippedFiles:= CobSetBackSlashW(DistroDir + SS_DISTROTEMP);
    finally
      Unzip.CloseArchive();
    end;
  except
    Result := false;
  end;
end;

function Tform_Extractor.ExtractProgramResource(): boolean;
begin
  Result := true;
  Log(SS_EXTRACTINGRESOURCE);
  try
    with TTntResourceStream.Create(hInstance, SS_RESOURCENAME, RT_RCDATAW) do
    try
      SaveToFile(FZipFile);
    finally
      Free;
    end;
  except
    Result := false;
  end;
end;

procedure Tform_Extractor.FormCreate(Sender: TObject);
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  cb_Main.Position:= 0;
  FFirstTime:= true;
  FTemp:= CobSetBackSlashW(CobGetSpecialDirW(cobTemporary));
  Tag:= INT_MODALRESULTCANCEL;  // some error arised
  DistroDir:= GetDistroTempDir();
  if (DistroDir = WS_NIL) then
  begin
    CobShowMessageW(self.Handle, SS_CANNOTCREATEDIR, WS_PROGRAMNAMESHORT);
    Application.Terminate();
    Exit;
  end;
  DistroDir:= CobSetBackSlashW(DistroDir);
  FZipFile:= DistroDir + SS_DISTROZIP;
end;

procedure Tform_Extractor.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    PostMessageW(self.Handle, INT_POSTSHOW, 0, 0);
    FFirstTime:= false;
  end;
end;

function Tform_Extractor.GetDistroTempDir(): WideString;
var
  Counter: integer;
begin
  Result:= FTemp + SS_DISTROTEMP;
  Counter:= INT_NIL;
  while WideDirectoryExists(Result) do
  begin
    inc(Counter);
    Result:= FTemp + WideFormat(SS_DISTROTEMPEX, [Counter], FS);
  end;

  if (not WideCreateDir(Result)) then
  begin
    // use the current directopry then
    Result:= CobSetBackSlashW(CobGetAppPathW()) + SS_DISTROTEMP;
    if (not WideCreateDir(Result)) then
      Result:= WS_NIL;
  end;
end;

procedure Tform_Extractor.Log(const Msg: WideString);
begin
  l_Operation.Caption:= Msg;
  Application.ProcessMessages();
end;

procedure Tform_Extractor.PostShow(var Msg: TMessage);
begin
  Application.ProcessMessages();
  if not ExtractProgramResource() then
  begin
    CobShowMessageW(self.Handle, SS_CANNOTEXTRACTRESOURSE, WS_PROGRAMNAMESHORT);
    Application.Terminate();
    Exit;
  end;

  if (not ExtractFiles()) then
  begin
    CobShowMessageW(self.Handle, SS_CANNOTEXTRACTFILES, WS_PROGRAMNAMESHORT);
    Application.Terminate();
    Exit;
  end;

  Tag:= INT_MODALRESULTOK;
  Close();
end;

procedure Tform_Extractor.UnzipFileProgress(Sender: TObject; FileName: string;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  if (ProgressPhase = ppStart) then
    Log(WideFormat(SS_EXTRACTING,[WideExtractFileName(WideString(FileName))], FS));
end;

procedure Tform_Extractor.UnzipOverallProgress(Sender: TObject;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  cb_Main.Position:= Trunc(Progress);
  Application.ProcessMessages();
end;

end.
