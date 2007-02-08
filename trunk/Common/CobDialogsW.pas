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

// Implements some very used dialogs in it's unicode form

unit CobDialogsW;

interface

uses ShlObj, Controls, Windows, Forms;

type
  TCobSelectDirExtOpt = (csdNewFolder, csdShowEdit, csdShowShares, csdNewUI, csdShowFiles,
    csdValidateDir);
  TCobSelectDirExtOpts = set of TCobSelectDirExtOpt;

function CobSelectDirectoryW(const Caption, Root: WideString;
  var Directory: WideString; Options: TCobSelectDirExtOpts; Parent: TWinControl = nil): Boolean;
///dialogs
procedure CobShowMessageW(Handle:hWnd;const MessageTxt, Caption: WideString);
function CobMessageBoxW(Handle: hWnd;const MessageTxt, Caption: WideString;
          Buttons: integer): integer;

implementation

uses ActiveX, SysUtils, TntSysUtils, CobCommonW;

const
  WS_INVALIDPATH: WideString = '"%s" is an invalid path';
  WS_ERROR: WideString = 'Error';

type
  TCobSelectDirCallback = class(TObject)
  private
    FDirectory: WideString;
  protected
    function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer;
  public
    constructor Create(const ADirectory: WideString);
  end;

procedure CobShowMessageW(Handle: hWnd;const MessageTxt, Caption: WideString);
begin
  MessageBoxW(Handle, PWideChar(MessageTxt), PWideChar(Caption),MB_OK
              or MB_APPLMODAL or MB_ICONINFORMATION);
end;

function CobMessageBoxW(Handle: hWnd;const MessageTxt, Caption: WideString;
          Buttons: integer): integer;
begin
  Result:= MessageBoxW(Handle, PWideChar(MessageTxt), PWideChar(Caption),
          Buttons);
end;

{ TCobSelectDirCallback }

constructor TCobSelectDirCallback.Create(const ADirectory: WideString);
begin
  inherited Create;
  FDirectory := ADirectory;
end;

function TCobSelectDirCallback.SelectDirCB(Wnd: HWND; uMsg: UINT; lParam,
  lpData: LPARAM): Integer;
var
  Rect: TRect;
  Monitor: TMonitor;
begin
  Result := 0;
  if uMsg = BFFM_INITIALIZED then
  begin
    if (Application.MainForm <> nil) then
      Monitor := Screen.MonitorFromWindow(Application.MainForm.Handle) else
      Monitor := Screen.MonitorFromWindow(Application.Handle);
    GetWindowRect(Wnd, Rect);
    SetWindowPos(Wnd, 0, (Monitor.Width - (Rect.Right - Rect.Left)) div 2,
      (Monitor.Height - (Rect.Bottom - Rect.Top)) div 2, 0, 0, SWP_NOSIZE or SWP_NOZORDER);
    if FDirectory <> '' then
      SendMessage(Wnd, BFFM_SETSELECTIONW, Integer(True), Windows.LPARAM(PWideChar(FDirectory)));
  end else if uMsg = BFFM_VALIDATEFAILEDW then
  begin
    CobShowMessageW(Application.Handle, WideFormat(WS_INVALIDPATH,[PWideChar(lParam)]),WS_ERROR);
    Result := 1;
  end;
end;

function CobSelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  Result := TCobSelectDirCallback(lpData).SelectDirCB(Wnd, uMsg, lParam, lpData);
end;


function CobSelectDirectoryW(const Caption, Root: WideString;
  var Directory: WideString; Options: TCobSelectDirExtOpts; Parent: TWinControl = nil): Boolean;
 var
  WindowList: Pointer;
  BrowseInfo: TBrowseInfoW;
  Buffer: PWideChar;
  OldErrorMode: Cardinal;
  RootItemIDList, ItemIDList: PItemIDList;
  ShellMalloc: IMalloc;
  IDesktopFolder: IShellFolder;
  Eaten, Flags: LongWord;
  CoInitResult: HRESULT;
  SelectDirCallback: TCobSelectDirCallback;
begin
  Result := False;
  if not WideDirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  if (ShGetMalloc(ShellMalloc) = S_OK) and (ShellMalloc <> nil) then
  begin
    Buffer := ShellMalloc.Alloc(MAX_PATH * SizeOf(WideChar));
    try
      RootItemIDList := nil;
      if Root <> '' then
      begin
        SHGetDesktopFolder(IDesktopFolder);
        IDesktopFolder.ParseDisplayName(Application.Handle, nil,
          POleStr(Root), Eaten, RootItemIDList, Flags);
      end;
      with BrowseInfo do
      begin
       if (Parent = nil) or not Parent.HandleAllocated then
          hwndOwner := Application.Handle
        else
          hwndOwner := Parent.Handle;
        pidlRoot := RootItemIDList;
        pszDisplayName := Buffer;
        lpszTitle := PWideChar(Caption);
        ulFlags := BIF_RETURNONLYFSDIRS;
        if csdNewUI in Options then
          ulFlags := ulFlags or BIF_NEWDIALOGSTYLE;
        if not (csdNewFolder in Options) then
          ulFlags := ulFlags or BIF_NONEWFOLDERBUTTON;
        if csdShowEdit in Options then
          ulFlags := ulFlags or BIF_EDITBOX;
        if csdShowShares in Options then
          ulFlags := ulFlags or BIF_SHAREABLE;
        if csdShowFiles in Options then
          ulFlags := ulFlags or BIF_BROWSEINCLUDEFILES;
        if csdValidateDir in Options then
          ulFlags := ulFlags or BIF_VALIDATE;
        lpfn := CobSelectDirCB;
      end;

      SelectDirCallback := TCobSelectDirCallback.Create(Directory);
      try
        BrowseInfo.lParam := Integer(SelectDirCallback);
        if csdNewUI in Options then
        begin
          CoInitResult := CoInitializeEx(nil, COINIT_APARTMENTTHREADED);
          if CoInitResult = RPC_E_CHANGED_MODE then
            BrowseInfo.ulFlags := BrowseInfo.ulFlags and not BIF_NEWDIALOGSTYLE;
        end;
        try
          WindowList := DisableTaskWindows(0);
          OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
          try
            ItemIDList := ShBrowseForFolderW(BrowseInfo);
          finally
            SetErrorMode(OldErrorMode);
            EnableTaskWindows(WindowList);
          end;
        finally
          if csdNewUI in Options then
            CoUninitialize;
        end;  
      finally
        SelectDirCallback.Free;
      end;
      Result :=  ItemIDList <> nil;
      if Result then
      begin
        ShGetPathFromIDListW(ItemIDList, Buffer);
        ShellMalloc.Free(ItemIDList);
        Directory := Buffer;
      end;
    finally
      ShellMalloc.Free(Buffer);
    end;
  end;     
end;

end.
