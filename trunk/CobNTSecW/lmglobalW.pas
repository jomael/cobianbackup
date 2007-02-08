//------------------------------------------------------------------------
// lmglobal units
//
// Lan Manager types and constants.
//
// Translated to Delphi by Colin Wilson.  Translation copyright (c) Colin
// Wilson 2002.  All rights reserved.
// Adapted to unicode by Luis Cobian

unit lmglobalW;

{$WEAKPACKAGEUNIT}

interface

const
  CNLEN       = 15;                  // Computer name length
  LM20_CNLEN  = 15;                  // LM 2.0 Computer name length
  DNLEN       = CNLEN;               // Maximum domain name length
  LM20_DNLEN  = LM20_CNLEN;          // LM 2.0 Maximum domain name length


  UNCLEN      = (CNLEN+2);           // UNC computer name length
  LM20_UNCLEN = (LM20_CNLEN+2);      // LM 2.0 UNC computer name length

  NNLEN       = 80;                  // Net name length (share name)
  LM20_NNLEN  = 12;                  // LM 2.0 Net name length

  RMLEN       = (UNCLEN+1+NNLEN);    // Max remote name length
  LM20_RMLEN  = (LM20_UNCLEN+1+LM20_NNLEN); // LM 2.0 Max remote name length

  SNLEN       = 80;                  // Service name length
  LM20_SNLEN  = 15;                  // LM 2.0 Service name length
  STXTLEN     = 256;                 // Service text length
  LM20_STXTLEN = 63;                 // LM 2.0 Service text length

  PATHLEN     = 256;                 // Max. path (not including drive name)
  LM20_PATHLEN = 256;                // LM 2.0 Max. path

  DEVLEN      = 80;                  // Device name length
  LM20_DEVLEN = 8;                   // LM 2.0 Device name length

  EVLEN       = 16;                  // Event name length

//
// User, Group and Password lengths
//

  UNLEN       = 256;                 // Maximum user name length
  LM20_UNLEN  = 20;                  // LM 2.0 Maximum user name length

  GNLEN       = UNLEN;               // Group name
  LM20_GNLEN  = LM20_UNLEN;          // LM 2.0 Group name

  PWLEN       = 256;                 // Maximum password length
  LM20_PWLEN  = 14;                  // LM 2.0 Maximum password length

  SHPWLEN     = 8;                   // Share password length (bytes)


  CLTYPE_LEN  = 12;                  // Length of client type string


  MAXCOMMENTSZ = 256;                // Multipurpose comment length
  LM20_MAXCOMMENTSZ = 48;            // LM 2.0 Multipurpose comment length

  QNLEN       = NNLEN;               // Queue name maximum length
  LM20_QNLEN  = LM20_NNLEN;          // LM 2.0 Queue name maximum length

//
// The ALERTSZ and MAXDEVENTRIES defines have not yet been NT'ized.
// Whoever ports these components should change these values appropriately.
//

  ALERTSZ     = 128;                 // size of alert string in server
  MAXDEVENTRIES = (sizeof (Integer)*8);
                                     // Max number of device entries

                                        //
                                        // We use int bitmap to represent
                                        //

  NETBIOS_NAME_LEN = 16;            // NetBIOS net name (bytes)

//
// Value to be used with APIs which have a "preferred maximum length"
// parameter.  This value indicates that the API should just allocate
// "as much as it takes."
//

  MAX_PREFERRED_LENGTH   = -1;

//
//        Constants used with encryption
//

  CRYPT_KEY_LEN           = 7;
  CRYPT_TXT_LEN           = 8;
  ENCRYPTED_PWLEN         = 16;
  SESSION_PWLEN           = 24;
  SESSION_CRYPT_KLEN      = 21;

//
//  Value to be used with SetInfo calls to allow setting of all
//  settable parameters (parmnum zero option)
//
  PARMNUM_ALL             = 0;
  PARM_ERROR_UNKNOWN      = -1;
  PARM_ERROR_NONE         = 0;
  PARMNUM_BASE_INFOLEVEL  = 1000;

//
//        Message File Names
//

  MESSAGE_FILENAME        = 'NETMSG';
  OS2MSG_FILENAME         = 'BASE';
  HELP_MSG_FILENAME       = 'NETH';

  BACKUP_MSG_FILENAME     = 'BAK.MSG';

type

  NetAPIStatus = Integer;
  APIRetType = NetAPIStatus;

//
// The platform ID indicates the levels to use for platform-specific
// information.
//

const
  PLATFORM_ID_DOS = 300;
  PLATFORM_ID_OS2 = 400;
  PLATFORM_ID_NT  = 500;
  PLATFORM_ID_OSF = 600;
  PLATFORM_ID_VMS = 700;

  NERR_Success           = 0;       // Success
  NERR_BASE       = 2100;

  NERR_NetNotStarted      = (NERR_BASE+2);   (* The workstation driver is not installed. *)
  NERR_UnknownServer      = (NERR_BASE+3);   (* The server could not be located. *)
  NERR_ShareMem           = (NERR_BASE+4);   (* An internal error occurred.  The network cannot access a shared memory segment. *)

  NERR_NoNetworkResource  = (NERR_BASE+5);   (* A network resource shortage occurred . *)
  NERR_RemoteOnly         = (NERR_BASE+6);   (* This operation is not supported on workstations. *)
  NERR_DevNotRedirected   = (NERR_BASE+7);   (* The device is not connected. *)
