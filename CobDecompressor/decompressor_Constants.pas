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

// constants for the decompressor. If the program is not using the
// translator, it will use the hardcoded strings from here

unit decompressor_Constants;

interface

const
  DS_CAPTION: WideString = '%s decompressor';
  DS_FILES: WideString = 'Archive';
  DS_LOG: WideString = 'Operation';
  DS_PROPERTY: WideString = 'Property';
  DS_VALUE: WideString = 'Value';
  DS_OPENARCHIVE: WideString = 'Open an archive';
  DS_EXTRACTALL: WideString = 'Extract all files';
  DS_TEST: WideString = 'Test the open archive';
  DS_ABORT: WideString = 'Abort the current operation';
  DS_ABOUT: WideString = 'About %s - Decompressor';
  DS_ERRORSONLY: WideString = 'Log errors only';
  DS_ERRORSONLYHINT: WideString = 'Log only the operations that contain errors';
  DS_ARCHIVENAME: WideString = 'Archive name';
  DS_ARCHIVETYPE: WideString = 'Archive type';
  DS_ZIP: WideString = 'Zip';
  DS_SQX: WideString = 'Sqx';
  DS_CREATIONDATE: WideString = 'Creation date';
  DS_LASTMODIFIED: WideString = 'Last modified';
  DS_NUMBEROFFILES: WideString = 'Number of files';
  DS_TOTALCOMPRESSED: WideString = 'Total compressed size';
  DS_UNKNOWN: WideString = 'Unknown';
  DS_TOTALUNCOMPRESSED: WideString = 'Total uncompressed size';
  DS_RECOVERYDATAPRESENT: WideString = 'Recovery data present';
  DS_NOTAVAILBALE: WideString = 'Feature not available';
  DS_YES: WideString = 'Yes';
  DS_NO: WideString = 'No';
  DS_SOLIDARCHIVE: WideString = 'Solid archive';
  DS_OPENARCHIVETITLE: WideString = 'Open an archive';
  DS_FILTER: WideString = '%s (*.zip,*.sqx)|*.zip;*.sqx|%s (*.*)|*.*';
  DS_ARCHIVES: WideString = 'Archives';
  DS_ALLFILES: WideString = 'All files';
  DS_OPENSQXFAILED: WideString = 'Couldn''t open the SQX file';
  DS_LISTSQXFAILED: WideString = 'Couldn''t list the files in the archive';
  DS_ARCHIVEOPEN: WideString = 'The archive "%s" is now open';
  DS_SELECTDIR: WideString = 'Select the output directory';
  DS_EXTRACTEDFILES: WideString = 'Extracted files: %d';
  DS_ERRORS: WideString = 'Errors: %d';
  DS_OVERWRITE: WideString = 'The file "%s" already exists. Overwrite it?';
  DS_BYES: WideString = '&Yes';
  DS_BNO: WideString = '&No';
  DS_BYESTOALL: WideString = 'Yes to &all';
  DS_BNOTOALL: WideString = 'No &to all';
  DS_BCANCEL: WideString = '&Cancel';
  DS_TESTING: WideString = 'Testing "%s"';
  DS_UNZIPPING: WideString = 'Extracting "%s"';
  DS_BADPASSWORD: WideString = 'Cannot extract or test "%s": wrong password';
  DS_ENTERPASSWORD: WideString = 'Enter the password for the file:';
  DS_OK: WideString = '&OK';
  DS_CANCEL: WideString = '&Cancel';
  DS_ERROREXTRACTING: WideString = 'Error while extracting/testing "%s": %s';
  DS_SELECTPART: WideString = 'Please, select the part "%s"';
  DS_ABORTOP: WideString = 'Abort the current operation?';
  DS_TESTEDFILES: WideString = 'Tested files: %d';
  DS_SQXERROR: WideString = 'SQX error while extracting the files from the archive';
  DS_SQXCORRUPTED: WideString = 'SQX error while testing the files in the archive';
  DS_ERRORSQX: WideString = 'Cannot extract or test the file "%s"';
  DS_INT600 = 600;
  DS_INT400 = 400;
  DS_INT10 = 10;
  DS_INILEFT: WideString = 'Left';
  DS_INIWIDTH: WideString = 'Width';
  DS_INIHEIGHT: WideString = 'Height';
  DS_INITOP: WideString = 'Top';
  DS_INICOLUMN0: WideString = 'Column 0 width';
  DS_INICOLUMN1: WideString = 'Column 1 width';
  DS_INIDEFAULTDIRECTORY: WideString = 'Default directory';
  DS_COPYRIGHT: WideString = '© 2000-2006, %s';
  DS_DECOMPRESSION: WideString = 'Decompression tool';
  DS_ALLRIGHTS: WideString = 'All rights reserved';
  DS_ABOUTDEC: WideString = 'About the decompressor';


implementation

end.
