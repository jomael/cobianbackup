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

// Main unit for the distribution builder

unit builder_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, TntClasses,
  bmCommon, ZipForge;

type
  TCopyItem = class(TObject)
  private
    Path: WideString;
    Destination: WideString;
    Process: boolean;
  end;

  Tform_Main = class(TTntForm)
    re_Log: TTntRichEdit;
    b_Proceed: TTntButton;
    Zip: TZipForge;
    procedure ZipProcessFileFailure(Sender: TObject; FileName: string;
      Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
      ErrorMessage: string; var Action: TZFAction);
    procedure ZipFileProgress(Sender: TObject; FileName: string;
      Progress: Double; Operation: TZFProcessOperation;
      ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure b_ProceedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAppPath: WideString;
    FDistroPath: WideString;
    FParentPath: WideString;
    FExtraPath: WideString;
    FSetupDir: WideString;
    FHelpPath: WideString;
    FLanguagePath: WideString;
    FS: TFormatSettings;
    FWorking: boolean;
    FErrors: integer;
    FFiles: TList;
    FTools: TCobTools;
    FCopied: integer;
    FZipped: integer;
    FZipFile: WideString;
    FRcFile: WideString;
    FResFile: WideString;
    procedure ClearList();
    procedure Log(const Msg: WideString; const Error: boolean);
    procedure Go();
    procedure CreateVersionFile();
    function CheckOutputDirectory(): boolean;
    procedure DeleteDirectory(const Dir: WideString);
    procedure PopulateList();
    procedure CopyFiles();
    procedure CopyAFile(const Item: TCopyItem);
    procedure CopyADirectory(const Source, Destination: WideString; const Process: boolean);
    procedure CopyAFileDirectly(const Item: TCopyItem);
    procedure CopyAFileProcessed(const Item: TCopyItem);
    procedure ZipFiles();
    procedure AddZipFiles(const Dir: WideString);
    procedure CreateResource();
    procedure DeleteFiles();
    procedure DisplayResults();
    function IsExec(const FileName: WideString): boolean;
    procedure CopyManifest();
  public
    { Public declarations }
  end;

var
  form_Main: Tform_Main;

implementation

{$R *.dfm}

uses CobCommonW, bmConstants, builder_Constants, bmCustomize, CobDialogsW,
    TntSysUtils, ShellApi;

procedure Tform_Main.AddZipFiles(const Dir: WideString);
var
  SR: TSearchRecW;
  ADir: WideString;
  //****************************************************************************
  procedure AnalyzeResult();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if (SR.Attr and faDirectory) > 0 then 
        AddZipFiles(ADir + SR.Name) else
        Zip.FileMasks.Add(AnsiString(ADir + SR.Name)); 
    end; 
  end;
  //****************************************************************************
begin
  ADir:= CobSetBackSlashW(Dir);
  if WideFindFirst(ADir + WS_ALLFILES, faAnyFile, SR) = 0 then
  begin
    AnalyzeResult();
    while WideFindNext(SR) = 0 do
      AnalyzeResult();
    WideFindClose(SR);
  end;  
end;

procedure Tform_Main.b_ProceedClick(Sender: TObject);
begin
  if (CobMessageBoxW(self.Handle, WS_PROCEEDNOW, WS_PROGRAMNAMESHORT, MB_YESNO) = mrYes) then
  begin
    try
      FErrors:= INT_NIL;
      FCopied:= INT_NIL;
      FWorking:= true;
      FZipped:= INT_NIL;
      b_Proceed.Enabled:= false;
      re_Log.Clear();
      Log(BS_BEGINBUILDING, false);
      Go();
    finally
      FWorking:= false;
      b_Proceed.Enabled:= true;
    end;
  end;
end;

function Tform_Main.CheckOutputDirectory(): boolean;
begin
  if (WideDirectoryExists(FDistroPath)) then
    //Remove it first to eliminate old files
    DeleteDirectory(FDIstroPath);

  Result:= WideCreateDir(FDistroPath);

  if (Result) then
    Log(WideFormat(BS_OUTPUTDIRCREATED,[FDistroPath],FS), false) else
    Log(WideFormat(BS_OUTPUTDIRCREATEDFAILED, [FDistroPath], FS), true);
end;

procedure Tform_Main.ClearList();
var
  i: integer;
  Item: TCopyItem;
begin
  for i:= FFiles.Count - 1 downto 0 do
  begin
    Item:= TCopyItem(FFiles[i]);
    FreeAndNil(Item);
  end;

  FFiles.Clear();
end;

procedure Tform_Main.CopyADirectory(const Source, Destination: WideString; 
  const Process: boolean);
var
  SR: TSearchRecW; 
  ASource, ADestination: WideString;  
  // ***************************************************************************
  procedure DoWork();
  var
    Ext: WideString; 
    Item: TCopyItem;   
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if (faDirectory and SR.Attr)> 0 then
      begin
        // Recursive
        if (SR.Name[1] <> WC_DOT) and (SR.Name[1] <> WC_UNDER) then    // do not copy history files or cache
          CopyADirectory(CobSetBackSlashW(Source) + SR.Name, ADestination + SR.Name, Process);
      end else
      begin
        Ext:= WideLowerCase(WideExtractFileExt(SR.Name));
        Item:= TCopyItem.Create();
        try
          Item.Path:= CobSetBackSlashW(Source) + SR.Name;
          Item.Destination:= ADestination + SR.Name;
          Item.Process:= ((Ext = WS_TEXTEXT) or (Ext = WS_HTMEXT) or (Ext = WS_HTMLEXT)) and Process;
          CopyAFile(Item);  
        finally
          FreeAndNil(Item);
        end;
        
      end;
    end;
  end;
  //****************************************************************************                                                  
begin
  {This is only used for Help files and tutorials, etc, so
  go through the whole directory and copy directly the NON-HTML files.
  The HTML files must be processed}
  if (not WideDirectoryExists(Destination)) then
  begin
    Log(WideFormat(BS_CREATINGDIR,[Destination],FS), false);
    if WideCreateDir(Destination) then
       Log(WideFormat(BS_DIRCREATED,[Destination],FS), false);  
  end;

  ASource:= CobSetBackSlashW(Source) + WS_ALLFILES;
  ADestination:=CobSetBackSlashW(Destination);
  
  if (WideFindFirst(ASource, faAnyFile, SR) = 0) then
  begin
    DoWork();
    while WideFindNext(SR) = 0 do
      DoWork();
    WideFindClose(SR);
  end;
end;

procedure Tform_Main.CopyAFile(const Item: TCopyItem);
begin
  if (not Item.Process) then
    CopyAFileDirectly(Item) else
    CopyAFileProcessed(Item);
end;

procedure Tform_Main.CopyAFileDirectly(const Item: TCopyItem);
begin
  Log(WideFormat(BS_COPYING,[Item.Path, Item.Destination],FS), false);
  if (CopyFileW(PWideChar(Item.Path),PWideChar(Item.Destination), false)) then
  begin
    inc(FCopied);
    Log(WideFormat(BS_COPIED,[Item.Path, Item.Destination],FS),false);
  end else
  begin
    //there is no need to increment the erros. This is done in the Log
    Log(WideFormat(BS_COPyFAILED,[Item.Path, Item.Destination, 
                              CobSysErrorMessageW(Windows.GetLastError)],FS),true);
  end;
end;

procedure Tform_Main.CopyAFileProcessed(const Item: TCopyItem);
var
  Sl: TTntStringList;
  i: integer;
begin
  Sl:= TTntStringList.Create();
  try
    try
      Log(WideFormat(BS_PROCESSING,[Item.Path, Item.Destination],FS),false);
      Sl.LoadFromFile(Item.Path);
      for i:=0 to Sl.Count - 1 do
      begin
        Sl[i]:= CobStringReplaceW(Sl[i], WS_PROGRAMNAMEPARAM,WS_PROGRAMNAMESHORT, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_AUTHORPARAM, WS_AUTHORLONG, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_WEBPARAM, WS_AUTHORWEB, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_MAILPARAM, WS_AUTHORMAIL, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_AUTHORPARAMSHORT, WS_AUTHORSHORT, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_PARAMMANIFESTNAME, WS_PROGRAMNAMECODE, true, false);
      end;
      Sl.SaveToFile(Item.Destination);
      Log(WideFormat(BS_PROCESSED,[Item.Path, Item.Destination],FS),false);
      inc(FCopied);
    except
      on E: Exception do
        Log(WideFormat(BS_COPYFAILED,[Item.Path, Item.Destination, WideString(E.Message)],FS), true);
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Main.CopyFiles();
var
  i: integer;
  Item: TCopyItem;
begin
  Log(BS_PREPARINGTOCOPY, false);
  for i:= 0 to  FFiles.Count - 1 do
  begin
    Item:= TCopyItem(FFiles[i]);
    if (WideFileExists(Item.Path)) then
      CopyAFile(Item) else
      begin
        Log(WideFormat(BS_PROCESSINGDIR,[Item.Path, Item.Destination],FS),false);
        CopyADirectory(Item.Path, Item.Destination, Item.Process);
      end;
  end;
end;

procedure Tform_Main.CopyManifest();
var
  Sl: TStringList;
  i: integer;
begin
  // This is a special case of the CopyFileProcessed procedure,
  // because the manifest MUST be ANSI
  Sl:= TStringList.Create();
  try
    try
      Log(WideFormat(BS_PROCESSING,[FExtraPath + WS_GUIEXENAME + WS_MANIFESTEXT,
                                    FDistroPath + WS_GUIEXENAME + WS_MANIFESTEXT],FS),false);
      Sl.LoadFromFile(AnsiString(FExtraPath + WS_GUIEXENAME + WS_MANIFESTEXT));
      for i:=0 to Sl.Count - 1 do
      begin
        Sl[i]:= CobStringReplaceW(Sl[i], WS_PROGRAMNAMEPARAM,WS_PROGRAMNAMESHORT, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_AUTHORPARAM, WS_AUTHORLONG, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_WEBPARAM, WS_AUTHORWEB, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_MAILPARAM, WS_AUTHORMAIL, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_AUTHORPARAMSHORT, WS_AUTHORSHORT, true, false);
        Sl[i]:= CobStringReplaceW(Sl[i], WS_PARAMMANIFESTNAME, WS_PROGRAMNAMECODE, true, false);
      end;
      Sl.SaveToFile(FDistroPath + WS_GUIEXENAME + WS_MANIFESTEXT);
      Log(WideFormat(BS_PROCESSED,[FExtraPath + WS_GUIEXENAME + WS_MANIFESTEXT,
                        FDistroPath + WS_GUIEXENAME + WS_MANIFESTEXT],FS),false);
      inc(FCopied);
    except
      on E: Exception do
        Log(WideFormat(BS_COPYFAILED,[FExtraPath + WS_GUIEXENAME + WS_MANIFESTEXT,
          FDistroPath + WS_GUIEXENAME + WS_MANIFESTEXT, WideString(E.Message)],FS), true);
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Main.CreateResource();
var
  Sl: TStringList; // Ansi
  Error: cardinal;
  FDestination: WideString;
begin
  // Create the RC file first to compile
  Sl:= TStringList.Create();
  try
    Sl.Add(S_RESOURCESTRING);
    FRcFile:= FAppPath + WS_RESOURCENAMERC;
    FResFile:= FAppPath + WS_RESOURCE;
    
    if (WideFileExists(FRcFile)) then
    begin
      if DeleteFileW(PWideChar(FRcFile)) then
        Log(WideFormat(BS_DELETEDRC,[FRcFile],FS),false) else
        Log(WideFormat(BS_DELETEDRCFAILED,[FRcFile],FS),true);
    end;

    Sl.SaveToFile(AnsiString(FRcFile));

    Log(WideFormat(BS_RCCREATED,[FRcFile],FS), false);
  finally
    FreeAndNil(Sl);
  end;

  SetCurrentDirectoryW(PWideChar(FAppPath));

  Error:= FTools.ExecuteAndWaitW(BS_RESOURCECOMPILER, WS_RESOURCENAMERC, true);
  if (Error = 0) then
    Log(WideFormat(BS_RESOURCECREATED,[FresFile], FS), false) else
    Log(WideFormat(BS_RESOURCECREATEDFILED,[FresFile, CobSysErrorMessageW(Error)], FS), true);

  FDestination:= FSetupDir + WS_RESOURCE;
  
  if (WideFileExists(FResFile)) then
  begin
    if (CopyFileW(PWideChar(FResFile),PWideChar(FDestination),false)) then
      Log(WideFormat(BS_RESOURCECOPIED,[FResFile, FDestination],FS), false) else
      Log(WideFormat(BS_RESOURCECOPIEDFAILED,[FResFile, FDestination],FS), true);
  end else
      Log(WideFormat(BS_RESOURCENOTFOUND,[FResFile],FS), true);
end;

procedure Tform_Main.CreateVersionFile();
var
  Sl: TTntStringList;
  i: integer;
  Item: TCopyItem;
begin
  /// In v7 and earlier, this file was created manually.
  ///  Now the Builder will automatically
  ///  query all EXE and DLL files to obtain their
  ///  version info and it will create the text file

  Sl:= TTntStringList.Create();
  try
    for i:= 0 to FFiles.Count - 1 do
    begin
      Item:= TCopyItem(FFiles[i]);
      if (IsExec(Item.Path)) then
        Sl.Add(WideFormat(WS_INIFORMAT,[WideExtractFileName(Item.Path),
                                       CobGetVersionW(Item.Path)],FS));
    end;

    Sl.SaveToFile(FExtraPath + WS_VERSIONS);
    Log(WideFormat(BS_VERSIUONFILECREATED,[FExtraPath + WS_VERSIONS],FS), false);
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Main.DeleteDirectory(const Dir: WideString);
var
  Struct: TshFileOpStructW;
  i: integer;
  FolderName: WideString;
  Error: integer;
begin

  Log(WideFormat(BS_DELETINGDIR, [Dir], FS), false);

  FolderName := Dir;

  if FolderName[Length(FolderName)] = WC_BACKSLASH then
    Delete(FolderName, Length(FolderName), 1);

  i := GetFileAttributesW(PWideChar(FolderName));

  if (i = -1) or (i and FILE_ATTRIBUTE_DIRECTORY = 0) then
    Exit;

  FolderName:=  FolderName + WideChar(#0)+WideChar(#0);
  FillChar(Struct, SizeOf(Struct), 0);
  Struct.Wnd := Handle;
  Struct.wFunc := FO_DELETE;
  Struct.pFrom := PWideChar(FolderName);
  Struct.fFlags := FOF_NOCONFIRMATION or FOF_NOERRORUI or FOF_SILENT;

  if ShFileOperationW(Struct) <> 0 then
  begin
    Error := Windows.GetLastError();
    Log(WideFormat(BS_ERRORDELETINGFOLDER, [Dir, CobSysErrorMessageW(Error)]),
        true);
  end else
    Log(WideFormat(BS_OUTPUTDIRDELETED,[Dir],FS), false);
end;

procedure Tform_Main.DeleteFiles();
begin
  if (WideFileExists(FZipFile)) then
    if (DeleteFileW(PWideChar(FZipFile))) then
      Log(WideFormat(BS_DELETED,[FZipFile],FS),false);         // do not log the error. Not critical

  if (WideFileExists(FRcFile)) then
    if (DeleteFileW(PWideChar(FRcFile))) then
      Log(WideFormat(BS_DELETED,[FRcFile],FS),false);         // do not log the error. Not critical

  if (WideFileExists(FResFile)) then
    if (DeleteFileW(PWideChar(FResFile))) then
      Log(WideFormat(BS_DELETED,[FResFile],FS),false);         // do not log the error. Not critical
end;

procedure Tform_Main.DisplayResults();
begin
  Log(BS_ATTENTION, false);
  Log(WideFormat(BS_RESULTS,[FErrors, FCopied, FZipped],FS), FErrors <> 0);
  Log(BS_ATTENTION, false);
  if (FErrors = 0) then
    Log(BS_WELLDONE, false) else
    Log(BS_THEREAREERRORS, true);
end;

procedure Tform_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= not FWorking;
end;

procedure Tform_Main.FormCreate(Sender: TObject);
begin
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT,FS);
  Caption:= WideFormat(BS_CAPTION,[WS_PROGRAMNAMESHORT], FS);
  TntApplication.Title:= Caption;
  FAppPath:= CobSetBackSlashW(CobGetAppPathW());
  FDistroPath:= CobSetBackSlashW(FAppPath + WS_DIRDISTRO);
  FTools:= TCobTools.Create();
  FParentPath:= CobSetBackSlashW(FTools.GetParentDirectory(FAppPath));
  FExtraPath:= CobSetBackSlashW(FParentPath + WS_DIREXTRAS);
  FHelpPath:= CobSetBackSlashW(FParentPath + WS_DIRHELP);
  FSetupDir:= CobSetBackSlashW(FParentPath + WS_DIRSETUP);
  FLanguagePath:= CobSetBackSlashW(FParentPath + WS_DIRLANG);
  FWorking:= false;
  FFiles:= TList.Create();
end;

procedure Tform_Main.FormDestroy(Sender: TObject);
begin
  ClearList();
  FreeAndNil(FFiles);
  FreeAndNil(FTools);
end;

procedure Tform_Main.Go();
begin
  if CheckOutputDirectory() then
  begin
    PopulateList();
    CreateVersionFile();
    CopyFiles();
    CopyManifest();
    ZipFiles();
    if (WideFileExists(FZipFile)) then
      CreateResource();
    DeleteFiles();
    DisplayResults();
  end;
end;

function Tform_Main.IsExec(const FileName: WideString): boolean;
begin
  Result:= (WideLowerCase(WideExtractFileExt(FileName))  = WS_EXEEXT) 
            or (WideLowerCase(WideExtractFileExt(FileName))  = WS_DLLEXT);
end;

procedure Tform_Main.Log(const Msg: WideString; const Error: boolean);
var
  AMsg: WideString;
begin
  if Error then
  begin
    re_Log.SelAttributes.Color := clRed;
    AMsg:= WS_ERROR + WS_SPACE + Msg;
    inc(FErrors);
  end else
  begin
    re_Log.SelAttributes.Color := clWindowText;
    AMsg:= WS_NOERROR + WS_SPACE + Msg;
  end;

  re_Log.Lines.Add(AMsg);

  re_Log.Perform(EM_LineScroll, 0, re_Log.Lines.Count - 5);

  Application.ProcessMessages();
end;

procedure Tform_Main.PopulateList();
var
  Item: TCopyItem;
begin
  ClearList();
  Item:= TCopyItem.Create();
  Item.Path:= FAppPath + WS_APPEXENAME;
  Item.Destination:= FDistroPath + WS_APPEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); // Application

  Item:= TCopyItem.Create();
  Item.Path:= FAppPath + WS_GUIEXENAME;
  Item.Destination:= FDistroPath + WS_GUIEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); // Interface

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_ENGINEEXENAME;
  Item.Destination:= FDistroPath + WS_ENGINEEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); // Engine Name

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_COBNTW;
  Item.Destination:= FDistroPath + WS_COBNTW;
  Item.Process:= false;
  FFiles.Add(Item); // CobNT

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_COBNTSEC;
  Item.Destination:= FDistroPath + WS_COBNTSEC;
  Item.Process:= false;
  FFiles.Add(Item); // CobNTSec

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_COBDECRYPTORDLL;
  Item.Destination:= FDistroPath + WS_COBDECRYPTORDLL;
  Item.Process:= false;
  FFiles.Add(Item); //Decrypting dll

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_COBDECRYPTORSTANDALONEEXENAME;
  Item.Destination:= FDistroPath + WS_COBDECRYPTORSTANDALONEEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); //Decryptor exe

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_SERVICEEXENAME;
  Item.Destination:= FDistroPath + WS_SERVICEEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); //Service

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_DECOMPRESSOREXENAME;
  Item.Destination:= FDistroPath + WS_DECOMPRESSOREXENAME;
  Item.Process:= false;
  FFiles.Add(Item); //decompresor

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_TRANSLATIONEXENAME;
  Item.Destination:= FDistroPath + WS_TRANSLATIONEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); // Translator

  Item:= TCopyItem.Create();
  Item.Path:= FAppPath +  WS_FAKELIB;
  Item.Destination:= FDistroPath + WS_FAKELIB;
  Item.Process:= false;
  FFiles.Add(Item); // Fake library

  Item:= TCopyItem.Create();
  Item.Path:=FAppPath +  WS_UNINSTALLEXENAME;
  Item.Destination:= FDistroPath + WS_UNINSTALLEXENAME;
  Item.Process:= false;
  FFiles.Add(Item); // Uninstall

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath + WS_HISTORY;
  Item.Destination:= FDistroPath + WS_HISTORY;
  Item.Process:= TRUE;       // Change the parameters of the file
  FFiles.Add(Item); // History file

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_SSLLIB1;
  Item.Destination:= FDistroPath + WS_SSLLIB1;
  Item.Process:= false;
  FFiles.Add(Item); // SLL lib

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_SSLLIB2;
  Item.Destination:= FDistroPath + WS_SSLLIB2;
  Item.Process:= false;
  FFiles.Add(Item); // SLL lib

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_LICENSE;
  Item.Destination:= FDistroPath + WS_LICENSE;
  Item.Process:= TRUE;
  FFiles.Add(Item); // License

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_README;
  Item.Destination:= FDistroPath + WS_README;
  Item.Process:= TRUE;
  FFiles.Add(Item); // Readme

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_SQXLIB;
  Item.Destination:= FDistroPath + WS_SQXLIB;
  Item.Process:= false;
  FFiles.Add(Item); // SQX

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_TREADME;
  Item.Destination:= FDistroPath + WS_TREADME;
  Item.Process:= TRUE;
  FFiles.Add(Item); // Translators readme

  Item:= TCopyItem.Create();
  Item.Path:= FExtraPath +  WS_VERSIONS;
  Item.Destination:= FDistroPath + WS_VERSIONS;
  Item.Process:= TRUE;
  FFiles.Add(Item); // Versions of all exes

  Item:= TCopyItem.Create();
  Item.Path:= FHelpPath;
  Item.Destination:= CobSetBackSlashW(FDistroPath + WS_DIRHELP);
  Item.Process:= TRUE;
  FFiles.Add(Item); // Help and tutorial

  Item:= TCopyItem.Create();
  Item.Path:= FLanguagePath;
  Item.Destination:= CobSetBackSlashW(FDistroPath + WS_DIRLANG);
  Item.Process:= false;
  FFiles.Add(Item); // Languages