(* UNUSED BASE+8 *)
(* UNUSED BASE+9 *)
(* UNUSED BASE+10 *)
(* UNUSED BASE+11 *)
(* UNUSED BASE+12 *)
(* UNUSED BASE+13 *)
  NERR_ServerNotStarted   = (NERR_BASE+14);  (* The Server service is not started. *)
  NERR_ItemNotFound       = (NERR_BASE+15);  (* The queue is empty. *)
  NERR_UnknownDevDir      = (NERR_BASE+16);  (* The device or directory does not exist. *)
  NERR_RedirectedPath     = (NERR_BASE+17);  (* The operation is invalid on a redirected resource. *)
  NERR_DuplicateShare     = (NERR_BASE+18);  (* The name has already been shared. *)
  NERR_NoRoom             = (NERR_BASE+19);  (* The server is currently out of the requested resource. *)
(* UNUSED BASE+20 *)
  NERR_TooManyItems       = (NERR_BASE+21);  (* Requested addition of items exceeds the maximum allowed. *)
  NERR_InvalidMaxUsers    = (NERR_BASE+22);  (* The Peer service supports only two simultaneous users. *)
  NERR_BufTooSmall        = (NERR_BASE+23);  (* The API return buffer is too small. *)
(* UNUSED BASE+24 *)
(* UNUSED BASE+25 *)
(* UNUSED BASE+26 *)
  NERR_RemoteErr          = (NERR_BASE+27);  (* A remote API error occurred.  *)
(* UNUSED BASE+28 *)
(* UNUSED BASE+29 *)
(* UNUSED BASE+30 *)
  NERR_LanmanIniError     = (NERR_BASE+31);  (* An error occurred when opening or reading the configuration file. *)
(* UNUSED BASE+32 *)
(* UNUSED BASE+33 *)
(* UNUSED BASE+34 *)
(* UNUSED BASE+35 *)
  NERR_NetworkError       = (NERR_BASE+36);  (* A general network error occurred. *)
  NERR_WkstaInconsistentState = (NERR_BASE+37);
    (* The Workstation service is in an inconsistent state. Restart the computer before restarting the Workstation service. *)
  NERR_WkstaNotStarted    = (NERR_BASE+38);  (* The Workstation service has not been started. *)
  NERR_BrowserNotStarted  = (NERR_BASE+39);  (* The requested information is not available. *)
  NERR_InternalError      = (NERR_BASE+40);  (* An internal Windows NT error occurred.*)
  NERR_BadTransactConfig  = (NERR_BASE+41);  (* The server is not configured for transactions. *)
  NERR_InvalidAPI         = (NERR_BASE+42);  (* The requested API is not supported on the remote server. *)
  NERR_BadEventName       = (NERR_BASE+43);  (* The event name is invalid. *)
  NERR_DupNameReboot      = (NERR_BASE+44);  (* The computer name already exists on the network. Change it and restart the computer. *)
(*
 *      Config API related
 *              Error codes from BASE+45 to BASE+49
 *)

(* UNUSED BASE+45 *)
  NERR_CfgCompNotFound    = (NERR_BASE+46);  (* The specified component could not be found in the configuration information. *)
  NERR_CfgParamNotFound   = (NERR_BASE+47);  (* The specified parameter could not be found in the configuration information. *)
  NERR_LineTooLong        = (NERR_BASE+49);  (* A line in the configuration file is too long. *)

(*
 *      Spooler API related
 *              Error codes from BASE+50 to BASE+79
 *)

  NERR_QNotFound          = (NERR_BASE+50);  (* The printer does not exist. *)
  NERR_JobNotFound        = (NERR_BASE+51);  (* The print job does not exist. *)
  NERR_DestNotFound       = (NERR_BASE+52);  (* The printer destination cannot be found. *)
  NERR_DestExists         = (NERR_BASE+53);  (* The printer destination already exists. *)
  NERR_QExists            = (NERR_BASE+54);  (* The printer queue already exists. *)
  NERR_QNoRoom            = (NERR_BASE+55);  (* No more printers can be added. *)
  NERR_JobNoRoom          = (NERR_BASE+56);  (* No more print jobs can be added.  *)
  NERR_DestNoRoom         = (NERR_BASE+57);  (* No more printer destinations can be added. *)
  NERR_DestIdle           = (NERR_BASE+58);  (* This printer destination is idle and cannot accept control operations. *)
  NERR_DestInvalidOp      = (NERR_BASE+59);  (* This printer destination request contains an invalid control function. *)
  NERR_ProcNoRespond      = (NERR_BASE+60);  (* The print processor is not responding. *)
  NERR_SpoolerNotLoaded   = (NERR_BASE+61);  (* The spooler is not running. *)
  NERR_DestInvalidState   = (NERR_BASE+62);  (* This operation cannot be performed on the print destination in its current state. *)
  NERR_QInvalidState      = (NERR_BASE+63);  (* This operation cannot be performed on the printer queue in its current state. *)
  NERR_JobInvalidState    = (NERR_BASE+64);  (* This operation cannot be performed on the print job in its current state. *)
  NERR_SpoolNoMemory      = (NERR_BASE+65);  (* A spooler memory allocation failure occurred. *)
  NERR_DriverNotFound     = (NERR_BASE+66);  (* The device driver does not exist. *)
  NERR_DataTypeInvalid    = (NERR_BASE+67);  (* The data type is not supported by the print processor. *)
  NERR_ProcNotFound       = (NERR_BASE+68);  (* The print processor is not installed. *)

