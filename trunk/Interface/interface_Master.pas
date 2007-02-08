{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                Cobian Backup Black Moon                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 200-2006 by Luis Cobian               ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

// This thread reads the queue of commands and dends them to the engine
// using a memory mapped file

unit interface_Master;

interface

uses
  Classes, Windows, SysUtils, TntClasses;

type
  TIPCMaster = class(TThread)
  public
    constructor Create(const AppPath: WideString;const Sec: PSecurityAttributes);
    destructor Destroy();override;
  private
    FAppPath: WideString;
    FS: TFormatSettings;
    FIPCMutex: THandle;
    FIPCHandle: THandle;
    FSenderPointer: PWideChar;
    FCommands: TTntStringList;
    FWriter: TTntStringList;
    { Private declarations }
  protected
    procedure Execute(); override;
  end;

implementation

uses CobCommonW, bmConstants, bmCustomize, interface_Common;
{ TIPCMaster }

constructor TIPCMaster.Create(const AppPath: WideString;const Sec: PSecurityAttributes);
var
  FName, MName: WideString;
begin
  inherited Create(true);
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FAppPath:= AppPath;
  if (CobIs2000orBetterW) then
    begin
      FName:= WideFormat(WS_MMFSLAVE,[WS_PROGRAMNAMELONG],FS);
      MName:= WideFormat(WS_MMFMUTEXSLAVE,[WS_PROGRAMNAMELONG],FS);
    end else
    begin
      FName:= WideFormat(WS_MMFSLAVEOLD,[WS_PROGRAMNAMELONG],FS);
      MName:= WideFormat(WS_MMFMUTEXSLAVEOLD,[WS_PROGRAMNAMELONG],FS);
    end;

  FIPCMutex:= CreateMutexW(sec, False, PWideChar(MName));

  FIPCHandle := CreateFileMappingW(INVALID_HANDLE_VALUE,
                                    sec,
                                    PAGE_READWRITE,
                                    INT_NIL,
                                    INT_MAXFILESIZE,
                                    PWideChar(FName));

  FSenderPointer := MapViewOfFile(FIPCHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);

  FCommands:= TTntStringList.Create();
  FWriter:= TTntStringList.Create();
end;

destructor TIPCMaster.Destroy();
begin
  FreeAndNil(FWriter);
  FreeAndNil(FCommands);

  if (FSenderPointer <> nil) then
  begin
    UnmapViewOfFile(FSenderPointer);
    FSenderPointer:= nil;
  end;

  if (FIPCHandle <> 0) then
    begin
      CloseHandle(FIPCHandle);
      FIPCHandle:= 0;
    end;

  if (FIPCMutex <> 0) then
    begin
      CloseHandle(FIPCMutex);
      FIPCMutex:= 0;
    end;

  inherited Destroy();
end;

procedure TIPCMaster.Execute();
begin
  while not Terminated do
    begin
      IPCMasterCS.Enter();
      try
        if (CommandList.Count <> 0) then
          begin
            FCommands.Assign(CommandList);
            CommandList.Clear();
          end;
      finally
        IPCMasterCS.Leave();
      end;

      if (FCommands.Count <> 0) then
        begin
          if WaitForSingleObject(FIPCMutex, INFINITE) = WAIT_OBJECT_0 then
            try
              if FSenderPointer <> nil then
                begin
                  FWriter.CommaText:= FSenderPointer;
                  FWriter.AddStrings(FCommands);
                  if (Length(FWriter.CommaText) < (INT_MAXFILESIZE div SizeOf(WideChar)) - 4) then
                    lstrcpyW(FSenderPointer,PWideChar(FWriter.CommaText));
                  FWriter.Clear();
                end;
            finally
              ReleaseMutex(FIPCMutex);
            end;
          FCommands.Clear();
        end;
      Sleep(INT_MMFSLAVESLEEP);
    end;
end;

end.
