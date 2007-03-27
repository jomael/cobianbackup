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

// Constants used by the installer

unit setup_Constants;

interface

const
  SS_BADSERIAL: WideString = 'Bad serial number';
  SS_DISTROTEMP: WideString  = 'Distro';
  SS_DISTROTEMPEX: WideString = 'Distro (%d)';
  SS_CANNOTCREATEDIR: WideString = 'Cannot create the temporary directory. Terminating';
  SS_CANNOTEXTRACTRESOURSE: WideString = 'Cannot extract the distribution resource';
  SS_RESOURCENAME: WideString = 'DISTRO';
  SS_DISTROZIP: WideString = 'DISTRO.ZIP';
  SS_CANNOTEXTRACTFILES: WideString = 'Cannot extract the files. Exiting';
  SS_EXTRACTINGRESOURCE: WideString = 'Extracting the resource';
  SS_EXTRACTING: WideString = 'Extracting "%s"';
  SS_REGSTDDIR: WideString = 'Directory';
  SS_REGCURRENTVERSION: WideString = '\SOFTWARE\Microsoft\Windows\CurrentVersion';
  SS_REGPROGRAMFILESDIR: WideString = 'ProgramFilesDir';
  SS_ROOTC: WideString = 'C:\';
  SS_REGUNINSTALLDISPLAYNAME: WideString = 'DisplayName';
  SS_REGUNINSTALLSTR: WideString = 'UninstallString';
  SS_REGUNINSTALLICON: WideString = 'DisplayIcon';
  //Hardcodded
  SS_NEEDNT: AnsiString = 'This version runs on NT based systems only. Use version 7 or earlier on Windows 9x.'#10#13'Go to the program''s site to download a compatible version?';
  SS_CANNOTCONTINUE: AnsiString = 'Fatal error';

implementation

end.