(*
 *      Service API related
 *              Error codes from BASE+80 to BASE+99
 *)

  NERR_ServiceTableLocked = (NERR_BASE+80);  (* The service database is locked. *)
  NERR_ServiceTableFull   = (NERR_BASE+81);  (* The service table is full. *)
  NERR_ServiceInstalled   = (NERR_BASE+82);  (* The requested service has already been started. *)
  NERR_ServiceEntryLocked = (NERR_BASE+83);  (* The service does not respond to control actions. *)
  NERR_ServiceNotInstalled = (NERR_BASE+84); (* The service has not been started. *)
  NERR_BadServiceName     = (NERR_BASE+85);  (* The service name is invalid. *)
  NERR_ServiceCtlTimeout  = (NERR_BASE+86);  (* The service is not responding to the control function. *)
  NERR_ServiceCtlBusy     = (NERR_BASE+87);  (* The service control is busy. *)
  NERR_BadServiceProgName = (NERR_BASE+88);  (* The configuration file contains an invalid service program name. *)
  NERR_ServiceNotCtrl     = (NERR_BASE+89);  (* The service could not be controlled in its present state. *)
  NERR_ServiceKillProc    = (NERR_BASE+90);  (* The service ended abnormally. *)
  NERR_ServiceCtlNotValid = (NERR_BASE+91);  (* The requested pause or stop is not valid for this service. *)
  NERR_NotInDispatchTbl   = (NERR_BASE+92);  (* The service control dispatcher could not find the service name in the dispatch table. *)
  NERR_BadControlRecv     = (NERR_BASE+93);  (* The service control dispatcher pipe read failed. *)
  NERR_ServiceNotStarting = (NERR_BASE+94);  (* A thread for the new service could not be created. *)

(*
 *      Wksta and Logon API related
 *              Error codes from BASE+100 to BASE+118
 *)

  NERR_AlreadyLoggedOn    = (NERR_BASE+100); (* This workstation is already logged on to the local-area network. *)
  NERR_NotLoggedOn        = (NERR_BASE+101); (* The workstation is not logged on to the local-area network. *)
  NERR_BadUsername        = (NERR_BASE+102); (* The user name or group name parameter is invalid.  *)
  NERR_BadPassword        = (NERR_BASE+103); (* The password parameter is invalid. *)
  NERR_UnableToAddName_W  = (NERR_BASE+104); (* @W The logon processor did not add the message alias. *)
  NERR_UnableToAddName_F  = (NERR_BASE+105); (* The logon processor did not add the message alias. *)
  NERR_UnableToDelName_W  = (NERR_BASE+106); (* @W The logoff processor did not delete the message alias. *)
  NERR_UnableToDelName_F  = (NERR_BASE+107); (* The logoff processor did not delete the message alias. *)
(* UNUSED BASE+108 *)
  NERR_LogonsPaused       = (NERR_BASE+109); (* Network logons are paused. *)
  NERR_LogonServerConflict = (NERR_BASE+110);(* A centralized logon-server conflict occurred. *)
  NERR_LogonNoUserPath    = (NERR_BASE+111); (* The server is configured without a valid user path. *)
  NERR_LogonScriptError   = (NERR_BASE+112); (* An error occurred while loading or running the logon script. *)
(* UNUSED BASE+113 *)
  NERR_StandaloneLogon    = (NERR_BASE+114); (* The logon server was not specified.  Your computer will be logged on as STANDALONE. *)
  NERR_LogonServerNotFound = (NERR_BASE+115); (* The logon server could not be found.  *)
  NERR_LogonDomainExists  = (NERR_BASE+116); (* There is already a logon domain for this computer.  *)
  NERR_NonValidatedLogon  = (NERR_BASE+117); (* The logon server could not validate the logon. *)

