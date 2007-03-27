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

// Dialog to show and edit a FTP place properties 

unit interface_FTP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ImgList,
  ComCtrls, TntComCtrls, bmCommon, TntDialogs;

type
  Tform_FTP = class(TTntForm)
    p_Bottom: TTntPanel;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    p_Left: TTntPanel;
    lb_Menu: TTntListBox;
    pc_FTP: TTntPageControl;
    tab_Connection: TTntTabSheet;
    tab_Authentication: TTntTabSheet;
    tab_Advanced: TTntTabSheet;
    tab_SSLOptions: TTntTabSheet;
    tab_SSLFiles: TTntTabSheet;
    il_FTPMenu: TImageList;
    l_Host: TTntLabel;
    e_Host: TTntEdit;
    l_Port: TTntLabel;
    e_Port: TTntEdit;
    l_ID: TTntLabel;
    e_ID: TTntEdit;
    e_Password: TTntEdit;
    l_Password: TTntLabel;
    l_Working: TTntLabel;
    e_Working: TTntEdit;
    l_TLS: TTntLabel;
    cb_TLS: TTntComboBox;
    l_AuthenticationType: TTntLabel;
    cb_AuthenticationType: TTntComboBox;
    l_DPP: TTntLabel;
    cb_DPP: TTntComboBox;
    gb_Proxy: TTntGroupBox;
    l_ProxyHost: TTntLabel;
    cb_Proxy: TTntComboBox;
    e_ProxyHost: TTntEdit;
    l_ProxyPort: TTntLabel;
    e_ProxyPort: TTntEdit;
    l_ProxyID: TTntLabel;
    e_ProxyID: TTntEdit;
    l_ProxyPassword: TTntLabel;
    e_ProxyPassword: TTntEdit;
    l_DataPort: TTntLabel;
    e_DataPort: TTntEdit;
    l_MinPort: TTntLabel;
    e_MinPort: TTntEdit;
    l_MaxPort: TTntLabel;
    e_MaxPort: TTntEdit;
    l_ExternalIP: TTntLabel;
    e_ExternalIP: TTntEdit;
    cb_Passive: TTntCheckBox;
    l_TransferTimeOut: TTntLabel;
    e_TransferTO: TTntEdit;
    l_ConnectionTimeout: TTntLabel;
    e_ConnectionTO: TTntEdit;
    cb_MLIS: TTntCheckBox;
    cb_UseIPv6: TTntCheckBox;
    cb_CCC: TTntCheckBox;
    cb_FastTrack: TTntCheckBox;
    l_SSLMethod: TTntLabel;
    cb_SSLMethod: TTntComboBox;
    l_SSLMode: TTntLabel;
    cb_SSLMode: TTntComboBox;
    cb_Nagle: TTntCheckBox;
    l_VerifyDepth: TTntLabel;
    e_VerifyDepth: TTntEdit;
    gb_VerifyMode: TTntGroupBox;
    cb_Peer: TTntCheckBox;
    cb_Fail: TTntCheckBox;
    cb_ClientOnce: TTntCheckBox;
    l_CertificateFile: TTntLabel;
    e_CertificateFile: TTntEdit;
    b_BrowseCertificate: TTntButton;
    l_Cipher: TTntLabel;
    e_Cipher: TTntEdit;
    b_BrowseCipher: TTntButton;
    l_Key: TTntLabel;
    e_Key: TTntEdit;
    b_BrowseKey: TTntButton;
    l_Root: TTntLabel;
    e_Root: TTntEdit;
    b_BrowseRoot: TTntButton;
    l_VerifyDirs: TTntLabel;
    e_VerifyDirs: TTntEdit;
    b_Test: TTntButton;
    b_Default: TTntButton;
    dlg_Open: TTntOpenDialog;
    procedure b_TestClick(Sender: TObject);
    procedure b_BrowseRootClick(Sender: TObject);
    procedure b_BrowseKeyClick(Sender: TObject);
    procedure b_BrowseCipherClick(Sender: TObject);
    procedure b_BrowseCertificateClick(Sender: TObject);
    procedure b_DefaultClick(Sender: TObject);
    procedure cb_TLSChange(Sender: TObject);
    procedure cb_ProxyChange(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure lb_MenuDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure lb_MenuClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    FirstTime: boolean;
    FShowIcons: boolean;
    FSGlobal: TFormatSettings;
    procedure GetInterfaceText();
    procedure CheckUI();
    procedure ApplySettings();
    procedure ApplySettingsBack();
    procedure CheckUIProxy();
    procedure CheckUISSL();
    function ValidateForm(): boolean;
    procedure SetIndex(const Index: integer);
    procedure TestFTP();
  public
    { Public declarations }
    FTP: TFTPAddress;
  end;

implementation

uses bmTranslator, bmConstants, interface_Common, CobCommonW, CobEncrypt, CobDialogsW,
  bmCustomize, interface_Tester;

{$R *.dfm}

procedure Tform_FTP.ApplySettings();
var
  APassword: WideString;
begin
  with FTP do
  begin
    e_Host.Text:= Host;
    e_Port.Text:= CobIntToStrW(Port);
    e_ID.Text:= ID;
    if CobDecryptStringW(Password,WS_LLAVE,APassword) then
      e_Password.Text:= APassword else
      e_Password.Text:= WS_NIL;
    e_Working.Text:= WorkingDir;
    cb_TLS.ItemIndex:= TLS;
    cb_AuthenticationType.ItemIndex:= AuthType;
    cb_DPP.ItemIndex:= DataProtection;
    cb_Proxy.ItemIndex:= ProxyType;
    e_ProxyHost.Text:= ProxyHost;
    e_ProxyPort.Text:= CobIntToStrW(ProxyPort);
    e_ProxyID.Text:= ProxyID;
    if CobDecryptStringW(ProxyPassword,WS_LLAVE,APassword) then
      e_ProxyPassword.Text:= APassword else
      e_ProxyPassword.Text:= WS_NIL;
    e_DataPort.Text:= CobIntToStrW(DataPort);
    e_MinPort.Text:= CobIntToStrW(MinPort);
    e_MaxPort.Text:= CobIntToStrW(MaxPort);
    e_ExternalIP.Text:= ExternalIP;
    cb_Passive.Checked:= Passive;
    e_TransferTO.Text:= CobIntToStrW(TransferTimeOut);
    e_ConnectionTO.Text:= CobIntToStrW(ConnectionTimeout);
    cb_MLIS.Checked:= UseMLIS;
    cb_UseIPv6.Checked:= UseIPv6;
    cb_CCC.Checked:= UseCCC;
    cb_FastTrack.Checked:= NATFastTrack;
    cb_SSLMethod.ItemIndex:= SSLMethod;
    cb_SSLMode.ItemIndex:= SSLMode;
    cb_Nagle.Checked:= UseNagle;
    e_VerifyDepth.Text:= CobIntToStrW(VerifyDepth);
    cb_Peer.Checked:= Peer;
    cb_Fail.Checked:= FailIfNoPeer;
    cb_ClientOnce.Checked:= ClientOnce;
    e_CertificateFile.Text:= CertificateFile;
    e_Cipher.Text:= CipherList;
    e_Key.Text:= KeyFile;
    e_Root.Text:= RootCertificate;
    e_VerifyDirs.Text:= VerifyDirectories;
  end;
end;

procedure Tform_FTP.CheckUIProxy();
begin
  l_ProxyHost.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  e_ProxyHost.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  l_ProxyPort.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  e_ProxyPort.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  l_ProxyID.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  e_ProxyID.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  l_ProxyPassword.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
  e_ProxyPassword.Enabled := (cb_Proxy.ItemIndex <> INT_NOPROXY);
end;

procedure Tform_FTP.CheckUISSL();
begin
  l_AuthenticationType.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_AuthenticationType.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_DPP.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_DPP.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  if (cb_TLS.ItemIndex = INT_NOTLSSUPPORT) then
    cb_DPP.ItemIndex:= INT_DATAPROTECTIONCLEAR;
  cb_CCC.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  if (cb_TLS.ItemIndex = INT_NOTLSSUPPORT) then
    cb_CCC.Checked:= false;
  l_SSLMethod.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_SSLMethod.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_SSLMode.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_SSLMode.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_Nagle.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_VerifyDepth.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  e_VerifyDepth.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  gb_VerifyMode.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_Peer.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_Fail.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  cb_ClientOnce.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_CertificateFile.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  e_CertificateFile.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  b_BrowseCertificate.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_Cipher.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  e_Cipher.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  b_BrowseCipher.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_Key.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  e_Key.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  b_BrowseKey.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_Root.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  e_Root.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  b_BrowseRoot.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  l_VerifyDirs.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
  e_VerifyDirs.Enabled:= (cb_TLS.ItemIndex <> INT_NOTLSSUPPORT);
end;

procedure Tform_FTP.ApplySettingsBack();
begin
  with FTP do
  begin
    Host:= e_Host.Text;
    Port:= CobStrToIntW(e_Port.Text, INT_DEFFTPPORT);
    ID:= e_ID.Text;
    CobEncryptStringW(e_Password.Text,WS_LLAVE,Password);
    if (e_Working.Text = WS_NIL) then
      WorkingDir:= WS_FTPROORDIR else
      WorkingDir:= CobSetLeadingForwardSlashW(e_Working.Text);
    TLS:= cb_TLS.ItemIndex;
    AuthType:= cb_AuthenticationType.ItemIndex;
    DataProtection:= cb_DPP.ItemIndex;
    ProxyType:= cb_Proxy.ItemIndex;
    ProxyHost:= e_ProxyHost.Text;
    ProxyPort:= CobStrToIntW(e_ProxyPort.Text,INT_STDPROXY);
    ProxyID:= e_ProxyID.Text;
    CobEncryptStringW(e_ProxyPassword.Text,WS_LLAVE,ProxyPassword);
    DataPort:= CobStrToIntW(e_DataPort.Text, INT_STDDATAPORT);
    MinPort:= CobStrToIntW(e_MinPort.Text, INT_STDMINPORT);
    MaxPort:= CobStrToIntW(e_MaxPort.Text, INT_STDMAXPORT);
    ExternalIP:= e_ExternalIP.Text;
    Passive:= cb_Passive.Checked;
    TransferTimeOut:= CobStrToIntW(e_TransferTO.Text, INT_STDTRANSFERTIMEOUT);
    ConnectionTimeout:= CobStrToIntW(e_ConnectionTO.Text, INT_STDCONNECTIONTIMEOUT);
    UseMLIS:= cb_MLIS.Checked;
    UseIPv6:= cb_UseIPv6.Checked;
    UseCCC:= cb_CCC.Checked;
    NATFastTrack:= cb_FastTrack.Checked;
    SSLMethod:= cb_SSLMethod.ItemIndex;
    SSLMode:= cb_SSLMode.ItemIndex;
    UseNagle:= cb_Nagle.Checked;
    VerifyDepth:= CobStrToIntW(e_VerifyDepth.Text, INT_VERIFYDEPTH);
    Peer:= cb_Peer.Checked;
    FailIfNoPeer:= cb_Fail.Checked;
    ClientOnce:= cb_ClientOnce.Checked;
    CertificateFile:= e_CertificateFile.Text;
    CipherList:= e_Cipher.Text;
    KeyFile:= e_Key.Text;
    RootCertificate:= e_Root.Text;
    VerifyDirectories:= e_VerifyDirs.Text;
  end;
end;

procedure Tform_FTP.b_BrowseCertificateClick(Sender: TObject);
begin
  dlg_Open.Title:= Translator.GetMessage('65');
  if (dlg_Open.Execute) then
    e_CertificateFile.Text:= dlg_Open.FileName;
end;

procedure Tform_FTP.b_BrowseCipherClick(Sender: TObject);
begin
  dlg_Open.Title:= Translator.GetMessage('66');
  if (dlg_Open.Execute) then
    e_Cipher.Text:= dlg_Open.FileName;
end;

procedure Tform_FTP.b_BrowseKeyClick(Sender: TObject);
begin
  dlg_Open.Title:= Translator.GetMessage('67');
  if (dlg_Open.Execute) then
    e_Key.Text:= dlg_Open.FileName;
end;

procedure Tform_FTP.b_BrowseRootClick(Sender: TObject);
begin
  dlg_Open.Title:= Translator.GetMessage('68');
  if (dlg_Open.Execute) then
    e_Root.Text:= dlg_Open.FileName;
end;

procedure Tform_FTP.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_FTP.b_DefaultClick(Sender: TObject);
begin
  if (CobMessageBoxW(self.Handle,Translator.GetMessage('53'),
                    WS_PROGRAMNAMESHORT,MB_YESNO) = mrYes) then
  begin
    FTP.SetDefaultValues();
    ApplySettings();
    CheckUI();
  end;
end;

procedure Tform_FTP.b_OKClick(Sender: TObject);
begin
  if (ValidateForm()) then
  begin
    ApplySettingsBack();
    Tag:= INT_MODALRESULTOK;
    Close();
  end;
end;

procedure Tform_FTP.b_TestClick(Sender: TObject);
begin
  if (ValidateForm()) then
  begin
    ApplySettingsBack();
    TestFTP();
  end;
end;

procedure Tform_FTP.cb_ProxyChange(Sender: TObject);
begin
  CheckUIProxy();
end;

procedure Tform_FTP.cb_TLSChange(Sender: TObject);
begin
  CheckUISSL();

  // Don't put this in CheckUISSL because this will change the port then
  // when showing the form
  if (cb_TLS.ItemIndex = INT_IMPLICIT) then
    e_Port.Text:= CobIntToStrW(INT_IMPLICITPORT) else
    e_Port.Text:= CobIntToStrW(INT_DEFFTPPORT);
end;

procedure Tform_FTP.CheckUI();
begin
  CheckUIProxy();
  CheckUISSL();

  CheckHorizontalBar(lb_Menu);
end;

procedure Tform_FTP.GetInterfaceText();
begin
  Caption:= Translator.GetInterfaceText('251');
  b_OK.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
  lb_Menu.Clear();
  lb_Menu.Items.Add(Translator.GetInterfaceText('252'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('253'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('254'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('255'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('256'));
  l_Host.Caption:= Translator.GetInterfaceText('257');
  e_Host.Hint:= Translator.GetInterfaceText('258');
  l_Port.Caption:= Translator.GetInterfaceText('259');
  e_Port.Hint:= Translator.GetInterfaceText('260');
  l_ID.Caption:= Translator.GetInterfaceText('261');
  e_ID.Hint:= Translator.GetInterfaceText('262');
  l_Password.Caption:= Translator.GetInterfaceText('263');
  e_Password.Hint:= Translator.GetInterfaceText('264');
  l_Working.Caption:= Translator.GetInterfaceText('265');
  e_Working.Hint:= Translator.GetInterfaceText('266');
  b_Test.Caption:= Translator.GetInterfaceText('267');
  b_Test.Hint:= Translator.GetInterfaceText('268');
  l_TLS.Caption:= Translator.GetInterfaceText('269');
  cb_TLS.Clear();
  cb_TLS.Items.Add(Translator.GetInterfaceText('270'));
  cb_TLS.Items.Add(Translator.GetInterfaceText('271'));
  cb_TLS.Items.Add(Translator.GetInterfaceText('272'));
  cb_TLS.Items.Add(Translator.GetInterfaceText('273'));
  l_AuthenticationType.Caption:= Translator.GetInterfaceText('274');
  cb_AuthenticationType.Clear();
  cb_AuthenticationType.Items.Add(Translator.GetInterfaceText('275'));
  cb_AuthenticationType.Items.Add(Translator.GetInterfaceText('276'));
  cb_AuthenticationType.Items.Add(Translator.GetInterfaceText('277'));
  cb_AuthenticationType.Items.Add(Translator.GetInterfaceText('278'));
  cb_AuthenticationType.Items.Add(Translator.GetInterfaceText('279'));
  l_DPP.Caption:= Translator.GetInterfaceText('280');
  cb_DPP.Clear();
  cb_DPP.Items.Add(Translator.GetInterfaceText('281'));
  cb_DPP.Items.Add(Translator.GetInterfaceText('282'));
  gb_Proxy.Caption:= Translator.GetInterfaceText('283');
  cb_Proxy.Clear();
  cb_Proxy.Items.Add(Translator.GetInterfaceText('285'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('286'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('287'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('288'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('289'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('290'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('291'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('292'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('293'));
  cb_Proxy.Items.Add(Translator.GetInterfaceText('294'));
  l_ProxyHost.Caption:= Translator.GetInterfaceText('284');
  cb_TLS.Hint:= Translator.GetInterfaceText('295');
  cb_AuthenticationType.Hint:= Translator.GetInterfaceText('296');
  cb_DPP.Hint:= Translator.GetInterfaceText('297');
  cb_Proxy.Hint:= Translator.GetInterfaceText('298');
  e_ProxyHost.Hint:= Translator.GetInterfaceText('299');
  l_ProxyPort.Hint:= Translator.GetInterfaceText('300');
  e_ProxyPort.Hint:= Translator.GetInterfaceText('301');
  l_ProxyID.Caption:= Translator.GetInterfaceText('302');
  e_ProxyID.Hint:= Translator.GetInterfaceText('303');
  l_ProxyPassword.Caption:= Translator.GetInterfaceText('304');
  e_ProxyPassword.Hint:= Translator.GetInterfaceText('305');
  l_DataPort.Caption:= Translator.GetInterfaceText('306');
  e_DataPort.Hint:= Translator.GetInterfaceText('307');
  l_MinPort.Caption:= Translator.GetInterfaceText('308');
  e_MinPort.Hint:= Translator.GetInterfaceText('309');
  l_MaxPort.Caption:= Translator.GetInterfaceText('310');
  e_MaxPort.Hint:= Translator.GetInterfaceText('311');
  l_ExternalIP.Caption:= Translator.GetInterfaceText('312');
  e_ExternalIP.Hint:= Translator.GetInterfaceText('313');
  cb_Passive.Caption:= Translator.GetInterfaceText('314');
  cb_Passive.Hint:= Translator.GetInterfaceText('315');
  l_TransferTimeOut.Caption:= Translator.GetInterfaceText('316');
  e_TransferTO.Hint:= Translator.GetInterfaceText('317');
  l_ConnectionTimeout.Caption:= Translator.GetInterfaceText('318');
  e_ConnectionTO.Hint:= Translator.GetInterfaceText('319');
  cb_MLIS.Caption:= Translator.GetInterfaceText('320');
  cb_MLIS.Hint:= Translator.GetInterfaceText('321');
  cb_UseIPv6.Caption:= Translator.GetInterfaceText('322');
  cb_UseIPv6.Hint:= Translator.GetInterfaceText('323');
  cb_CCC.Caption:= Translator.GetInterfaceText('324');
  cb_CCC.Hint:= Translator.GetInterfaceText('325');
  cb_FastTrack.Caption:= Translator.GetInterfaceText('326');
  cb_FastTrack.Hint:= Translator.GetInterfaceText('327');
  l_SSLMethod.Caption:= Translator.GetInterfaceText('328');
  cb_SSLMethod.Clear();
  cb_SSLMethod.Items.Add(Translator.GetInterfaceText('329'));
  cb_SSLMethod.Items.Add(Translator.GetInterfaceText('330'));
  cb_SSLMethod.Items.Add(Translator.GetInterfaceText('331'));
  cb_SSLMethod.Items.Add(Translator.GetInterfaceText('332'));
  cb_SSLMethod.Hint:= Translator.GetInterfaceText('333');
  l_SSLMode.Caption:= Translator.GetInterfaceText('334');
  cb_SSLMode.Clear();
  cb_SSLMode.Items.Add(Translator.GetInterfaceText('335'));
  cb_SSLMode.Items.Add(Translator.GetInterfaceText('336'));
  cb_SSLMode.Items.Add(Translator.GetInterfaceText('337'));
  cb_SSLMode.Items.Add(Translator.GetInterfaceText('338'));
  cb_SSLMode.Hint:= Translator.GetInterfaceText('339');
  cb_Nagle.Caption:= Translator.GetInterfaceText('340');
  cb_Nagle.Hint:= Translator.GetInterfaceText('341');
  l_VerifyDepth.Caption:= Translator.GetInterfaceText('342');
  e_VerifyDepth.Hint:= Translator.GetInterfaceText('343');
  gb_VerifyMode.Caption:= Translator.GetInterfaceText('344');
  cb_Peer.Caption:= Translator.GetInterfaceText('345');
  cb_Fail.Caption:= Translator.GetInterfaceText('346');
  cb_ClientOnce.Caption:= Translator.GetInterfaceText('347');
  l_CertificateFile.Caption:= Translator.GetInterfaceText('348');
  e_CertificateFile.Hint:= Translator.GetInterfaceText('349');
  b_BrowseCertificate.Hint:= Translator.GetInterfaceText('182');
  l_Cipher.Caption:= Translator.GetInterfaceText('350');
  e_Cipher.Hint:= Translator.GetInterfaceText('351');
  b_BrowseCipher.Hint:= Translator.GetInterfaceText('182');
   l_Key.Caption:= Translator.GetInterfaceText('352');
  e_Key.Hint:= Translator.GetInterfaceText('353');
  b_BrowseKey.Hint:= Translator.GetInterfaceText('182');
  l_Root.Caption:= Translator.GetInterfaceText('354');
  e_Root.Hint:= Translator.GetInterfaceText('355');
  b_BrowseRoot.Hint:= Translator.GetInterfaceText('182');
  l_VerifyDirs.Caption:= Translator.GetInterfaceText('356');
  e_VerifyDirs.Hint:= Translator.GetInterfaceText('357');
  b_Default.Caption:= Translator.GetInterfaceText('358');
  b_Default.Hint:= Translator.GetInterfaceText('359');
  dlg_Open.Filter:= WS_ALLFILESFILTER;
  dlg_Open.FilterIndex:= 1;
end;

procedure Tform_FTP.lb_MenuClick(Sender: TObject);
begin
  if (lb_Menu.ItemIndex <> -1) then
    pc_FTP.ActivePageIndex:= lb_Menu.ItemIndex;
end;

procedure Tform_FTP.lb_MenuDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  Offset: Integer;
begin
  with (Control as TTntListBox).Canvas do
  begin
    Brush.Style := bsSolid;
    if odSelected in State then
      Brush.Color := RGB(INT_R, INT_G, INT_B)
    else
      Brush.Color := clWindow;

    FillRect(Rect);
    Offset := INT_ICONOFFSET;

    if (FShowIcons) then
    begin
      BitMap := TBitmap.Create();
      try
        Bitmap.Width := INT_LBHEIGHT;
        Bitmap.Height := INT_LBHEIGHT;

        il_FTPMenu.GetBitmap(Index, Bitmap);
      
        if Bitmap <> nil then
        begin
          BrushCopy(Bounds(Rect.Left + INT_ICONOFFSET,
                            Rect.Top + INT_ICONOFFSET,
                            Bitmap.Width,
                            Bitmap.Height),
                    Bitmap,
                    Bounds(0, 0, Bitmap.Width, Bitmap.Height), clWhite);
          Offset := Bitmap.Width + 2 * INT_ICONOFFSET;
        end;
      finally
        Bitmap.Free;
      end;
    end;
    Font.Color := clWindowText;
    Rect.Left:= OffSet;
    DrawTextW(Handle,PWideChar((Control as TTntListBox).Items[Index]),
            Length((Control as TTntListBox).Items[Index]),
            Rect, DT_VCENTER or DT_LEFT or DT_SINGLELINE );
  end;
end;

procedure Tform_FTP.SetIndex(const Index: integer);
begin
  if (Index >= 0) and (Index < lb_Menu.Items.Count) then
  begin
    lb_Menu.ItemIndex:= Index;
    lb_Menu.Selected[Index]:= true;
    pc_FTP.ActivePageIndex:= Index;
  end;
end;

procedure Tform_FTP.TestFTP();
var
  Tester: Tform_Tester;
begin
  Tester:= Tform_Tester.Create(nil);
  try
    Tester.Operation:= INT_OPTESTFTP;
    Tester.AFTPAddress:= FTP.EncodeAddress();
    Tester.ShowModal();
  finally
    Tester.Release();
  end;
end;

procedure Tform_FTP.TntFormCreate(Sender: TObject);
begin
  FirstTime:= true;
  Tag:= INT_MODALRESULTCANCEL;
  ShowHint:= UISettings.ShowHints;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  FShowIcons:= UISettings.ShowIcons;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FSGlobal);
  if UISettings.DeferenceLinks then
    dlg_Open.Options:= dlg_Open.Options - [ofNoDereferenceLinks] else
    dlg_Open.Options:= dlg_Open.Options + [ofNoDereferenceLinks];
  GetInterfaceText();
  pc_FTP.ActivePage:= tab_Connection;
  lb_Menu.ItemIndex:= 0;
  lb_Menu.Selected[0]:= true;
  FTP:= TFTPAddress.Create();
end;

procedure Tform_FTP.TntFormDestroy(Sender: TObject);
begin
  FreeAndNil(FTP);
end;

procedure Tform_FTP.TntFormShow(Sender: TObject);
begin
  if (FirstTime) then
  begin
    ApplySettings();
    CheckUI();
    FirstTime:= false;
  end;
end;

function Tform_FTP.ValidateForm(): boolean;
begin
  Result:= false;

  if (e_Host.Text = WS_NIL) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('54'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(0);
    e_Host.SelectAll();
    e_Host.SetFocus();
    Exit;
  end;

  if (e_Host.Text = WS_NIL) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('54'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(0);
    e_Host.SelectAll();
    e_Host.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_Port.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('55'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(0);
    e_Port.SelectAll();
    e_Port.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_ProxyPort.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('56'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(1);
    e_ProxyPort.SelectAll();
    e_ProxyPort.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_DataPort.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('57'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(2);
    e_DataPort.SelectAll();
    e_DataPort.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_MinPort.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('58'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(2);
    e_MinPort.SelectAll();
    e_MinPort.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_MaxPort.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('59'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(2);
    e_MaxPort.SelectAll();
    e_MaxPort.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_TransferTO.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('60'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(2);
    e_TransferTO.SelectAll();
    e_TransferTO.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_ConnectionTO.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('61'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(2);
    e_ConnectionTO.SelectAll();
    e_ConnectionTO.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_VerifyDepth.Text)) then
  begin
    CobShowMessageW(self.Handle,Translator.GetMessage('62'),
                    WS_PROGRAMNAMESHORT);
    SetIndex(3);
    e_VerifyDepth.SelectAll();
    e_VerifyDepth.SetFocus();
    Exit;
  end;

  Result:= true;
end;

end.