end;

procedure Tform_Main.ZipFileProgress(Sender: TObject; FileName: string;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  if (ProgressPhase = ppStart) then
    Log(WideFormat(BS_COMPRESSING,[WideString(FileName)],FS), false) else
    if (ProgressPhase = ppEnd) then
    begin
      Log(WideFormat(BS_COMPRESSED,[WideString(FileName)],FS), false);
      inc(FZipped);
    end;
end;

procedure Tform_Main.ZipFiles();
begin
  Zip.FileMasks.Clear();
  Zip.ExclusionMasks.Clear();
  Zip.NoCompressionMasks.Clear();
  Zip.BaseDir := FAppPath;
  Zip.CompressionMode := 9;
  Zip.ExtractCorruptedFiles := true;
  FZipFile:= FAppPath + WS_DISTROZIPNAME;
  Zip.FileName := AnsiString(FZipFile);
  Zip.InMemory := false;
  Zip.Options.CreateDirs := true;
  Zip.Options.FlushBuffers := true;
  Zip.Options.OEMFileNames := true;
  Zip.Options.OverwriteMode := omAlways;
  Zip.Options.Recurse := true;
  Zip.Options.SearchAttr := 10431;
  Zip.Options.SetAttributes := true;
  Zip.Options.ShareMode := smShareExclusive;
  Zip.Options.StorePath := spRelativePath;
  Zip.Password := S_NIL;
  Zip.SpanningMode := smNone;
  Zip.Zip64Mode := zmDisabled;

  AddZipFiles(FDistroPath);

  try
    Log(WideFormat(BS_ZIPPING,[FZipFile],FS), false);
    Zip.OpenArchive(fmCreate or fmShareExclusive);
    try
      Zip.AddFiles();
      Log(WideFormat(BS_ZIPPED, [FZipFile, FZipped]), false);
    finally
      Zip.CloseArchive();
    end;
  except
    on E: Exception do
      Log(WideFormat(BS_ERRORZIP, [FZipFile, WideString(E.Message)]), true);
  end;
end;

procedure Tform_Main.ZipProcessFileFailure(Sender: TObject; FileName: string;
  Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
  ErrorMessage: string; var Action: TZFAction);
begin
  Log(WideFormat(BS_ERRORCOMPRESSING,[WideString(FileName)],FS),false);
end;

end.