(*
 *      ACF API related (access, user, group)
 *              Error codes from BASE+119 to BASE+149
 *)

  NERR_ACFNotFound        = (NERR_BASE+119); (* The security database could not be found. *)
  NERR_GroupNotFound      = (NERR_BASE+120); (* The group name could not be found. *)
  NERR_UserNotFound       = (NERR_BASE+121); (* The user name could not be found. *)
  NERR_ResourceNotFound   = (NERR_BASE+122); (* The resource name could not be found.  *)
  NERR_GroupExists        = (NERR_BASE+123); (* The group already exists. *)
  NERR_UserExists         = (NERR_BASE+124); (* The user account already exists. *)
  NERR_ResourceExists     = (NERR_BASE+125); (* The resource permission list already exists. *)
  NERR_NotPrimary         = (NERR_BASE+126); (* This operation is only allowed on the primary domain controller of the domain. *)
  NERR_ACFNotLoaded       = (NERR_BASE+127); (* The security database has not been started. *)
  NERR_ACFNoRoom          = (NERR_BASE+128); (* There are too many names in the user accounts database. *)
  NERR_ACFFileIOFail      = (NERR_BASE+129); (* A disk I/O failure occurred.*)
  NERR_ACFTooManyLists    = (NERR_BASE+130); (* The limit of 64 entries per resource was exceeded. *)
  NERR_UserLogon          = (NERR_BASE+131); (* Deleting a user with a session is not allowed. *)
  NERR_ACFNoParent        = (NERR_BASE+132); (* The parent directory could not be located. *)
  NERR_CanNotGrowSegment  = (NERR_BASE+133); (* Unable to add to the security database session cache segment. *)
  NERR_SpeGroupOp         = (NERR_BASE+134); (* This operation is not allowed on this special group. *)
  NERR_NotInCache         = (NERR_BASE+135); (* This user is not cached in user accounts database session cache. *)
  NERR_UserInGroup        = (NERR_BASE+136); (* The user already belongs to this group. *)
  NERR_UserNotInGroup     = (NERR_BASE+137); (* The user does not belong to this group. *)
  NERR_AccountUndefined   = (NERR_BASE+138); (* This user account is undefined. *)
  NERR_AccountExpired     = (NERR_BASE+139); (* This user account has expired. *)
  NERR_InvalidWorkstation = (NERR_BASE+140); (* The user is not allowed to log on from this workstation. *)
  NERR_InvalidLogonHours  = (NERR_BASE+141); (* The user is not allowed to log on at this time.  *)
  NERR_PasswordExpired    = (NERR_BASE+142); (* The password of this user has expired. *)
  NERR_PasswordCantChange = (NERR_BASE+143); (* The password of this user cannot change. *)
  NERR_PasswordHistConflict = (NERR_BASE+144); (* This password cannot be used now. *)
  NERR_PasswordTooShort   = (NERR_BASE+145); (* The password is shorter than required. *)
  NERR_PasswordTooRecent  = (NERR_BASE+146); (* The password of this user is too recent to change.  *)
  NERR_InvalidDatabase    = (NERR_BASE+147); (* The security database is corrupted. *)
  NERR_DatabaseUpToDate   = (NERR_BASE+148); (* No updates are necessary to this replicant network/local security database. *)
  NERR_SyncRequired       = (NERR_BASE+149); (* This replicant database is outdated; synchronization is required. *)

(*
 *      Use API related
 *              Error codes from BASE+150 to BASE+169
 *)

  NERR_UseNotFound        = (NERR_BASE+150); (* The network connection could not be found. *)
  NERR_BadAsgType         = (NERR_BASE+151); (* This asg_type is invalid. *)
  NERR_DeviceIsShared     = (NERR_BASE+152); (* This device is currently being shared. *)

(*
 *      Message Server related
 *              Error codes BASE+170 to BASE+209
 *)

  NERR_NoComputerName     = (NERR_BASE+170); (* The computer name could not be added as a message alias.  The name may already exist on the network. *)
  NERR_MsgAlreadyStarted  = (NERR_BASE+171); (* The Messenger service is already started. *)
  NERR_MsgInitFailed      = (NERR_BASE+172); (* The Messenger service failed to start.  *)
  NERR_NameNotFound       = (NERR_BASE+173); (* The message alias could not be found on the network. *)
  NERR_AlreadyForwarded   = (NERR_BASE+174); (* This message alias has already been forwarded. *)
  NERR_AddForwarded       = (NERR_BASE+175); (* This message alias has been added but is still forwarded. *)
  NERR_AlreadyExists      = (NERR_BASE+176); (* This message alias already exists locally. *)
  NERR_TooManyNames       = (NERR_BASE+177); (* The maximum number of added message aliases has been exceeded. *)
  NERR_DelComputerName    = (NERR_BASE+178); (* The computer name could not be deleted.*)
  NERR_LocalForward       = (NERR_BASE+179); (* Messages cannot be forwarded back to the same workstation. *)
  NERR_GrpMsgProcessor    = (NERR_BASE+180); (* An error occurred in the domain message processor. *)
  NERR_PausedRemote       = (NERR_BASE+181); (* The message was sent, but the recipient has paused the Messenger service. *)
  NERR_BadReceive         = (NERR_BASE+182); (* The message was sent but not received. *)
  NERR_NameInUse          = (NERR_BASE+183); (* The message alias is currently in use. Try again later. *)
  NERR_MsgNotStarted      = (NERR_BASE+184); (* The Messenger service has not been started. *)
  NERR_NotLocalName       = (NERR_BASE+185); (* The name is not on the local computer. *)
  NERR_NoForwardName      = (NERR_BASE+186); (* The forwarded message alias could not be found on the network. *)
  NERR_RemoteFull         = (NERR_BASE+187); (* The message alias table on the remote station is full. *)
  NERR_NameNotForwarded   = (NERR_BASE+188); (* Messages for this alias are not currently being forwarded. *)
  NERR_TruncatedBroadcast = (NERR_BASE+189); (* The broadcast message was truncated. *)
  NERR_InvalidDevice      = (NERR_BASE+194); (* This is an invalid device name. *)
  NERR_WriteFault         = (NERR_BASE+195); (* A write fault occurred. *)
(* UNUSED BASE+196 *)
  NERR_DuplicateName      = (NERR_BASE+197); (* A duplicate message alias exists on the network. *)
  NERR_DeleteLater        = (NERR_BASE+198); (* @W This message alias will be deleted later. *)
  NERR_IncompleteDel      = (NERR_BASE+199); (* The message alias was not successfully deleted from all networks. *)
  NERR_MultipleNets       = (NERR_BASE+200); (* This operation is not supported on computers with multiple networks. *)

