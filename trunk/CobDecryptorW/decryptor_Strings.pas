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

// If the dll is not using the translator, the strings will be then hardcoded here

unit decryptor_Strings;

interface

const
  WSD_CAPTION: WideString = 'Decryptor and Keys - %s';
  WSD_DECRYPT: WideString = 'Decrypt';
  WSD_KEYS: WideString = 'Generate keys';
  WSD_LOG: WideString = 'Log';
  WSD_GENERATEPAIR: WideString = 'Generate a RSA key pair';
  WSD_PASSPHRASE: WideString = 'Passphrase for the private key';
  WSD_QUALITY: WideString =  'Passphrase quality';
  WSD_RETYPE: WideString = 'Retype the passphrase';
  WSD_MINUTES: WideString = 'Generating. Please wait... (%d sec)';
  WSD_GENERATE: WideString = '&Generate';
  WSD_DONOTENCRYPT: WideString = 'Do not encrypt the private key';
  WSD_DONOTENCRYPTHINT: WideString = 'If checked the private key will be open and insecure';
  WSD_FOLDERTOSAVE: WideString = 'Save your keys as ...';
  WSD_ENTERPASSPHRASE: WideString = 'You must enter a passphrase';
  WSD_DONTMATCH: WideString = 'The passphrases don''t match';
  WSD_PUBLICKEYS: WideString = 'Public keys';
  WSD_ALLFILES: WideString = 'All files';
  WSD_SOURCE: WideString = 'File or directory to decrypt';
  WSD_SOURCEBUTTON: WideString = '&Source';
  WSD_DESTINATIONFOLDER: WideString = 'Destination folder';
  WSD_BROWSE: WideString = '&Browse';
  WSD_FILE: WideString = '&File';
  WSD_DIRECTORY: WideString = '&Directory';
  WSD_ENCRYPTED: WideString = 'Encrypted files';
  WSD_ALLFILES_: WideString = 'All files';
  WSD_SELECTDESTINATION: WideString = 'Select the destination directory';
  WSD_SELECTSOURCE: WideString= 'Select the source directory';
  WSD_SELECTFILE: WideString = 'Select the source file';
  WSD_METHOD: WideString = 'New methods';
  WSD_METHODOLD: WideString = 'Obsolete methods';
  WSD_RSAMETHOD: WideString = 'RSA - Rijndael (1024- 256 bits)';
  WSD_RIJNDAELMETHOD: WideString = 'Rijndael (128 bits)';
  WSD_BLOWFISHMETHOD: WideString = 'Blowfish (128 bits)';
  WSD_DESMETHOD: WideString = 'DES (64 bits)';
  WSD_PRIVATE: WideString = 'Private key';
  WSD_DELECTKEY: WideString = 'Select a private key';
  WSD_PRIVATEKEYS: WideString = 'Private keys';
  WSD_UNENCRYPTEDKEY: WideString = 'Unencrypted key';
  WSD_DECRYPTNOW: WideString = '&Decrypt!';
  WSD_PASSPHRASEGENERAL: WideString = 'Passphrase';
  WSD_EARLIER: WideString = 'Decrypt files encrypted with %s, version 7.5 or earlier';
  WSD_NEWER: WideString = 'Decrypt files encrypted with a version of %s newer than 7.6';
  WSD_WELCOME: WideString = 'Welcome to %s decrypting tool';
  WSD_PLEASEWAIT: WideString = 'Generating a RSA key pair (1024-bits). This operation can take some time. Please be patient...';
  WSD_KEYSGENERATED: WideString = 'The RSA key pair (1024-bits) has been generated';
  WSD_SOURCENOTEXIST: WideString = 'The source file or directory to decrypt doesn''t exist';
  WSD_DESTINATIONNOTEXIST: WideString = 'Couldn''t create the destination directory to store the decrypted files';
  WSD_DESTSOURCE: WideString = 'The destination directory cannot be placed inside the source';
  WSD_PRIVATEKEYNOTEXIST: WideString = 'The private key doesn''t exist';
  WSD_CANCEL: WideString = '&Cancel';
  WSD_COUNTING: WideString = 'Counting files';
  WSD_CREATEDDIR: WideString = 'The directory "%s" has been created';
  WSD_CREATEDDIRFAILED: WideString = 'The directory "%s" could not be created';
  WSD_DECRYPTEDOK: WideString ='"%s" has been succesfully decrypted';
  WSD_DECRYPTEDFAILED: WideString = 'Couldn''t decrypt the file "%s"';
  WSD_PRIVATEDNOTFOUND: WideString = 'Couldn''t find the private key "%s"';
  WSD_ERRORLOADINGKEY: WideString = 'Error while loading the private key: wrong passphrase or corrupted key';
  WSD_DECRYPTINGKEY: WideString = 'Decrypting the private key';
  WSD_SELECTALL: WideString = '&Select all';
  WSD_COPY: WideString = '&Copy';
  WSD_WORDWRAP: WideString = '&Wordwrap';
  WSD_EXCEPTION: WideString = 'Error while decrypting "%s": %s';
  WSD_DECRYPTING: WideString = 'Decrypting "%s"';
  WSD_KEYSIZE: WideString = 'High values are safer but much much slower';
  WSD_WRONGPASSPHRASEMETHOD: WideString = 'Wrong passphrase or method';
  WSD_EXPLAIN: WideString = 'Generate a RSA key pair (1024 bits)';
  WSD_SUMMARY: WideString = '%d file(s) decrypted. %d error(s) found';
  WSD_ABOUT: WideString = 'About';
  WSD_DECRYPTOR: WideString = 'Decryptor tool';
  WSD_COPYRIGHT: WideString = '© 2000-2006, %s';
  WSD_ALLRIGHTS: WideString = 'All rights reserved';

implementation

end.
