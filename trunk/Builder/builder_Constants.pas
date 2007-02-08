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

// Constants used by the builder

unit builder_Constants;

interface

const
  BS_CAPTION: WideString = '%s setup builder';
  WS_PROCEEDNOW: WideString = 'Are you satisfied with the bmCustomize file? Proceed with the build?';
  BS_BEGINBUILDING: WideString = 'Beginning the build';
  BS_DELETINGDIR: WideString = 'Deleting the output directory "%s"';
  BS_ERRORDELETINGFOLDER = 'Couldn''t delete the ouput directory "%s": %s';
  BS_OUTPUTDIRDELETED: WideString = 'The output directry "%s" has been deleted';
  BS_OUTPUTDIRCREATED: WideString = 'The output directory "%s" was succesfully created';
  BS_OUTPUTDIRCREATEDFAILED: WideString = 'Couldn''t create the output directory "%s"';
  BS_PREPARINGTOCOPY: WideString = 'Preparing to copy the files';
  BS_COPYING: WideString = 'Copying "%s" to "%s"';
  BS_COPIED: WideString = 'The file "%s" was succesfully copied to "%s"';
  BS_COPYFAILED: WideString = 'Couldn''t copy the file "%s" to "%s": %s';
  BS_PROCESSING: WideString = 'Processing "%s" to "%s"';
  BS_PROCESSED: WideString = 'The file "%s" was succesfully processed to "%s"';
  BS_PROCESSINGDIR: WideString = 'Processing the directory "%s" to "%s"';
  BS_CREATINGDIR: WideString = 'Creating the directory "%s"';
  BS_DIRCREATED: WideString = 'The directory "%s" has been created';
  BS_ZIPPING: WideString = 'Creating the zip file "%s"';
  BS_ZIPPED: WideString = 'Zip file "%s" created. %d files compressed';
  BS_ERRORZIP: WideString = 'Error while zipping "%s": %s';
  BS_COMPRESSING: WideString = 'Compressing "%s"';
  BS_COMPRESSED: WideString = 'File compressed: "%s"';
  BS_ERRORCOMPRESSING: WideString = 'Couldn''t compress "%s"';
  BS_DELETEDRC: WideString = 'The file "%s" was succesfully deleted';
  BS_DELETEDRCFAILED: WideString = 'Couldn''t delete "%s"';
  BS_RCCREATED: WideString = 'The RC file "%s" has been created';
  BS_RESOURCECOMPILER: WideString = 'brcc32.exe';
  BS_RESOURCECREATED: WideString = 'The resource file "%s" has been created';
  BS_RESOURCECREATEDFILED : WideString = 'Couldn''t create the resource file "%s": %s';
  BS_RESOURCECOPIED: WideString = 'The resource file has been copied from "%s" to "%s"';
  BS_RESOURCECOPIEDFAILED: WideString = 'Couldn''t copy the resource file from "%s" to "%s"';
  BS_RESOURCENOTFOUND: WideString = 'The resource "%s" was not found';
  BS_DELETED: WideString = 'The file "%s" was succesfuly deleted';
  BS_ATTENTION: WideString = '*************************************************';
  BS_RESULTS: WideString = 'Errors: %d    Copied files: %d    Zipped files: %d';
  BS_WELLDONE: WideString = 'Well done. Please rebuild the setup now !!!!!!!';
  BS_VERSIUONFILECREATED: WideString = 'The version file "%s" has been created';
  BS_THEREAREERRORS: WideString = 'There are errors';

implementation

end.