(*
 *      Server API related
 *              Error codes BASE+210 to BASE+229
 *)

  NERR_NetNameNotFound    = (NERR_BASE+210); (* This shared resource does not exist.*)
  NERR_DeviceNotShared    = (NERR_BASE+211); (* This device is not shared. *)
  NERR_ClientNameNotFound = (NERR_BASE+212); (* A session does not exist with that computer name. *)
  NERR_FileIdNotFound     = (NERR_BASE+214); (* There is not an open file with that identification number. *)
  NERR_ExecFailure        = (NERR_BASE+215); (* A failure occurred when executing a remote administration command. *)
  NERR_TmpFile            = (NERR_BASE+216); (* A failure occurred when opening a remote temporary file. *)
  NERR_TooMuchData        = (NERR_BASE+217); (* The data returned from a remote administration command has been truncated to 64K. *)
  NERR_DeviceShareConflict = (NERR_BASE+218); (* This device cannot be shared as both a spooled and a non-spooled resource. *)
  NERR_BrowserTableIncomplete = (NERR_BASE+219);  (* The information in the list of servers may be incorrect. *)
  NERR_NotLocalDomain     = (NERR_BASE+220); (* The computer is not active in this domain. *)
  NERR_IsDfsShare         = (NERR_BASE+221); (* The share must be removed from the Distributed File System before it can be deleted. *)

(*
 *      CharDev API related
 *              Error codes BASE+230 to BASE+249
 *)

(* UNUSED BASE+230 *)
  NERR_DevInvalidOpCode   = (NERR_BASE+231); (* The operation is invalid for this device. *)
  NERR_DevNotFound        = (NERR_BASE+232); (* This device cannot be shared. *)
  NERR_DevNotOpen         = (NERR_BASE+233); (* This device was not open. *)
  NERR_BadQueueDevString  = (NERR_BASE+234); (* This device name list is invalid. *)
  NERR_BadQueuePriority   = (NERR_BASE+235); (* The queue priority is invalid. *)
  NERR_NoCommDevs         = (NERR_BASE+237); (* There are no shared communication devices. *)
  NERR_QueueNotFound      = (NERR_BASE+238); (* The queue you specified does not exist. *)
  NERR_BadDevString       = (NERR_BASE+240); (* This list of devices is invalid. *)
  NERR_BadDev             = (NERR_BASE+241); (* The requested device is invalid. *)
  NERR_InUseBySpooler     = (NERR_BASE+242); (* This device is already in use by the spooler. *)
  NERR_CommDevInUse       = (NERR_BASE+243); (* This device is already in use as a communication device. *)

(*
 *      NetICanonicalize and NetIType and NetIMakeLMFileName
 *      NetIListCanon and NetINameCheck
 *              Error codes BASE+250 to BASE+269
 *)

  NERR_InvalidComputer   = (NERR_BASE+251); (* This computer name is invalid. *)
(* UNUSED BASE+252 *)
(* UNUSED BASE+253 *)
  NERR_MaxLenExceeded    = (NERR_BASE+254); (* The string and prefix specified are too long. *)
(* UNUSED BASE+255 *)
  NERR_BadComponent      = (NERR_BASE+256); (* This path component is invalid. *)
  NERR_CantType          = (NERR_BASE+257); (* Could not determine the type of input. *)
(* UNUSED BASE+258 *)
(* UNUSED BASE+259 *)
  NERR_TooManyEntries    = (NERR_BASE+262); (* The buffer for types is not big enough. *)

(*
 *      NetProfile
 *              Error codes BASE+270 to BASE+276
 *)

  NERR_ProfileFileTooBig  = (NERR_BASE+270); (* Profile files cannot exceed 64K. *)
  NERR_ProfileOffset      = (NERR_BASE+271); (* The start offset is out of range. *)
  NERR_ProfileCleanup     = (NERR_BASE+272); (* The system cannot delete current connections to network resources. *)
  NERR_ProfileUnknownCmd  = (NERR_BASE+273); (* The system was unable to parse the command line in this file.*)
  NERR_ProfileLoadErr     = (NERR_BASE+274); (* An error occurred while loading the profile file. *)
  NERR_ProfileSaveErr     = (NERR_BASE+275); (* @W Errors occurred while saving the profile file.  The profile was partially saved. *)


(*
 *      NetAudit and NetErrorLog
 *              Error codes BASE+277 to BASE+279
 *)

  NERR_LogOverflow           = (NERR_BASE+277);      (* Log file %1 is full. *)
  NERR_LogFileChanged        = (NERR_BASE+278);      (* This log file has changed between reads. *)
  NERR_LogFileCorrupt        = (NERR_BASE+279);      (* Log file %1 is corrupt. *)


(*
 *      NetRemote
 *              Error codes BASE+280 to BASE+299
 *)
  NERR_SourceIsDir   = (NERR_BASE+280); (* The source path cannot be a directory. *)
  NERR_BadSource     = (NERR_BASE+281); (* The source path is illegal. *)
  NERR_BadDest       = (NERR_BASE+282); (* The destination path is illegal. *)
  NERR_DifferentServers   = (NERR_BASE+283); (* The source and destination paths are on different servers. *)
(* UNUSED BASE+284 *)
  NERR_RunSrvPaused       = (NERR_BASE+285); (* The Run server you requested is paused. *)
