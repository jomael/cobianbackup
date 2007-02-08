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

//Common constants for the  whole project group

unit bmConstants;

interface

uses Messages;

const
  WS_LLAVE: WideString = '{443678BA-9A0A-49DC-A2EC-55F5F40CFB11}';
  S_V7PASSWORD: AnsiString = '{169257E3-C5BB-4203-9727-49C0D9E7928C}';
  S_V6PASSWORD: AnsiString = '{61680E90-16B7-4C13-8D38-098141306A00}';

  // General
  WS_NIL: WideString = '';
  INT_NIL = 0;
  F_NIL = 0.0;
  INT_WMHELPCLOSED = WM_USER + 7456;
  INT_AFTERSHOW = WM_USER + 7689;
  INT_AFTERSHOWTEST = WM_USER + 7654;
  INT_CANCELDELETE = WM_USER + 6798;
  INT_UPDATEREADTO = 10000;
  INT_UPDATECONNEACTTO = 10000;
  INT_UINORESULT = 2147483647;     
  INT_UIRESPONSESLEEP = 800;
  INT_UIRESULTDONE = 1;
  INT_FIVEMULTIPLE = 5;
  INT_SLOW = 300;
  INT_SERVICESLEEP = 1000;
  INT_SERVICEOP = 3000;
  INT_MS = 1000;
  INT_SECINHOUR = 3600;
  INT_SECINMIN = 60;
  INT_MARGIN = 5;
  INT_LBMARGIN = 50;
  INT_CBWIDTH = 25;
  INT_BACKUPCOUNT = 14;
  DOUBLE_NIL: Double = 0.0;
  INT_PASSWORDCACHE = 3;
  INT_WAITLOG = 3000;
  INT_EVCOUNT = 3;
  INT_TRUE = 1;
  INT_FIRSTDAY = 1;
  INT_TASKNOTFOUND = -1;
  INT_LONGINTMAX = 2147483647;
  INT_AFTERCREATESERVICE = 5674;
  INT_SQXCONTINUE = 1;
  INT_SQXREPLACE = 2;
  INT_SQXCANCEL = 0;
  INT_FIFTYMULTIPLE = 50;
  INT_LARGESTINT = 2147483647;
  INT_R =  215;
  INT_G =  215;
  INT_B=  255;
  INT_RHINT = $FF;
  INT_GHINT = $FF;
  INT_BHINT = $E1;
  INT_HINTHIDE = 5000;
  INT_SHOWWINDOWHINT = 5000;
  INT_LBHEIGHT = 24;
  INT_ICONOFFSET = 4;
  INT_MODALRESULTOK =  8080;
  INT_MODALRESULTEXCEPTION = 9090;
  INT_SEED = $34344353;
  INT_AFTERCREATE = 1055;
  INT_DEFCUSTOM = 2147483647;
  INT_BALLONR = $a8;
  INT_BALLONG = $e6;
  INT_BALLONB = $fd;
  INT_VDEFSPLITTER = 200;
  INT_COLUMN0 = 180;
  INT_COLUMNPROPERTY = 200;
  INT_COLUMNHISTORY = 200;
  INT_COLUMNMARGIN = 10;
  INT_DEFFTPPORT = 21;
  INT_COLUMNS = 100;
  INT_MODALRESULTCANCEL = -1;
  INT_DEFTIMER = 180;
  INT_BADVALUE = -1;
  INT_FTPFIELDCOUNT = 37;
  INT_NOTLSSUPPORT = 0;
  INT_AUTHTYPEAUTO = 4;
  INT_DATAPROTECTIONCLEAR = 0;
  INT_STDPROXY = 8080;
  INT_IMPLICIT = 2;
  INT_IMPLICITPORT = 990; 
  INT_STDDATAPORT = 0;
  INT_STDMINPORT = 0;
  INT_VERIFYDEPTH = 0;
  INT_STDTRANSFERTIMEOUT = 10000;
  INT_STDCONNECTIONTIMEOUT = 10000;
  INT_TCPDEFAULTTIMEOUT = 10000;
  INT_PAUSEBB = 3000;
  INT_SSLMODEUNASSIGNED = 3;
  INT_SOURCE = 0;
  INT_NOFILECOPIED = 0;
  INT_FILESUCCESFULLYCOPIED = 1;
  INT_FILESUCCESFULLYENCRYPTED = 1;
  INT_NOFILEENCRYPTED = 0;
  INT_DESTINATION = 1;
  INT_INDEXPARKED = 11;
  INT_INDEXCURRENT = 12;
  INT_MAX_PATHW = 3000;
  INT_INDEXBUINCDIF = 10;
  INT_INDEXBUFULL = 9;
  INT_STDMAXPORT = 0;
  INT_NOPROXY = 0;
  INT_INDEXFILEICON = 8;
  INT_INDEXDIRICON = 9;
  INT_INDEXFTPICON = 10;
  INT_INDEXEVENTICON = 11;
  INT_INDEXRUNNING = 0;
  INT_INDEXSTOPPED = 1;
  INT_INDEXPAUSED = 2;
  INT_INDEXUNKNOWN = 3;
  INT_INDEXUMASKICON = 7;
  INT_INDEXNOLOADED = 2;
  INT_INDEXOK = 3;
  INT_INDEXWARNING = 4;
  INT_INDEXFILELIST = 5;
  INT_INDEXDIRLIST = 6;
  INT_INDEXFTPLIST = 7;
  INT_INDEXMANUALLIST = 8;
  INT_DEFZIPCOMPRESSION = 6;
  INT_INDEXMAIL = 10;
  INT_TASKCOUNT = 38;
  INT_MAXLINELENGTH = -1;
  INT_COPYBUFFER = 49152;
  INT_DEFITERACTIONS = 100;
  INT_FTPFAILED = -1;
  INT_SERVICEINSTALLED = 0;
  INT_SERVICERUNNING = 0;
  INT_SERVICEDELETED = 0;
  INT_SERVICEUNINSTALLEDFAILED = 0;
  WS_DOMAINPRE: WideString = '.\';
  BOOL_EV_BEFORE = true;
  BOOL_EV_AFTER = false;
  S_SERVICEINSTALLFN: AnsiString = 'InstallService';
  S_SERVICEINSTALLEDFN: AnsiString = 'ServiceInstalled';
  S_SERVICERUNNINGFN: AnsiString = 'ServiceRunning';
  WS_DEFPUBLICKEYEXTDLG: WideString = 'pub';
  WC_COLON: WideChar = ':';
  AC_HEADERENCODING: AnsiChar = 'B';
  S_UTF: AnsiString = 'idcsUTF_8';
  WC_SEMICOLON: WideChar = ';';
  WC_SLASH: WideChar = '/';
  S_SLASH: AnsiChar = '/';
  WC_SLASDASH: WideChar = '-';
  WC_BACKSLASH: WideChar= '\';
  WC_ASTERISC: WideChar= '*';
  WC_QUESTION: WideChar= '?';
  WC_MORETHAN: WideChar= '>';
  WC_LESSTHAN: WideChar= '<';
  WC_PIPE: WideChar= '|';
  WS_SEP: WideString = '-*-';
  WS_TILDE: WideChar = '~';
  S_ZIPTYPE: AnsiString = 'application/zip';
  S_NIL: AnsiString = '';
  WS_ENCRYPTEDEXT: WideString = '.enc';
  WS_SQXRECEXT: WideString = '.sqr';
  WS_CLONEOF: WideString = ' [%d]';
  WS_ENCRYPTEDEXTNOTDOT: WideString = 'enc';
  WS_LINKEXT: WideString = '.lnk';
  WS_LISTEXTNODOT: WideString = 'lst';
  WS_DEFWAVEXT: WideString = 'wav';
  WS_ZIPEXT: WideString = '.zip';
  WS_SQXEXT: WideString = '.sqx';
  WS_DEFEXEEXTDLG: WideString = 'exe';
  WS_ENCRYPTIONFILTER: WideString = '%s (*.enc)|*.enc|%s (*.*)|*.*';
  WS_PUBLICKEYFILTER: WideString = '%s (*.pub)|*.pub|%s (*.*)|*.*';
  WS_PRIVATEKEYFILTER: WideString = '%s (*.prv)|*.prv|%s (*.*)|*.*';
  WS_LISTFILTER: WideString = '%s (*.lst)|*.lst|%s (*.*)|*.*';
  WS_PUBLICKEYEXT: WideString = 'pub';
  WS_PRIVATEKEYEXT: WideString = 'prv';
  WS_PUBLICKEYEXTDOT: WideString = '.pub';
  WS_PRIVATEKEYEXTDOT: WideString = '.prv';
  WS_WAVFILTER: WideString = '%s (*.wav)|*.wav|%s (*.*)|*.*';
  WS_EXECKEYFILTER: WideString = '%s (*.exe,*com,*bat)|*.exe;*.com;*.bat|%s (*.*)|*.*';
  WS_ALLFILESFILTER: WideString = '%s (*.*)|*.*';
  WS_PASSWORDCHAR: WideChar = '*';
  WS_ALLFILES: WideString = '*.*';
  WS_JOCKER: WideString = '*';
  WS_ALLFILESNOTDOT: WideString = '*';
  WS_SITEPAYPAL: WideString = 'paypal.htm';
  WS_SITEINDEX: WideString = 'index.htm';
  WS_SITETUTORIAL: WideString = 'tutorial.htm';
  WS_SITEWELCOME: WideString = 'welcome.htm';
  WS_SITEEXTERNAL: WideString = 'external.htm';
  WS_JOCKERDOT: WideString = '.*';
  WS_NOPASSWORDCHAR: WideChar = #0;
  WS_STDDATETIMEFORMAT: WideString = 'yyyy-mm-dd hh;nn;ss';
  S_INITPROCEDUREADDRESS: PAnsiChar = 'Init';
  S_DEINITPROCEDUREADDRESS: PAnsiChar = 'DeInit';
  S_GETSERVICELIST: PAnsiChar = 'GetServices';
  S_STARTASERVICE: PAnsiChar = 'StartAService';
  S_STOPASERVICE: PAnsiChar = 'StopAService';
  S_UNINSTALLSERVICE: PAnsiChar = 'UninstallService';
  S_ASSIGNPRIVILEGE: PAnsiChar = 'AddLogonAsAService';
  S_COPYNTFSNAME: PAnsiChar = 'CopySecurityW';
  S_MAINDECENTRY: PAnsiChar = 'MainEntry';
  S_COPYNTCREATE: PChar = 'CreateNTSecW';
  S_COPYNTDESTROY: PChar = 'DestroyNTSecW';
  S_LIBGRANTACCESS: AnsiString = 'GrantAccessToEveryoneW';
  S_COBHEADER: AnsiString = '*@COBIANHEADER@*';
  WS_SERVICELOGON: WideString = 'SeServiceLogonRight';
  WS_INIFORMAT: WideString = '%s=%s';
  WS_MAINLIST: WideString = 'Main List.lst';
  WS_STRINGNOFOUND: WideString = 'String not found';
  //WS_DEFCOMMENT: WideString = 'Archive created by %s';
  WS_FTPDISPLAY: WideString = 'ftp://%s:*@%s:%d/%s';
  WS_FTPROORDIR: WideString = '/';
  WS_ENGLISH: WideString = 'english';
  WS_LOCALDOMAIN: WideString = '.';
  WS_UIEXTENSION: WideString = '.cui';
  WS_MSGEXTENSION: WideString = '.cms';
  WS_LANGUAGEMASK: WideString = '*.cui';
  WS_AUTOUNINSTALL: WideString = '-AUTOUNINSTALL';
  WS_TEXTEXT: WideString = '.txt';
  WS_DATAEXT: WideString = '.dat';
  WS_NOEXT: WideString = '';
  WC_DOT: WideChar = '.';
  WC_UNDER: WideChar = '_';
  WS_MANIFESTEXT: WideString = '.manifest';
  WS_NOTMANIFESTEXT: WideString = '.manifes_';
  WS_SERVICEPARAM: WideString = '-service';
  WS_LOGFILENAME: WideString = 'log.txt';
  WS_EXPLOREREXE: WideString = 'explorer.exe';
  WS_TEMPFILENAME: WideString = 'temp.txt';
  WS_LOGFILENAMECOPY: WideString = 'log_copy.txt';
  WS_TASKBEGIN: WideString = '{8//';
  WS_TASKEND: WideString = '//8}';
  WS_DEFSENDER: WideString = '%s [%s]';
  WS_DEFSUBJECT: WideString = '%s [%s] (%s)';
  WS_LOGTOMAIL: WideString = '%s Log %s.txt';
  WS_NONEXISTINGDIR: WideString = ' (%d)';
  WS_LUFLAG: WideString = 'cbUpdates.ini';
  WS_TRAYCLASS: WideString = 'TrayNotifyWnd';
  WS_CURRENTDIR: WideString = '.';
  WS_PARENTDIR: WideString ='..';
  WS_SPACE: WideString = ' ';
  WS_SPACEHTML: WideString = '%20';
  WS_UNDER: WideString = '_';
  WS_HISTORYEXT: WideString = '.cbu';
  BOOL_NEED_TO_RELOAD = true;
  BOOL_NO_NEED_TO_RELOAD = false;
  BOOL_BACKUP_NOW = true;
  BOOL_NO_NEED_TO_BACKUP = false;
  BOOL_AUTOCLOSE = true;
  BOOL_BACKUP_ALL_NOW = true;
  BOOL_NO_AUTOCLOSE = false;
  WS_ERROR: WideString = 'ERR';
  WS_HTMEXT: WideString = '.htm';
  WS_HTMLEXT: WideString = '.htm';
  WS_NOERROR: WideString = '   ';
  WS_LOGSTRING: WideString = '%s %s %s';
  WS_ASCIIDEF: WideString = '';
  INT_FOURPARAMS = 4;
  INT_WEEK = 7;
  INT_PROGRESSINFO = 5;
  INT_FTPDEFSPEED = 28672;
  BOOL_DOABORT = true;
  BOOL_CONTINUE = false;
  WS_MAILTO: WideString = 'mailto:%s';
  INT_SENDERBEFORE = 0;
  INT_100 = 100;
  INT_SENDERAFTER = 1;
  INT_SENDERSOURCE = 0;
  INT_SENDERDESTINATION = 1;
  INT_SMTPPORT = 25;
  INT_ALLFILES = 10431;  //magic number :-)
  INT_SMTPNOLOGON = 0;
  WS_DISPLAY: WideString= '%s: %s';
  WS_APPHINT: WideString = '%s - %s %d%% (%d%%)';
  INT_TIMETOCLOSE = 3000;
  WS_CLASS: WideString = 'class:';
  WS_DEFUNCOMPRESSED: WideString = '.mp3,.mpeg,.zip,.rar,.arj,.jpg,.jpeg';
  INT_SQXDEFDICTIONARY = 7;
  INT_SQXDEFLEVEL = 2;
  INT_SQXDEFRECOVERY = 0;
  INT_PRIVILEGEASSIGNED = 0;
  INT_PRIVILEGEERROR = 1;
  INT_SECNOTERRORES = 0;
  WS_PROGRAMKEY: WideString = '\Software\%s\%s';
  WS_REGSTDLANGUAGE: WideString = 'Language';
  WS_REGSHELLFOLDERS: WideString =
    '\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
  WS_REGPROGRAMFOLDERS: WideString = 'Programs';
  WS_REGCOMMONPROGRAMS: WideString = 'Common Programs';
  WS_REGSHELLFOLDERSOLD: WideString =
    '\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
  WS_REGUNINSTALL: WideString = '\Software\Microsoft\Windows\CurrentVersion\Uninstall\%s';

  // Old versions
  WS_SEPB6: WideString = '*************************************';
  WS_SEPE6: WideString = '#####################################';
  WS_SEPB7: WideString = '{';
  WS_SEPE7: WideString = '}';

  //Versions of the program
  INT_VER0 = 0;
  INT_VER1 = 1;
  INT_VER2 = 2;
  INT_VER3 = 3;
  INT_VER4 = 4;
  INT_VER5 = 5;
  INT_VER6 = 6;
  INT_VER7 = 7;
  INT_VER8 = 8;

  //SPLITS
  SIZE360K = 362496;
  SIZE720K = 730112;
  SIZE1C2M = 1213952;
  SIZE1C4M = 1457664;
  SIZE100M = 99328000;
  SIZE250M = 250331136;
  SIZE650M = 681574400;
  SIZE700M = 734003200;
  SIZE1C0G = 1070000000;
  SIZE4C7G = 4300000000;

  // Version 8 task
  WS_TASK_NAME: WideString = 'Name';
  WS_TASK_ID: WideString = 'ID';
  WS_TASK_DISABLED: WideString = 'Disabled';
  WS_TASK_INCLUDESUBDIRS: WideString = 'Include subdirectories';
  WS_TASK_SEPARATED: WideString = 'Separated backups';
  WS_TASK_USEATTRIBUTES: WideString = 'Use attributes';
  WS_TASK_RESETATTRIBUTES: WideString = 'Reset attributes';
  WS_TASK_BACKUPTYPE: WideString = 'Backup type';
  WS_TASK_FULLTOKEEP: WideString = 'Full copies to keep';
  WS_TASK_SOURCE: WideString = 'Source';
  WS_TASK_DESTINATION: WideString = 'Destination';
  WS_TASK_SCHEDULETYPE: WideString = 'Schedule type';
  WS_TASK_DATETIME: WideString = 'Date/Time';
  WS_TASK_DAYWEEK: WideString = 'Day of the week';
  WS_TASK_DAYMONTH: WideString = 'Day of the month';
  WS_TASK_MONTH: WideString = 'Month';
  WS_TASK_TIMER: WideString = 'Timer';
  WS_TASK_MAKEFULL: WideString = 'Make full backup';
  WS_TASK_COMPRESS: WideString = 'Compress';
  WS_TASK_ARCHIVEPROTECT: WideString = 'Protect archive';
  WS_TASK_PASSWORD: WideString = 'Password';
  WS_TASK_SPLIT: WideString = 'Split';
  WS_TASK_SPLITCUSTOM: WideString = 'Split custom size';
  WS_TASK_COMMENT: WideString = 'Archive comment';
  WS_TASK_ENCRYPT: WideString = 'Encrypt';
  WS_TASK_PASSPHRASE: WideString = 'Passphrase';
  WS_TASK_PUBLICKEY: WideString = 'Public key';
  WS_TASK_INCLUDE: WideString = 'Include masks';
  WS_TASK_EXCLUDE: WideString = 'Exclude masks';
  WS_TASK_BEFOREEVENTS: WideString = 'Before backup events';
  WS_TASK_AFTEREVENTS: WideString = 'After backup events';
  WS_TASK_IMPERSONATE: WideString = 'Impersonate';
  WS_TASK_IMPERSONATECANCEL: WideString = 'Cancel if impersonate fails';
  WS_TASK_IMPERSONATEID: WideString = 'Impersonate ID';
  WS_TASK_IMPERSONATEDOMAIN: WideString = 'Impersonate domain';
  WS_TASK_IMPERSONATEPASSWORD: WideString = 'Impersonate password';

  // Parameters for the installation
  WS_PROGRAMNAMEPARAM: WideString = '%PROGRAMNAME%';
  WS_AUTHORPARAM: WideString = '%AUTHOR%';
  WS_WEBPARAM: WideString = '%WEBADDRESS%';
  WS_MAILPARAM: WideString = '%MAILADDRESS%';
  WS_DISTROZIPNAME: WideString = 'DISTRO.ZIP';
  S_RESOURCESTRING: AnsiString = 'DISTRO RCDATA DISTRO.ZIP';
  WS_RESOURCENAMERC: WideString = 'DISTRORES.RC';
  WS_RESOURCE: WideString = 'DISTRORES.RES';
  WS_AUTHORPARAMSHORT: WideString = '%AUTHORNAMESHORT%';
  WS_PARAMMANIFESTNAME: WideString = '%MANIFESTNAME%';

  //Version 7 tasks
  S_7NAME: AnsiString = 'Name';
  S_7ID: AnsiString  = 'ID';
  S_7DISABLED: AnsiString = 'Disabled';
  S_7SUBDIRS: AnsiString = 'Include subdirectories';
  S_7OVERWRITE: AnsiString = 'Overwrite';
  S_7BACKUPTYPE: AnsiString = 'Backup type';
  S_7COPIESTOKEEP: AnsiString = 'Copies to keep';
  S_7SOURCE: AnsiString = 'Source';
  S_7DESTINATION: AnsiString = 'Destination';
  S_7SCHEDULETYPE: AnsiString = 'Schedule type';
  S_7DATETIME: AnsiString = 'Date-Time';
  S_7DAYWEEK: AnsiString = 'Day of the week';
  S_7DAYMONTH: AnsiString = 'Day of the month';
  S_7TIMER: AnsiString = 'Timer';
  S_7EVERYXFULL: AnsiString = 'Force full every X';
  S_7COMPRESSION: AnsiString = 'Compression';
  S_7ARCHIVEPROTECT: AnsiString = 'Protect archive';
  S_7PASSWORD: AnsiString = 'Password';
  S_7SPLIT: AnsiString = 'Split';
  S_7SPLITCUSTOM: AnsiString = 'Split custom size';
  S_7ARCHIVECOMMENT: AnsiString = 'Archive comment';
  S_7INCLUDE: AnsiString = 'Include files';
  S_7EXCLUDE: AnsiString = 'Exclude files';
  S_7BEFOREEVENT: AnsiString = 'Before backup';
  S_7AFTEREVENT: AnsiString = 'After backup';
  S_7ENCRYPTION: AnsiString = 'Encryption';
  S_7PASSPHRASE: AnsiString = 'Passphrase';
  S_7DONOTRESETARCHIVE: AnsiString = 'Do not reset archive attribute';

  // v6 tasks
  //Backup version 6 tasks
  S_6ID: AnsiString = 'ID';
  S_6NAME: AnsiString = 'Name';
  S_6DISABLED: AnsiString = 'Disabled';
  S_6SUBDIRS: AnsiString = 'SubDirs';
  S_6OVERWRITE: AnsiString = 'Overwrite';
  S_6INCREMENTAL: AnsiString = 'Incremental';
  S_6KEEP: AnsiString = 'Keep';
  S_6SOURCE: AnsiString = 'Source';
  S_6DESTINATION: AnsiString = 'Destination';
  S_6BACKUPTYPE: AnsiString = 'BackupType';
  S_6DATETIME: AnsiString = 'DateTime';
  S_6DAYWEEK: AnsiString = 'DayWeek';
  S_6DAYMONTH: AnsiString = 'DayMonth';
  S_6TIMER: AnsiString = 'Timer';
  S_6COMPRESS: AnsiString = 'Compress';
  S_6SPLIT: AnsiString = 'Split';
  S_6SPLITBLOCKS: AnsiString = 'SplitBlocks';
  S_6CHUNKS: AnsiString = 'Chunk bytes';
  S_6COMMENT: AnsiString = 'ZipComment';
  S_6EXCLUDE: AnsiString = 'Exclude'; //not used
  S_6INCLUDEFILES: AnsiString = 'IncludeFiles';
  S_6EXCLUDEFILES: AnsiString = 'ExcludeFiles';
  S_6BEFORE: AnsiString = 'Before';
  S_6AFTER: AnsiString = 'After';
  S_6ENCRYPT: AnsiString = 'Encryption';

  //Autostart
  INT_AUTOSTARTNONE = 0;
  INT_AUTOSTARTCURRENT = 1;
  INT_AUTOSTARTALL = 2;

  // zip64
  INT_ZIP64ALWAYS = 0;
  INT_ZIP64AUTO = 1;
  INT_ZIP64NEVER = 2;

  //libraries
  INT_LIBOK= 0;
  INT_LIBCOULDNOTLOAD = 1;
  INT_LIBNOPROCEDURE = 2;
  INT_LIBOTHERERROR = 3;
  INT_LIBUNDEFINED = 9000;

  // Parameters
  WS_PARCOMPUTERNAME: WideString = '%COMPUTERNAME';
  WS_PARCOMPUTERNAMENOSPACES: WideString = '%COMPUTERNAMENOSPACES';
  WS_PARAMDATE: WideString = '%DATENOTIME';
  WS_PARAMDATETIME: WideString ='%DATETIME';
  WS_PARAMTASKNAME: WideString = '%TASKNAME';
  WS_PARAMTIME: WideString  = '%TIMENODATE';

  // WS_PARAMCLEANSOURCE: WideString = '%SOURCE';
  // WS_PARAMCLEANDESTINATION: WideString = '%DESTINATION';

  // balloon
  INT_MSGMARGIN = 8;
  INT_MSGHEIGHT = 50;
  INT_MARGINSCREENW = 20;
  INT_MARGINSCREENH = 25;
  INT_IMAGEWIDTH = 25;

  // SSL methods
  INT_SSLV2 = 0;
  INT_SSLV23 = 1;
  INT_SSLV3 = 2;
  INT_SSLTLSV1 = 3;

  // TLS
  INT_TLS_NONE = 0;
  INT_TLS_EXPLICIT = 1;
  INT_TLS_IMPLICIT = 2;
  INT_TLS_REQUIRE = 3;

  //
  INT_DATACLEAR = 0;
  INT_DATAPRIVATE = 1;

  // Transfers
  INT_FAILTRANSFERFAILED = 0;
  INT_FILETRANSFERED = 1;
  INT_NOFTPFILES= -1;

  // Authentication type
  INT_AUTH_SSL = 0;
  INT_AUTH_TLS = 1;
  INT_AUTH_TLSC = 2;
  INT_AUTH_TLSP = 3;
  INT_AUTH_AUTO = 4;

  // SSLMode
  INT_SSL_MODEBOTH = 0;
  INT_SSL_MODECLIENT = 1;
  INT_SSL_MODESERVER = 2;
  INT_SSL_MODEUNASIGNED = 3;

  // Encryption secundary
  BOOL_ENCSECUNDARY = true;
  BOOL_ENCPRIMARY = false;

  // Proxies
  INT_PROXY_NOPROXY = 0;
  INT_PROXY_HTTPWITHFTP = 1;
  INT_PROXY_OPEN = 2;
  INT_PROXY_SITE = 3;
  INT_PROXY_TRANSPARENT = 4;
  INT_PROXY_USERPASS = 5;
  INT_PROXY_USERSITE = 6;
  INT_PROXY_CUSTOM = 7;
  INT_PROXY_NOVELLBORDER = 8;
  INT_PROXY_USERHOSTFIREWALLID = 9;

  // Operations
  INT_OPBUBEGIN = -600;
  INT_OPCLOSE = -500;
  INT_OPEXECUTEANDWAIT = -400;
  INT_OPEXECUTE = -300;
  INT_OPIDLE = -100;
  INT_OPCLOSEUI = -200;
  INT_NOOPERATION = -1;
  INT_OPCOPY = 0;
  INT_OPCOMPRESS = 1;
  INT_OPENCRYPT = 2;
  INT_OPFTPUP = 3;
  INT_OPFTPDOWN = 4;
  INT_OPCRC = 5;
  INT_OPDELETING = 6;
  INT_OPUIFTPDEL = 1000;
  INT_OPUILOCALDEL = 1001;
  INT_OPUIATTRIBUTES = 1002;
  INT_OPTESTFTP = 2001;
  INT_OPTESTSMTP = 2002;

  // REsult CloseAWindow
  INT_CW_CLOSED = 0;
  INT_CW_NOFOUND = 1;
  INT_CW_COULDNOTBECLODED = 2;

  // Ini
  WS_INIWARNMULTIPLE: WideString = 'Warn for multiple instances';
  WS_INICURRENTLIST: WideString = 'Current list';
  WS_INILANGUAGE: WideString = 'Language';
  WS_INILOG: WideString = 'Log';
  WS_INILOGERRORSONLY: WideString = 'Log errors only';
  WS_INILOGVERBOSE: WideString = 'Log verbose';
  WS_INILOGREALTIME: WideString = 'Log real time';
  WS_INIWELCOMESCREEN: WideString = 'Show welcome screen';
  WS_INILEFT: WideString = 'Left';
  WS_INITOP: WideString = 'Top';
  WS_INIWIDTH: WideString = 'Width';
  WS_INIHEIGHT: WideString = 'Height';
  WS_INISHOWHINTS: WideString = 'Show hints';
  WS_INIFONTNAME: WideString = 'Font name';
  WS_INIFONTSIZE: WideString = 'Font size';
  WS_INIFONTCHARSET: WideString = 'Font CharSet';
  WS_INIFONTNAMELOG: WideString = 'Font name log';
  WS_INIFONTSIZELOG: WideString = 'Font size log';
  WS_INIFONTCHARSETLOG: WideString = 'Font CharSet log';
  WS_INIPASSWORD: WideString = 'Password';
  WS_INIPROTECTUI: WideString = 'Protect UI';
  WS_INICONFIRMCLOSE: WideString = 'Confirm Close';
  WS_INICLEARPASSWORDCACHE: WideString = 'Clear password cache';
  WS_INIPROTECTMAINWINDOW: WideString = 'Protect main window';
  WS_INIMAILLOG: WideString = 'Mail log';
  WS_INIMAILAFTERBACKUP: WideString = 'Mail after backup';
  WS_INIMAILSCHEDULED: WideString = 'Mail scheduled';
  WS_INIMAILASATTACMMENT: WideString = 'Mail as attachment';
  WS_INIMAILIFERRORSONLY: WideString = 'Mail if errors only';
  WS_INIMAILDELETE: WideString = 'Delete log on mail';
  WS_INIMAILDATETIME: WideString = 'Mail time';
  WS_INISMTPSENDER: WideString = 'SMTP Sender';
  WS_INISMTPSENDERADDRESS: WideString = 'SMTP Sender Address';
  WS_INISMTPDESTINATION: WideString = 'SMTP Destinatary';
  WS_INISMTPHOST: WideString = 'SMTP Host';
  WS_INISMTPPORT: WideString = 'SMTP Port';
  WS_INISMTPSUBJECT: WideString = 'SMTP Subject';
  WS_INISMTPAUTHENTICATION: WideString = 'SMTP Authentication';
  WS_INISMTPID: WideString = 'SMTP ID';
  WS_INISMTPPASSWORD: WideString = 'SMTP Password';
  WS_INISMTPHELONAME: WideString = 'SMTP Helo Name';
  WS_INISMTPPIPELINE: WideString = 'SMTP Pipeline';
  WS_INISMTPEHLO: WideString = 'SMTP Use Ehlo';
  WS_INITCPREAD: WideString = 'Read timeout';
  WS_INITCPCONNECTION: WideString = 'Connection timeout';
  WS_INITEMP: WideString = 'Temporary directory';
  WS_INISHOWEXACTPERCENT: WideString = 'Show exact percent';
  WS_INIUSECURRENTDESKTOP: WideString = 'Use current desktop';
  WS_INIFORCEFIRSTFULL: WideString = 'Force first full';
  WS_INIDATETIMEFORMAT: WideString = 'Date/Time format';
  WS_INIDONOTSEPARATEDATE: WideString = 'Do not separate datetime';
  WS_INIDONOTUSESPACES: WideString = 'Do not use spaces';
  WS_INIUSESHELL: WideString = 'Use shell functions only';
  WS_INIUSEALTERNATIVEMETHODS: WideString = 'Use alternative methods';
  WS_INICOPYATTRIBUTES: WideString = 'Copy attributes';
  WS_INICOPYTOMESTAMPS: WideString = 'Copy timestamps';
  WS_INIPARKFIRSTBACKUP: WideString = 'Park first backup';
  WS_INIDELETEEMPTYFOLDERS: WideString = 'Delete empty folders';
  WS_INIALWAYSCREATEFOLDER: WideString = 'Always create destination folder';
  WS_INICOMPRESIONABSOLUTE: WideString = 'Absolute paths';
  WS_INICOPYNTFS: WideString = 'Copy NTFS permissions';
  WS_INIZIPLEVEL: WideString = 'Zip compression level';
  WS_INICOMPUSETASKNAME: WideString = 'Use task names in archive names';
  WS_INIZIPADVANCEDNAMING: WideString = 'Zip advanced naming';
  WS_INICOMPCRC : WideString = 'Check the CRC for compressed archives';
  WS_INICOMPOEM: WideString = 'Use OEM file names in archives';
  WS_INILOWPRIORITY: WideString = 'Low priority';
  WS_INIZIP64: WideString = 'Use Zip64';
  WS_INICOMPUNCOMPRESSED: WideString = 'Uncompressed extensions';
  WS_INICOPYBUFFER: WideString = 'Copy buffer';
  WS_INICHECKCRCNOCOMP: WideString = 'Check non compressed CRC';
  WS_INIVSPLITTER: WideString = 'Vertical main splitter';
  WS_INIMAINLVTYPE: WideString = 'Main list view';
  WS_INIMAINLVCOLUMN0: WideString = 'Main column 0';
  WS_INIMAINLVCOLUMN1: WideString = 'Main column 1';
  WS_INIMAINLVCOLUMN2: WideString = 'Main column 2';
  WS_INIPROPERTYLVCOLUMN0: WideString = 'Property column 0';
  WS_INIPROPERTYLVCOLUMN1: WideString = 'Property column 1';
  WS_INIHISTORYLVCOLUMN0: WideString = 'Property column 0';
  WS_INIHISTORYLVCOLUMN1: WideString = 'Property column 1';
  WS_INIHISTORYLVCOLUMN2: WideString = 'Property column 2';
  WS_INIBACKUPLEFT: WideString = 'Backup window left';
  WS_INIBACKUPTOP: WideString = 'Backup window top';
  WS_INIBACKUPWIDTH: WideString = 'Backup window width';
  WS_INIBACKUPHEIGHT: WideString = 'Backup window height';
  WS_INIBACKUPCOLUMN0: WideString = 'Backup window column 0';
  WS_INIBACKUPCOLUMN1: WideString = 'Backup window column 1';
  WS_INISWINDOWWIDTH: WideString = 'Service width';
  WS_INISWINDOWHEIGHT: WideString = 'Service height';
  WS_INISWINDOWLEFT: WideString = 'Service left';
  WS_INISWINDOWTOP: WideString = 'Service top';
  WS_INISWINDOWCOLUMN0: WideString = 'Service column 0 width';
  WS_INISWINDOWCOLUMN1: WideString = 'Service column 1 width';
  WS_INISWINDOWCOLUMN2: WideString = 'Service column 2 width';
  WS_INIHOTKEY: WideString = 'Hot key';
  WS_INIWORDWRAP: WideString = 'Word wrap';
  WS_INISHOWICONS: WideString = 'Show icons in tabs';
  WS_INILASTINCLUDESUB: WideString = 'Include subdirectories';
  WS_INISEPARATEBACKUPS: WideString = 'Separate backups';
  WS_INIUSEATTRIBUTES: WideString = 'Use attributes';
  WS_INIRESETATTRIBUTES: WideString = 'Reset attributes';
  WS_INIBACKUPTYPE: WideString = 'Backup type';
  WS_INIFULLCOPIES: WideString = 'Full copies to keep';
  WS_INIMAKEFULL: WideString = 'Make X full';
  WS_INIDESTINATION: WideString = 'Destination';
  WS_INISCHEDULETYPE: WideString = 'Schedule type';
  WS_INIDAYSOFWEEK: WideString = 'Days of the week';
  WS_INIDATETIME: WideString = 'Date/Time';
  WS_INIDAYSOFMONTH: WideString= 'Days of the month';
  WS_INIMONTH: Widestring = 'Month';
  WS_INITIMER: WideString = 'Timer';
  WS_INICOMPRESSION: WideString= 'Compression';
  WS_INISPLIT: WideString= 'Split';
  WS_INICOMPPASSWORD: WideString = 'Compression password';
  WS_INILASTUSEDFTP: WideString = 'Last used FTP';
  WS_INILASTUSEDDIRECTORY: WideString = 'Last used directory';
  WS_INISPLITCUSTOM: WideString = 'Custom split size';
  WS_INIPROTECTARCHIVE: WideString = 'Protect archive';
  WS_INICOMMENT: WideString = 'Archive comment';
  WS_INIENCRYPTION: WideString = 'Encryption type';
  WS_INIPASSPHRASE: WideString = 'Passphrase';
  WS_INIPUBLICKEY: WideString = 'Public key';
  WS_INIINCLUDE: WideString = 'Include';
  WS_INIEXCLUDE: WideString = 'Exclude';
  WS_INIBEFORE: WideString = 'Before backup';
  WS_INIAFTER: WideString = 'After backup';
  WS_INISAVEADVANCED: WideString = 'Save advanced settings';
  WS_INIDEFERENCELINKS: WIdeString = 'Deference links';
  WS_INIHINTCOLOR: WideString = 'Hint color';
  WS_INICALCULATESIZE: WideString = 'Calculate size';
  WS_INISHOWBACKUPHINT: WideString = 'Show backup hints';
  WS_INISHOWDIALOGEND: WideString = 'Show a dialog when a backup is done';
  WS_INIPLAYSOUND: WideString = 'Play sound';
  WS_INIFILETOPLAY: WideString = 'File to play';
  WS_INISHOWPERCENT: WideString = 'Show percent';
  WS_INICLEARLOGTAB: WideString = 'Clear log tab when a backup begins';
  WS_INICONFIRMRUN: WideString = 'Confirm run';
  WS_INICONFIRMABORT: WideString = 'Confirm abort';
  WS_INIFORCEINTERNALHELP: WideString = 'Force internal help';
  WS_ININAVIGATEINTERNALLY: WideString = 'Navigate internally';
  WS_INIAUTOSHOWLOG: WideString = 'Automatically show the log file';
  WS_INISHOWGRID: WideString = 'Show grid';
  WS_INIHINTHIDE: WideString = 'Hint hide time';
  WS_INICONVERTTOUNC: WideString = 'Automatically convert paths to UNC';
  WS_INIIMPERSONATE: WideString = 'Impersonate';
  WS_INIIMPERSONATECANCEL: WideString = 'Abort if impersonation fails';
  WS_INIIMPERSONATIONID: WideString = 'Impersonation ID';
  WS_INIIMPERSONATIONDOMAIN: WideString = 'Impersonation domain';
  WS_INIIMPERSONATIONPASSWORD: WideString = 'Impersonation password';
  WS_INIDECDESTINATION: WideString = 'Decryptor destination';
  WS_INIDECOLDMETHODS: WideString = 'Decryptor old methods';
  WS_INIDECNEWMETHODINDEX: WideString = 'Decryptor new method index';
  WS_INIDECOLDMETHODINDEX: WideString = 'Decryptor old method index';
  WS_INIDECPRIVATEKEY: WideString = 'Decryptor private key';
  WS_INIDECUNENCRYPTEDKEY: WideString = 'Decryptor unencrypted private key';
  WS_INIDECUNENCRYPTEDKEYGEN: WideString = 'Decryptor unencrypted private key for generation';
  WS_INIDECWORDWRAP: WideString = 'Decryptor wordwrap';
  WS_INIGENKEYSIZE: WideString = 'Generator key size';
  WS_INIDECKEYSIZE: WideString = 'Decryptor key size';
  WS_INIKEYSIZE: WideString = 'Key size';
  WS_INISQXLEVEL: WideString = 'SQX level';
  WS_INISQXDICTIONARY: WideString = 'SQX dictionary';
  WS_INISQXRECOVERY: WideString = 'SQX recovery';
  WS_INISQXEXTERNAL: WideString = 'SQX external recovery file';
  WS_INISQXEXE: WideString = 'SQX exe compression';
  WS_INISQXMULTIMEDIA: WideString = 'SQX multimedia compression';
  WS_INISQXSOLID: WideString = 'SQX solid archives';
  WS_INIFTPLIMIT: WideString = 'Limit FTP speed';
  WS_INIFTPSPEED: WideString = 'Max FTP speed';
  WS_INIFTPASCII: WideString = 'FTP ASCII extensions';
  WS_INISHUTDOWNKILL: WideString = 'Kill when shutting down';
  WS_INIAUTOCHECK: WideString = 'Automatically check for new versions';
  WS_INIRUNOLD: WideString = 'Run old backups';
  WS_INIRUNOLDDONTASK: WideString = 'Run old backups without asking';
  WS_INIPROPAGATEMASKS: WideString = 'Propagate masks';
  WS_INIAUTOSETUPNAME: WideString = 'Name';
  WS_INIAUTOSETUPORGANIZATION: WideString = 'Organization';
  WS_INIAUTOSETUPSERIAL: WideString = 'Serial number';
  WS_INIAUTOSETUPACCEPT: WideString = 'Accept license';
  WS_INIAUTOSETUPDIRECTORY: WideString = 'Installation directory';
  WS_INIAUTOCREATEICONS: WideString = 'Create icons';
  WS_INIAUTOINSTALLATIONTYPE: WideString = 'Installation type';
  WS_INIAUTOLOGON: WideString = 'Logon type';
  WS_INIAUTOID: WideString = 'ID';
  WS_INIAUTOPASSWORD = 'Password';
  WS_INIAUTOUI: WideString = 'Autostart UI';

  // Installation
  INT_INSTALLAPPALL = 0;
  INT_INSTALLAPPCURRENT = 1;
  INT_INSTALLAPPNONE = 2;
  INT_INSTALLAPPSERVICE = 3;
  INT_INSTALLLOGONSYSTEM = 0;
  INT_INSTALLLOGONUSER = 1;

  //Months
  INT_MJANUARY = 0;
  INT_MFEBRUARY = 1;
  INT_MMARCH = 2;
  INT_MAPRIL = 3;
  INT_MMAY = 4;
  INT_MJUNE = 5;
  INT_MJULY = 6;
  INT_MAUGUSTY = 7;
  INT_MSEPTEMBER = 8;
  INT_MOCTOBER = 9;
  INT_MNOVEMBER = 10;
  INT_MDECEMBER = 11;

  //SERVICES
  WS_STOPPED: WideString = 'STOPPED';
  WS_STARTPENDING: WideString = 'STARTPENDING';
  WS_STOPPENDING: WideString = 'STOPPENDING';
  WS_RUNNING: WideString = 'RUNING';
  WS_CONNTINUE_PENDING: WideString = 'CONTINUEPENDING';
  WS_PAUSE_PENDING: WideString = 'PAUSEPENDING';
  WS_PAUSED: WideString = 'PAUSED';
  WS_UNKNOWN: WideString = 'UNKNOWN';

  //Events
  WS_EVPAUSE: WideString = 'PAUSE';
  WS_EVEXECUTE: WideString = 'EXECUTE';
  WS_EVEXECUTEANDWAIT: WideString = 'EXECUTEANDWAIT';
  WS_EVCLOSE: WideString = 'CLOSE';
  WS_EVSTARTSERVICE: WideString = 'START_SERVICE';
  WS_EVSTOPSERVICE: WideString = 'STOP_SERVICE';
  WS_EVRESTART: WideString = 'RESTART';
  WS_EVSHUTDOWN: WideString = 'SHUTDOWN';
  WS_EVSYNCHRONIZE: WideString = 'SYNCHRONIZE';

  // List view
  INT_INDEXDISABLED = 1;
  INT_INDEXENABLED = 0;
  INT_INDEXNOICON = -1;

  // backup types
  INT_BUFULL = 0;
  INT_BUINCREMENTAL = 1;
  INT_BUDIFFERENTIAL = 2;
  INT_BUDUMMY = 3;

  // compression
  INT_COMPNOCOMP = 0;
  INT_COMPZIP = 1;
  INT_COMP7ZIP = 2;

  //encryption
  INT_ENCNOENC = 0;
  INT_ENCRSA = 1;
  INT_ENCRIJNDAEL128 = 3;
  INT_ENCBLOWFISH128 = 2;
  INT_ENCDES64 = 4;

  // decryption
  INT_DECRSA = 0;
  INT_DECBLOWFISH = 1;
  INT_DECRIJNDAEL = 2;
  INT_DECDES = 3;
  INT_DECOLDBLOWFISH128 = 0;
  INT_DECOLDRIJNDAEL = 1;
  INT_DECOLDDES = 2;

  //Key size
  INT_128 = 0;
  INT_256= 1;
  INT_512 = 2;
  INT_768 = 3;
  INT_1024 = 4;

  //Split
  INT_SPLITNOSPLIT = 0;
  INT_SPLIT360K = 1;
  INT_SPLIT720K = 2;
  INT_SPLIT12M = 3;
  INT_SPLIT14M = 4;
  INT_SPLIT100M = 5;
  INT_SPLIT250M = 6;
  INT_SPLIT650M = 7;
  INT_SPLIT700M = 8;
  INT_SPLIT1G = 9;
  INT_SPLIT47G = 10;
  INT_SPLITCUSTOM = 11;

  // Source/Dest types
  INT_SDFILE = 0;
  INT_SDDIR = 1;
  INT_SDFTP = 2;
  INT_SDMANUAL = 3;

  // Schedule types
  INT_SCONCE = 0;
  INT_SCDAILY = 1;
  INT_SCWEEKLY = 2;
  INT_SCMONTHLY = 3;
  INT_SCYEARLY = 4;
  INT_SCTIMER = 5;
  INT_SCMANUALLY = 6;

  // days
  INT_DMONDAY = 1;
  INT_DTUESDAY = 2;
  INT_DWEDNESDAY = 3;
  INT_DTHURSDAY = 4;
  INT_DFRIDAY = 5;
  INT_DSATURDAY = 6;
  INT_DSUNDAY = 7;
  INT_DNODAY = -1;

  //Params
  WS_NOGUI: WideString = '/NOGUI';
  WS_NOGUIALT: WideString = '-NOGUI';
  WS_AUTOCLOSE: WideString = '/AUTOCLOSE';
  WS_AUTOCLOSEALT: WideString = '-AUTOCLOSE';
  WS_BU: WideString = '/BU';
  WS_BUALT: WideString = '-BU';
  WS_MAX: WideString = '/M';
  WS_MAXALT: WideString = '-M';
  WS_LISTPARAM: WideString = '/LIST:';
  WS_LISTPARAMALT: WideString = '-LIST:';
  WS_SERVICE: WideString = '-SERVICE';
  WS_SERVICEALT: WideString = '/SERVICE';

  // Commands
  WS_CMDRELOADINI: WideString = 'CMD_RELOADINI';
  WS_CMDRELOADLIST: WideString = 'CMD_RELOADLIST';
  WS_CMDDELETELOG: WideString = 'CMD_DELETELOG';
  WS_CMDBACKUPALL: WideString = 'CMD_BACKUPALL';
  WS_CMDBACKUPSELECTED: WideString = 'CMD_BACKUPSELECTED';
  WS_CMDLUNONEWVERSION: WideString = 'CMD_LUNONEWVERSION';
  WS_CMDLUNEWVERSIONWARNING: WideString = 'CMD_LUNEWVERSIONWARNING';
  WS_CMDLUERROR: WideString = 'CMD_LUERROR';
  WS_CMDABORT: WideString = 'CMD_ABORT';
  WS_CMDCOPYLOG: WideString = 'CMD_COPYLOG';
  WS_CMDUIRESPONSE: WideString = 'CMD_UIRESPONSE';

  //OS
  INT_HALTOK = 0;
  INT_NOTNT = 100;
  INT_NOREG = 200;
  INT_NOCREATION = 300;
  INT_MUTEXERROR = 400;
  INT_NOENGINE = 500;
  INT_MAXFILESIZE = 20000;
  INT_DEFHEIGHT = 600;
  INT_DEFWIDTH = 800;
  INT_DEFSWIDTH = 600;
  INT_DEFSHEIGHT = 400;

  WS_HOTKEYATOM: WideString = '%s Hot Key Atom';
  WS_SERVERCLASSNAME: WideString = '%s Class Name';
  WS_DECRYPTORCLASSNAME: WideString = '%s Decryptor Class Name';
  WS_CLASSFAILED: WideString = 'Class registration for %s failed';
  WS_WINDOWSHOWFAILED: WideString = 'Application window creation failed';
  WS_APPMUTEXNAME: WideString = 'Global\%s Application Mutex Name';
  WS_UIMUTEXFLAG: WideString = 'Global\%s UI Flag Mutex Name';
  WS_UIMUTEXFLAGOLD: WideString = '%s UI Flag Mutex Name';
  WS_APPMUTEXNAMEOLD: WideString = '%s Application Mutex Name';
  WS_HARDCODDED: WideString = '%s is already running. Check the system tray';
  WS_INIMUTEXNAME: WideString = 'Global\%s Ini Mutex Name';
  WS_INIMUTEXNAMEOLD: WideString = '%s Ini Mutex Name';
  WS_LISTMUTEXNAME: WideString =  'Global\%s List Mutex Name';
  WS_LISTMUTEXNAMEOLD: WideString =  '%s List Mutex Name';
  WS_TRANSLATORMUTEXNAME: WideString = 'Global\%s Translator Mutex Name';
  WS_TRANSLATORMUTEXNAMEOLD: WideString = '%s Translator Mutex Name';
  WS_INIEXT: WideString = '.ini';
  WS_MMFLOG: WideString = 'Global\%s MMF Log';
  WS_MMFLOGOLD: WideString = '%s MMF Log';
  WS_MMFLOGMUTEX: WideString = 'Global\%s MMF Log Mutex';
  WS_MMFLOGMUTEXOLD: WideString = '%s MMF Log Mutex';
  WS_OSBUILD: WideString = '%d.%d.%d';
  WS_MMFCURRENTOPNAME: WideString = 'Global\%s MMF Current Operation';
  WS_MMFCURRENTOPNAMEOLD: WideString = '%s MMF Current Operation';
  WS_MMFMUTEXCURRENTOPNAME: WideString = 'Global\%s MMF Mutex Current Operation';
  WS_MMFMUTEXCURRENTOPNAMEOLD: WideString = '%s MMF Mutex Current Operation';
  WS_MMFSLAVE: WideString = 'Global\%s MMF Slave';
  WS_MMFSLAVEOLD: WideString = '%s MMF Slave';
  WS_MMFMUTEXSLAVE: WideString = 'Global\%s MMF Mutex Slave';
  WS_MMFMUTEXSLAVEOLD: WideString = '%s MMF Mutex Slave';
  WS_UIINIMUTEXNAME: WideString = 'Global\%s UIINI MutexName';
  WS_UIINIMUTEXNAMEOLD: WideString = '%s UIINI MutexName';
  WS_DEFAULTUSERNAME: WideString ='DefaultUser';
  WS_LASTUSERSETTINGS: WideString = '%s Last Used.ini';
  WS_UISETTINGSINIFILENAME: WideString = '%s Settings.ini';
  WS_UIPOSITIONSINIFILENAME: WideString = '%s Positions.ini';
  WS_DECRYPTORINI: WideString = '%s Decryptor.ini';
  WS_COULDNTLOADDECRYPTORDLL: WideString = 'Couldn''t load the decryption dll';
  INT_MMFSLAVESLEEP = 1000;
  INT_MMFLOGREADERSLEEP = 1000;
  INT_SCHEDULERSLEEP = 300;
  INT_EXECUTORSLEEP = 500;
  INT_INFOREADERSLEEP = 1000;
  WS_DEFFONTNAME: WideString = 'Tahoma';
  WS_DEFFONTNAMELOGO: WideString = 'Courier New';
  INT_DEFAULTFONTSIZE = 8;
  INT_DEFAULTCHARSET = 1;
  WS_UIMUTEX: WideString = '%s User Interface Mutex';   // Not Global!!!!!
  WS_UIAUTOSTARTVALUE: WideString = '%s interface';
  WS_EXEEXT: WideString = '.exe';
  WS_DLLEXT: WideString = '.dll';

  // Directories
  WS_DIRSETTINGS: WideString = 'Settings';
  WS_DIRDB: WideString = 'DB';
  WS_DIRHELP: WideString = 'Help';
  WS_DIRLANG: WideString = 'Languages';
  WS_FLAGWARN: WideString = 'warningflagdis';
  WS_DIRDISTRO: WideString = 'Distro';
  WS_DIREXTRAS: WideString = 'Extras';
  WS_DIRSETUP: WideString = 'Setup';
  WS_DIRTUTORIAL: WideString = 'Tutorial';

implementation

end.
