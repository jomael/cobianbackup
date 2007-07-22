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

// Implements some very used dialogs in it's unicode form

unit CobDialogsW;

{$INCLUDE CobianCompilers.inc}

interface

uses ShlObj, Controls, Windows, Forms, Dialogs;

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

function CobMessageDlg(const Msg: widestring; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultButton:TMsgDlgBtn): Integer;

implementation

uses ActiveX, SysUtils, TntSysUtils, CobCommonW, Graphics, TntStdCtrls, classes, consts, math, extctrls;

{$IFNDEF COMPILER_9_UP}
const
  BIF_NEWDIALOGSTYLE     = $0040;
  BIF_USENEWUI           = BIF_NEWDIALOGSTYLE or BIF_EDITBOX;
  BIF_BROWSEINCLUDEURLS  = $0080;
  BIF_UAHINT             = $0100;
  BIF_NONEWFOLDERBUTTON  = $0200;
  BIF_NOTRANSLATETARGETS = $0400;
  BIF_SHAREABLE          = $8000;
{$ENDIF}

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

{ Cob UniCode-compliant Message dialog }

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;


type
  TCobMessageForm = class(TForm)
  private
    Message: TTntLabel;
    procedure HelpButtonClick(Sender: TObject);
  protected
    procedure CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WriteToClipBoard(Text: WideString);
    function GetFormText: WideString;
  public
    constructor CreateNew(AOwner: TComponent); reintroduce;
  end;

constructor TCobMessageForm.CreateNew(AOwner: TComponent);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited CreateNew(AOwner);
  NonClientMetrics.cbSize := sizeof(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

procedure TCobMessageForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

procedure TCobMessageForm.CustomKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = Word('C')) then
  begin
    Beep;
    WriteToClipBoard(GetFormText);
  end;
end;

procedure TCobMessageForm.WriteToClipBoard(Text: WideString);
var
  Data: THandle;
  DataPtr: Pointer;
begin
  if OpenClipBoard(0) then
  begin
    try
      Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, (Length(Text) + 1) * 2); // wide char is double byte
      try
        DataPtr := GlobalLock(Data);
        try
          Move(PWideChar(Text)^, DataPtr^, Length(Text) + 1);
          EmptyClipBoard;
          SetClipboardData(CF_TEXT, Data);
        finally
          GlobalUnlock(Data);
        end;
      except
        GlobalFree(Data);
        raise;
      end;
    finally
      CloseClipBoard;
    end;
  end
  else
    raise Exception.CreateRes(@SCannotOpenClipboard);
end;

function TCobMessageForm.GetFormText: WideString;
var
  DividerLine, ButtonCaptions: Widestring;
  I: integer;
begin
  DividerLine := StringOfChar('-', 27) + sLineBreak;
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TTntButton then
      ButtonCaptions := ButtonCaptions + TTntButton(Components[I]).Caption +
        StringOfChar(' ', 3);
  ButtonCaptions := StringReplace(ButtonCaptions,'&','', [rfReplaceAll]);
  Result := Format('%s%s%s%s%s%s%s%s%s%s', [DividerLine, Caption, sLineBreak,
    DividerLine, Message.Caption, sLineBreak, DividerLine, ButtonCaptions,
    sLineBreak, DividerLine]);
end;

var
  Captions: array[TMsgDlgType] of Pointer = (@SMsgDlgWarning, @SMsgDlgError,
    @SMsgDlgInformation, @SMsgDlgConfirm, nil);
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);
  ButtonNames: array[TMsgDlgBtn] of widestring = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
  ButtonCaptions: array[TMsgDlgBtn] of Pointer = (
    @SMsgDlgYes, @SMsgDlgNo, @SMsgDlgOK, @SMsgDlgCancel, @SMsgDlgAbort,
    @SMsgDlgRetry, @SMsgDlgIgnore, @SMsgDlgAll, @SMsgDlgNoToAll, @SMsgDlgYesToAll,
    @SMsgDlgHelp);
  ModalResults: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0);
var
  ButtonWidths : array[TMsgDlgBtn] of integer;  // initialized to zero

function CobCreateMessageDialog(const Msg: widestring; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; DefaultButton:TMsgDlgBtn): TForm;
const
  mcHorzMargin = 8;
  mcVertMargin = 8;
  mcHorzSpacing = 10;
  mcVertSpacing = 10;
  mcButtonWidth = 50;
  mcButtonHeight = 14;
  mcButtonSpacing = 4;
var
  DialogUnits: TPoint;
  HorzMargin, VertMargin, HorzSpacing, VertSpacing, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth,
  IconTextWidth, IconTextHeight, X, ALeft: Integer;
  B, CancelButton: TMsgDlgBtn;
  IconID: PChar;
  TextRect: TRect;