(* UNUSED BASE+286 *)
(* UNUSED BASE+287 *)
(* UNUSED BASE+288 *)
  NERR_ErrCommRunSrv      = (NERR_BASE+289); (* An error occurred when communicating with a Run server. *)
(* UNUSED BASE+290 *)
  NERR_ErrorExecingGhost  = (NERR_BASE+291); (* An error occurred when starting a background process. *)
  NERR_ShareNotFound      = (NERR_BASE+292); (* The shared resource you are connected to could not be found.*)
(* UNUSED BASE+293 *)
(* UNUSED BASE+294 *)


(*
 *  NetWksta.sys (redir) returned error codes.
 *
 *          NERR_BASE + (300-329)
 *)

  NERR_InvalidLana        = (NERR_BASE+300); (* The LAN adapter number is invalid.  *)
  NERR_OpenFiles          = (NERR_BASE+301); (* There are open files on the connection.    *)
  NERR_ActiveConns        = (NERR_BASE+302); (* Active connections still exist. *)
  NERR_BadPasswordCore    = (NERR_BASE+303); (* This share name or password is invalid. *)
  NERR_DevInUse           = (NERR_BASE+304); (* The device is being accessed by an active process. *)
  NERR_LocalDrive         = (NERR_BASE+305); (* The drive letter is in use locally. *)

