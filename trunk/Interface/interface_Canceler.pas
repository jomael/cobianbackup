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

// Dialog to cancel some lengthy operations


unit interface_Canceler;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, bmCommon, bmConstants, TntSysUtils;

type
  Tform_Canceler = class(TTntForm)
    l_Caption: TTntLabel;
    b_Cancel: TTntButton;
    procedure FormDestroy(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    FAbort: boolean;
    FTool: TCobTools;
    FSLocal: TFormatSettings;
    procedure GetInterfaceText();
    function DoAbort(): boolean;
    procedure DeleteFTP(const Backup: TBackup);
    procedure Log(const Msg: WideString; const Error, Verbose: boolean);
    procedure DeleteDir(const ASource: WideString);
    procedure OnFileDelete(const FileName: WideString);
    procedure ResetDirectory(const ASource: Widestring; const Subdirs: boolean);
  public
    { Public declarations }
    Operation: integer;
    Source: WideString;
    Backup: TBackup;
    FSubdirs: boolean;
  protected
    procedure Action(var Msg:TMessage); message INT_AFTERSHOW;
  end;

implementation

uses bmTranslator, bmFTP, interface_Main, interface_Common, CobCommonW;

{$R *.dfm}

procedure Tform_Canceler.Action(var Msg: TMessage);
begin
  case Operation of
    INT_OPUIFTPDEL: DeleteFTP(Backup);
    INT_OPUILOCALDEL: DeleteDir(Source);
    INT_OPUIATTRIBUTES: ResetDirectory(FTool.NormalizeFileName(Source), FSubdirs);
  end;

  Close();
end;

procedure Tform_Canceler.b_CancelClick(Sender: TObject);
begin
  FAbort:= true;
  PostMessageW(form_CB8_Main.Handle, INT_CANCELDELETE, 0, 0);
  Application.ProcessMessages();
end;

procedure Tform_Canceler.DeleteDir(const ASource: Widestring);
var
  DirtySource: WideString;
begin
  FTool.OnAbort:= DoAbort;
  FTool.OnFileProcess:= OnFileDelete;
  DirtySource:= FTool.NormalizeFileName(ASource);
  if (FTool.DeleteDirectoryW(DirtySource)) then
    Log(WideFormat(Translator.GetMessage('429'),[ASource],FSLocal), false, false) else
    Log(WideFormat(Translator.GetMessage('430'),[ASource],FSLocal), true, false);
end;

procedure Tform_Canceler.DeleteFTP(const Backup: TBackup);
var
  Rec: TFTPrec;
  FTP: TFTP;
  Destination: WideString;
  Kind: integer;
begin
  Destination:= FTool.DecodeSD(Backup.FDestination, Kind);
  if (not Kind = INT_SDFTP) then
  begin
    Log(WideFormat(Translator.GetMessage('431'),[Destination],FSLocal), true, false);
    Exit;
  end;

  Rec.Temp:= Settings.GetTemp();
  Rec.AppPath:= Globals.AppPath;
  Rec.IncludeSubDirs:= true;
  Rec.IncludeMask:= WS_NIL;
  Rec.ExcludeMask:= WS_NIL;
  Rec.Slow:= false;
  Rec.SpeedLimit:= Settings.GetFTPSpeedLimit();
  Rec.Speed:= Settings.GetFTPSpeed();
  Rec.ASCII:= WS_NIL;
  Rec.UseAttributes:= true;
  Rec.Separated:= true;
  Rec.DTFormat:= Settings.GetDateTimeFormat();
  Rec.DoNotSeparate:= false;
  Rec.DoNotUseSpaces:= false;
  Rec.BackupType:= INT_BUFULL;
  Rec.EncBufferSize:= Settings.GetCopyBuffer();
  Rec.EncCopyTimeStamps:= Settings.GetCopyTimeStamps();
  Rec.EncCopyAttributes:= Settings.GetCopyAttributes();
  Rec.EncCopyNTFS:= Settings.GetCopyNTFSPermissions();
  Rec.ClearAttributes:= false;
  Rec.DeleteEmptyFolders:= Settings.GetDeleteEmptyFolders();
  Rec.AlwaysCreateDirs:= Settings.GetAlwaysCreateFolder();
  Rec.EncPublicKey:= WS_NIL;
  Rec.EncMethod:= INT_ENCNOENC;
  Rec.EncPassPhrase:= WS_NIL;
  Rec.Propagate:= Settings.GetPropagateMasks();

  FTP:= TFTP.Create(Rec);
  try
    FTP.OnAbort:= DoAbort;
    FTP.OnLog:= Log;
    FTP.OnProgress:= nil;
    FTP.OnFileBegin:= nil;
    FTP.OnFileEnd:= nil;
    FTP.OnFileBeginEnc:= nil;
    FTP.OnFileEndEnc:= nil;
    FTP.OnFileProgressEnc:= nil;
    FTP.OnNTFSPermissionsCopyEnc:= nil;
    FTP.OnDelete:= nil;
    FTP.DeleteItems(Destination, Backup.FFiles);
  finally
    FreeAndNil(FTP);
  end;
end;

function Tform_Canceler.DoAbort: boolean;
begin
  Result:= FAbort;
end;

procedure Tform_Canceler.FormCreate(Sender: TObject);
begin
  ShowHint:= UISettings.ShowHints;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  FFirstTime:= true;
  FAbort:= false;
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FSLocal);
  FTool:= TCobTools.Create();
end;

procedure Tform_Canceler.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTool);
end;

procedure Tform_Canceler.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    GetInterfaceText();
    FFirstTime:= false;
    PostMessageW(self.Handle, INT_AFTERSHOW,0,0);
  end;
end;

procedure Tform_Canceler.GetInterfaceText();
begin
  Caption:= Translator.GetInterfaceText('597');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
end;

procedure Tform_Canceler.Log(const Msg: WideString; const Error,
  Verbose: boolean);
begin                         
  l_Caption.Caption:= Msg;
  Application.ProcessMessages();
  if (not Verbose) then
    form_CB8_Main.Log(Msg, Error, false);
end;

procedure Tform_Canceler.OnFileDelete(const FileName: WideString);
begin
  l_Caption.Caption:= WideFormat(Translator.GetMessage('473'),
                        [WideExtractFileName(FileName)],FSLocal);
  Application.ProcessMessages();
end;

procedure Tform_Canceler.ResetDirectory(const ASource: Widestring; const Subdirs: boolean);
var
  SR: TSearchRecW;
  DirtySource: WideString;
  // process
  procedure Process();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if ((faDirectory and SR.Attr) > 0) then
      begin
        if (Subdirs) then
          ResetDirectory(DirtySource + SR.Name, Subdirs);
      end else
      begin
        FTool.SetArchiveAttributeW(DirtySource + SR.Name, true);
        Log(WideFormat(Translator.GetMessage('474'),[SR.Name], FSLocal), false, true);
      end;
    end;
  end;
begin
  DirtySource:= CobSetBackSlashW(ASource);
  if (WideFindFirst(DirtySource + WS_ALLFILES, faAnyFile, SR) = 0) then
  begin
    Process();
    while WideFindNext(SR) = 0 do
    begin
      Process();
      if (FAbort) then
        Break;
      Application.ProcessMessages();
    end;
    WideFindClose(SR);
  end;
end;


end.
