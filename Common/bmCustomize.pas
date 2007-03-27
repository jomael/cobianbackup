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


// Change all these constants to create a customized application

unit bmCustomize;

interface

const

  BOOL_CUSTOMIZED = false;   // Is this a customization?
  BOOL_SHOWBASEDON = true;
  BOOL_WANTSSERIAL = false; // introduce a serial number with the setup

  //App name
  WS_PROGRAMNAMELONG: WideString = 'Cobian Backup Black Moon';
  WS_PROGRAMNAMESHORT: WideString = 'Cobian Backup 8';
  WS_PROGRAMNAMEGENERIC: WideString = 'Cobian Backup';
  WS_CODENAME: WideString = 'Black Moon';
  WS_PROGRAMNAMESHORTNOISPACES: WideString = 'Cobian_Backup_8';

  //Author
  WS_AUTHORLONG: WideString = 'Luis Cobian';
  WS_AUTHORSHORT: WideString = 'Cobian';
  WS_COPYRIGHT: WideString = 'Copyright ©2000-2006 %s';
  WS_AUTHORWEB: WideString = 'http://www.cobian.se';
  WS_AUTHORMAIL: WideString = 'cobian@educ.umu.se';
  WS_PROGRAMWEB: WideString = 'http://www.educ.umu.se/~cobian/cobianbackup.htm';
  WS_SUPPORTFORUM: WideString = 'http://sherwood.lh.umu.se/CobianBackup';
  WS_PROGRAMNAMECODE: WideString = 'CobBackup8';

  //Exe names
  WS_APPEXENAME: WideString = 'Cobian.exe';
  WS_ENGINEEXENAME: WideString = 'cbEngine.dll';
  WS_GUIEXENAME: WideString = 'cbInterface.exe';
  WS_COBNTW: WideString = 'cbNTW.dll';
  WS_COBNTSEC: WideString = 'cbNTSecW.dll';
  WS_COBDECRYPTORDLL: WideString = 'cbDecryptorW.dll';
  WS_COBDECRYPTORSTANDALONEEXENAME: WideString = 'cbDecryptorW.exe';
  WS_SERVICEEXENAME: WideString = 'cbService.exe';
  WS_DECOMPRESSOREXENAME: WideString = 'cbDecompressor.exe';
  WS_TRANSLATIONEXENAME: WideString = 'cbTranslator.exe';
  WS_UNINSTALLEXENAME: WideString = 'cbUninstall.exe';
  WS_SETUPEXENAME: WideString = 'cbSetup.exe';
  WS_FAKELIB: WideString = 'FMSImg32.dll';
  WS_FAKELIBG: WideString = 'MSImg32.dll';

  WS_UNINSTALLSTR: WideString = 'CobBackup8';
  WS_UICLASSNAME: WideString = 'Tform_CB8_Main';

  WS_UPDATEHOST = 'sherwood.lh.umu.se';
  INT_UPDATEPORT = 2002;
  S_LIVEUPDATESTRING: AnsiString = 'Cobian Backup Black Moon';

  //Other
  WS_DEFAULTLANGUAGE: WideString = 'english';
  WS_SERVICENAME: WideString = 'CobBMService';

  //Extras
  WS_HISTORY: WideString = 'history.txt';
  WS_SSLLIB1: WideString = 'libeay32.dll';
  WS_SSLLIB2: WideString = 'ssleay32.dll';
  WS_LICENSE: WideString = 'license.txt';
  WS_README: WideString = 'Readme.txt';
  WS_SQXLIB: WideString = 'Sqx.dll';
  WS_TREADME: WideString = 'TReadme.txt';
  WS_VERSIONS: WideString = 'Versions.txt';

implementation

end.