(*
 *  Alert error codes.
 *
 *          NERR_BASE + (330-339)
 *)
  NERR_AlertExists        = (NERR_BASE+330); (* The specified client is already registered for the specified event. *)
  NERR_TooManyAlerts      = (NERR_BASE+331); (* The alert table is full. *)
  NERR_NoSuchAlert        = (NERR_BASE+332); (* An invalid or nonexistent alert name was raised. *)
  NERR_BadRecipient       = (NERR_BASE+333); (* The alert recipient is invalid.*)
  NERR_AcctLimitExceeded  = (NERR_BASE+334); (* A user's session with this server has been deleted
                                                 * because the user's logon hours are no longer valid. *)

(*
 *  Additional Error and Audit log codes.
 *
 *          NERR_BASE +(340-343)
 *)
  NERR_InvalidLogSeek     = (NERR_BASE+340); (* The log file does not contain the requested record number. *)
(* UNUSED BASE+341 *)
(* UNUSED BASE+342 *)
(* UNUSED BASE+343 *)

(*
 *  Additional UAS and NETLOGON codes
 *
 *          NERR_BASE +(350-359)
 *)
  NERR_BadUasConfig       = (NERR_BASE+350); (* The user accounts database is not configured correctly. *)
  NERR_InvalidUASOp       = (NERR_BASE+351); (* This operation is not permitted when the Netlogon service is running. *)
  NERR_LastAdmin          = (NERR_BASE+352); (* This operation is not allowed on the last administrative account. *)
  NERR_DCNotFound         = (NERR_BASE+353); (* Could not find domain controller for this domain. *)
  NERR_LogonTrackingError = (NERR_BASE+354); (* Could not set logon information for this user. *)
  NERR_NetlogonNotStarted = (NERR_BASE+355); (* The Netlogon service has not been started. *)
  NERR_CanNotGrowUASFile  = (NERR_BASE+356); (* Unable to add to the user accounts database. *)
  NERR_TimeDiffAtDC       = (NERR_BASE+357); (* This server's clock is not synchronized with the primary domain controller's clock. *)
  NERR_PasswordMismatch   = (NERR_BASE+358); (* A password mismatch has been detected. *)


(*
 *  Server Integration error codes.
 *
 *          NERR_BASE +(360-369)
 *)
  NERR_NoSuchServer       = (NERR_BASE+360); (* The server identification does not specify a valid server. *)
  NERR_NoSuchSession      = (NERR_BASE+361); (* The session identification does not specify a valid session. *)
  NERR_NoSuchConnection   = (NERR_BASE+362); (* The connection identification does not specify a valid connection. *)
  NERR_TooManyServers     = (NERR_BASE+363); (* There is no space for another entry in the table of available servers. *)
  NERR_TooManySessions    = (NERR_BASE+364); (* The server has reached the maximum number of sessions it supports. *)
  NERR_TooManyConnections = (NERR_BASE+365); (* The server has reached the maximum number of connections it supports. *)
  NERR_TooManyFiles       = (NERR_BASE+366); (* The server cannot open more files because it has reached its maximum number. *)
  NERR_NoAlternateServers = (NERR_BASE+367); (* There are no alternate servers registered on this server. *)
(* UNUSED BASE+368 *)
(* UNUSED BASE+369 *)

  NERR_TryDownLevel       = (NERR_BASE+370); (* Try down-level (remote admin protocol) version of API instead. *)

(*
 *  UPS error codes.
 *
 *          NERR_BASE + (380-384)
 *)
  NERR_UPSDriverNotStarted    = (NERR_BASE+380); (* The UPS driver could not be accessed by the UPS service. *)
  NERR_UPSInvalidConfig       = (NERR_BASE+381); (* The UPS service is not configured correctly. *)
  NERR_UPSInvalidCommPort     = (NERR_BASE+382); (* The UPS service could not access the specified Comm Port. *)
  NERR_UPSSignalAsserted      = (NERR_BASE+383); (* The UPS indicated a line fail or low battery situation. Service not started. *)
  NERR_UPSShutdownFailed      = (NERR_BASE+384); (* The UPS service failed to perform a system shut down. *)

(*
 *  Remoteboot error codes.
 *
 *          NERR_BASE + (400-419)
 *          Error codes 400 - 405 are used by RPLBOOT.SYS.
 *          Error codes 403, 407 - 416 are used by RPLLOADR.COM,
 *          Error code 417 is the alerter message of REMOTEBOOT (RPLSERVR.EXE).
 *          Error code 418 is for when REMOTEBOOT can't start
 *          Error code 419 is for a disallowed 2nd rpl connection
 *
 *)
  NERR_BadDosRetCode      = (NERR_BASE+400); (* The program below returned an MS-DOS error code:*)
  NERR_ProgNeedsExtraMem  = (NERR_BASE+401); (* The program below needs more memory:*)
  NERR_BadDosFunction     = (NERR_BASE+402); (* The program below called an unsupported MS-DOS function:*)
  NERR_RemoteBootFailed   = (NERR_BASE+403); (* The workstation failed to boot.*)
  NERR_BadFileCheckSum    = (NERR_BASE+404); (* The file below is corrupt.*)
  NERR_NoRplBootSystem    = (NERR_BASE+405); (* No loader is specified in the boot-block definition file.*)
  NERR_RplLoadrNetBiosErr = (NERR_BASE+406); (* NetBIOS returned an error: The NCB and SMB are dumped above.*)
  NERR_RplLoadrDiskErr    = (NERR_BASE+407); (* A disk I/O error occurred.*)
  NERR_ImageParamErr      = (NERR_BASE+408); (* Image parameter substitution failed.*)
  NERR_TooManyImageParams = (NERR_BASE+409); (* Too many image parameters cross disk sector boundaries.*)
  NERR_NonDosFloppyUsed   = (NERR_BASE+410); (* The image was not generated from an MS-DOS diskette formatted with /S.*)
  NERR_RplBootRestart     = (NERR_BASE+411); (* Remote boot will be restarted later.*)
  NERR_RplSrvrCallFailed  = (NERR_BASE+412); (* The call to the Remoteboot server failed.*)
  NERR_CantConnectRplSrvr = (NERR_BASE+413); (* Cannot connect to the Remoteboot server.*)
  NERR_CantOpenImageFile  = (NERR_BASE+414); (* Cannot open image file on the Remoteboot server.*)
  NERR_CallingRplSrvr     = (NERR_BASE+415); (* Connecting to the Remoteboot server...*)
  NERR_StartingRplBoot    = (NERR_BASE+416); (* Connecting to the Remoteboot server...*)
  NERR_RplBootServiceTerm = (NERR_BASE+417); (* Remote boot service was stopped; check the error log for the cause of the problem.*)
  NERR_RplBootStartFailed = (NERR_BASE+418); (* Remote boot startup failed; check the error log for the cause of the problem.*)
  NERR_RPL_CONNECTED      = (NERR_BASE+419); (* A second connection to a Remoteboot resource is not allowed.*)

(*
 *  FTADMIN API error codes
 *
 *       NERR_BASE + (425-434)
 *
 *       (Currently not used in NT)
 *
 *)

(*
 *  Browser service API error codes
 *
 *       NERR_BASE + (450-475)
 *
 *)
  NERR_BrowserConfiguredToNotRun     = (NERR_BASE+450); (* The browser service was configured with MaintainServerList=No. *)

(*
 *  Additional Remoteboot error codes.
 *
 *          NERR_BASE + (510-550)
 *)
  NERR_RplNoAdaptersStarted          = (NERR_BASE+510); (*Service failed to start since none of the network adapters started with this service.*)
  NERR_RplBadRegistry                = (NERR_BASE+511); (*Service failed to start due to bad startup information in the registry.*)
  NERR_RplBadDatabase                = (NERR_BASE+512); (*Service failed to start because its database is absent or corrupt.*)
  NERR_RplRplfilesShare              = (NERR_BASE+513); (*Service failed to start because RPLFILES share is absent.*)
  NERR_RplNotRplServer               = (NERR_BASE+514); (*Service failed to start because RPLUSER group is absent.*)
  NERR_RplCannotEnum                 = (NERR_BASE+515); (*Cannot enumerate service records.*)
  NERR_RplWkstaInfoCorrupted         = (NERR_BASE+516); (*Workstation record information has been corrupted.*)
  NERR_RplWkstaNotFound              = (NERR_BASE+517); (*Workstation record was not found.*)
  NERR_RplWkstaNameUnavailable       = (NERR_BASE+518); (*Workstation name is in use by some other workstation.*)
  NERR_RplProfileInfoCorrupted       = (NERR_BASE+519); (*Profile record information has been corrupted.*)
  NERR_RplProfileNotFound            = (NERR_BASE+520); (*Profile record was not found.*)
  NERR_RplProfileNameUnavailable     = (NERR_BASE+521); (*Profile name is in use by some other profile.*)
  NERR_RplProfileNotEmpty            = (NERR_BASE+522); (*There are workstations using this profile.*)
  NERR_RplConfigInfoCorrupted        = (NERR_BASE+523); (*Configuration record information has been corrupted.*)
  NERR_RplConfigNotFound             = (NERR_BASE+524); (*Configuration record was not found.*)
  NERR_RplAdapterInfoCorrupted       = (NERR_BASE+525); (*Adapter id record information has been corrupted.*)
  NERR_RplInternal                   = (NERR_BASE+526); (*An internal service error has occured.*)
  NERR_RplVendorInfoCorrupted        = (NERR_BASE+527);(*Vendor id record information has been corrupted.*)
  NERR_RplBootInfoCorrupted          = (NERR_BASE+528); (*Boot block record information has been corrupted.*)
  NERR_RplWkstaNeedsUserAcct         = (NERR_BASE+529); (*The user account for this workstation record is missing.*)
  NERR_RplNeedsRPLUSERAcct           = (NERR_BASE+530); (*The RPLUSER local group could not be found.*)
  NERR_RplBootNotFound               = (NERR_BASE+531); (*Boot block record was not found.*)
  NERR_RplIncompatibleProfile        = (NERR_BASE+532); (*Chosen profile is incompatible with this workstation.*)
  NERR_RplAdapterNameUnavailable     = (NERR_BASE+533); (*Chosen network adapter id is in use by some other workstation.*)
  NERR_RplConfigNotEmpty             = (NERR_BASE+534); (*There are profiles using this configuration.*)
  NERR_RplBootInUse                  = (NERR_BASE+535); (*There are workstations, profiles or configurations using this boot block.*)
  NERR_RplBackupDatabase             = (NERR_BASE+536); (*Service failed to backup remoteboot database.*)
  NERR_RplAdapterNotFound            = (NERR_BASE+537); (*Adapter record was not found.*)
  NERR_RplVendorNotFound             = (NERR_BASE+538); (*Vendor record was not found.*)
  NERR_RplVendorNameUnavailable      = (NERR_BASE+539); (*Vendor name is in use by some other vendor record.*)
  NERR_RplBootNameUnavailable        = (NERR_BASE+540); (*(boot name, vendor id) is in use by some other boot block record.*)
  NERR_RplConfigNameUnavailable      = (NERR_BASE+541); (*Configuration name is in use by some other configuration.*)

(**INTERNAL_ONLY**)

(*
 *  Dfs API error codes.
 *
 *          NERR_BASE + (560-590)
 *)

  NERR_DfsInternalCorruption         = (NERR_BASE+560); (*The internal database maintained by the Dfs service is corrupt*)
  NERR_DfsVolumeDataCorrupt          = (NERR_BASE+561); (*One of the records in the internal Dfs database is corrupt*)
  NERR_DfsNoSuchVolume               = (NERR_BASE+562); (*There is no volume whose entry path matches the input Entry Path*)
  NERR_DfsVolumeAlreadyExists        = (NERR_BASE+563); (*A volume with the given name already exists*)
  NERR_DfsAlreadyShared              = (NERR_BASE+564); (*The server share specified is already shared in the Dfs*)
  NERR_DfsNoSuchShare                = (NERR_BASE+565); (*The indicated server share does not support the indicated Dfs volume*)
  NERR_DfsNotALeafVolume             = (NERR_BASE+566); (*The operation is not valid on a non-leaf volume*)
  NERR_DfsLeafVolume                 = (NERR_BASE+567); (*The operation is not valid on a leaf volume*)
  NERR_DfsVolumeHasMultipleServers   = (NERR_BASE+568); (*The operation is ambiguous because the volume has multiple servers*)
  NERR_DfsCantCreateJunctionPoint    = (NERR_BASE+569); (*Unable to create a junction point*)
  NERR_DfsServerNotDfsAware          = (NERR_BASE+570); (*The server is not Dfs Aware*)
  NERR_DfsBadRenamePath              = (NERR_BASE+571); (*The specified rename target path is invalid*)
  NERR_DfsVolumeIsOffline            = (NERR_BASE+572); (*The specified volume is offline*)
  NERR_DfsInternalError              = (NERR_BASE+590); (*Dfs internal error*)


(***********WARNING ****************
 *The range 2750-2799 has been     *
 *allocated to the IBM LAN Server  *
 ***********************************)

(***********WARNING ****************
 *The range 2900-2999 has been     *
 *reserved for Microsoft OEMs      *
 ***********************************)

(**END_INTERNAL**)

  MAX_NERR                = (NERR_BASE+899); (* This is the last error in NERR range. *)

(*
 * end of list
 *
 *    WARNING:  Do not exceed MAX_NERR; values above this are used by
 *              other error code ranges (errlog.h, service.h, apperr.h).
 *)


  MIN_LANMAN_MESSAGE_ID  = NERR_BASE;
  MAX_LANMAN_MESSAGE_ID  = 5799;

function NetApiBufferAllocate (byteCount : Integer; var buffer : Pointer) : NetAPIStatus; stdcall;
function NetApiBufferFree (buffer : Pointer) : NetAPIStatus; stdcall;
function NetApiBufferReallocate (oldBuffer : Pointer; newByteCount : Integer; var newBuffer : Pointer) : NetAPIStatus; stdcall;
function NetApiBufferSize (buffer : Pointer; var byteCount : Integer) : NetAPIStatus; stdcall;

implementation

uses Windows;

function NetApiBufferAllocate;          external 'NETAPI32.DLL';
function NetApiBufferFree;              external 'NETAPI32.dLL';
function NetApiBufferReallocate;        external 'NETAPI32.DLL';
function NetApiBufferSize;              external 'NETAPI32.DLL';

end.