begin
  Result := TCobMessageForm.CreateNew(Application);
  with Result do
  begin
    BiDiMode := Application.BiDiMode;
    BorderStyle := bsDialog;
    Canvas.Font := Font;
    KeyPreview := True;
    OnKeyDown := TCobMessageForm(Result).CustomKeyDown;
    DialogUnits := GetAveCharSize(Canvas);
    HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
    VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
    HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
    VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(mcButtonWidth, DialogUnits.X, 4);
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
    begin
      if B in Buttons then
      begin
        if ButtonWidths[B] = 0 then
        begin
          TextRect := Rect(0,0,0,0);
          Windows.DrawText( canvas.handle,
            PChar(LoadResString(ButtonCaptions[B])), -1,
            TextRect, DT_CALCRECT or DT_LEFT or DT_SINGLELINE or
            DrawTextBiDiModeFlagsReadingOnly);
          with TextRect do ButtonWidths[B] := Right - Left + 8;
        end;
        if ButtonWidths[B] > ButtonWidth then
          ButtonWidth := ButtonWidths[B];
      end;
    end;
    ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
    ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
    SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
    DrawTextW(Canvas.Handle, PWideChar(Msg), Length(Msg)+1, TextRect,
      DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK or
      DrawTextBiDiModeFlagsReadingOnly);
    IconID := IconIDs[DlgType];
    IconTextWidth := TextRect.Right;
    IconTextHeight := TextRect.Bottom;
    if IconID <> nil then
    begin
      Inc(IconTextWidth, 32 + HorzSpacing);
      if IconTextHeight < 32 then IconTextHeight := 32;
    end;
    ButtonCount := 0;
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      if B in Buttons then Inc(ButtonCount);
    ButtonGroupWidth := 0;
    if ButtonCount <> 0 then
      ButtonGroupWidth := ButtonWidth * ButtonCount +
        ButtonSpacing * (ButtonCount - 1);
    ClientWidth := Max(IconTextWidth, ButtonGroupWidth) + HorzMargin * 2;
    ClientHeight := IconTextHeight + ButtonHeight + VertSpacing +
      VertMargin * 2;
    Left := (Screen.Width div 2) - (Width div 2);
    Top := (Screen.Height div 2) - (Height div 2);
    if DlgType <> mtCustom then
      Caption := LoadResString(Captions[DlgType]) else
      Caption := Application.Title;
    if IconID <> nil then
      with TImage.Create(Result) do
      begin
        Name := 'Image';
        Parent := Result;
        Picture.Icon.Handle := LoadIcon(0, IconID);
        SetBounds(HorzMargin, VertMargin, 32, 32);
      end;
    TCobMessageForm(Result).Message := TTntLabel.Create(Result);
    with TCobMessageForm(Result).Message do
    begin
      Name := 'Message';
      Parent := Result;
      WordWrap := True;
      Caption := Msg;
      BoundsRect := TextRect;
      BiDiMode := Result.BiDiMode;
      ALeft := IconTextWidth - TextRect.Right + HorzMargin;
      if UseRightToLeftAlignment then
        ALeft := Result.ClientWidth - ALeft - Width;
      SetBounds(ALeft, VertMargin,
        TextRect.Right, TextRect.Bottom);
    end;
//    if mbOk in Buttons then DefaultButton := mbOk else
//      if mbYes in Buttons then DefaultButton := mbYes else
//        DefaultButton := mbRetry;
    if mbCancel in Buttons then CancelButton := mbCancel else
      if mbNo in Buttons then CancelButton := mbNo else
        CancelButton := mbOk;
    X := (ClientWidth - ButtonGroupWidth) div 2;
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      if B in Buttons then
        with TTntButton.Create(Result) do
        begin
          Name := ButtonNames[B];
          Parent := Result;
          Caption := LoadResString(ButtonCaptions[B]);
          ModalResult := ModalResults[B];
          if B = DefaultButton then Default := True;
          if B = CancelButton then Cancel := True;
          SetBounds(X, IconTextHeight + VertMargin + VertSpacing,
            ButtonWidth, ButtonHeight);
          Inc(X, ButtonWidth + ButtonSpacing);
          if B = mbHelp then
            OnClick := TCobMessageForm(Result).HelpButtonClick;
        end;
  end;
end;


function CobMessageDlgPosHelp(const Msg: widestring; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer; const HelpFileName: string; DefaultButton:TMsgDlgBtn): Integer;
begin
  with CobCreateMessageDialog(Msg, DlgType, Buttons, DefaultButton) do
    try
      HelpContext := HelpCtx;
      HelpFile := HelpFileName;
      if X >= 0 then Left := X;
      if Y >= 0 then Top := Y;
      if (Y < 0) and (X < 0) then Position := poScreenCenter;
      Result := ShowModal;
    finally
      Free;
    end;
end;


function CobMessageDlg(const Msg: widestring; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint; DefaultButton:TMsgDlgBtn): Integer;
begin
  Result := CobMessageDlgPosHelp(Msg, DlgType, Buttons, HelpCtx, -1, -1, '', DefaultButton);
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
