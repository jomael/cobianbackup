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

// Constans used by the Translator

unit translator_Constants;

interface

const
  TS_CAPTION: WideString = '%s - Translator';

  TS_INILEFT: WideString = 'Left';
  TS_INITOP: WideString = 'Top';
  TS_INIWIDTH: WideString = 'Width';
  TS_INIHEIGHT: WideString = 'Height';
  TS_INICOLUMN0: WideString = 'Column 0 width';
  TS_INICOLUMN1: WideString = 'Column 1 width';
  TS_INICOLUMNI1: WideString = 'Index column 1 width';
  TS_INICOLUMN2: WideString = 'Column 2 width';
  TS_INICOLUMN3: WideString = 'Column 3 width';
  TS_INICOLUMNI2: WideString = 'Index column 2 width';
  TS_INIFONTNAME: WideString = 'Font name';
  TS_INIFONTSIZE: WideString = 'Font size';
  TS_INIFONTCHARSET: WideString = 'Font charset';

  TS_INT800 = 800;
  TS_INT600 = 600;
  TS_INT10 = 10;
  TS_INTINDEX = 80;
  TS_INTMARGIN = 10;
  INT_DEFFONT = 8;

  TS_NOLANGUAGE: WideString = 'No language loaded';
  TS_ENGLISH: WideString = 'English';
  TS_INDEX: WideString = 'Index';

  TS_LANGUAGEDIRNOTFOUND: WideString = 'The language directory doesn''t exist. Exiting...';
  TS_ENGLISHNOTFOUND: WideString = 'English files not found. Exiting...';
  TS_ALLCUI: WideString = '*.cui';
  TS_ALLCMS: WideString = '*.cms';
  TS_ENGLISTCUI: WideString = 'english.cui';

  TS_NOTSELECTED: WideString = 'You need to select an existing language or create a new one';
  TS_LANGUAGEEXISTS: WideString = 'The language "%s" already exists. Do you want to overwrite it?';
  TS_CANNOTCREATEFILE: WideString = 'Cannot create the file "%s"';
  TS_EDIT: WideString = 'Press ENTER or F2 to edit';
  TS_BADPARAMS: WideString = 'Incorrect number of parameters. The number of parameters in the original and the translation must be the same';
  TS_SEARCHEMPTY: WideString = 'The search phrase cannot be empty';
  TS_TEXTNOFOUND: WideString = 'The string "%s" was not found in the active file';
  TS_NOERRORS: WideString = 'No errors found. The order of the parameters has NOT been checked';

  TS_ABOUT: WideString = 'About the translator';
  TS_COPYRIGHT: WideString = '© 2000-2006 by %s';
  TS_ALLRIGHTS: WideString = 'All rights reserved';

  TS_PARAM: WideChar = '%';
  TS_STRING: WideChar = 's';
  TS_INTEGER: WideChar = 'd';


implementation

end.
