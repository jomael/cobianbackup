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

// This library implements service-related operations

library cbNTW;

uses
  SysUtils,
  TntClasses,
  WinSvc,
  wINDOWS,
  lsaapiW,
  bmConstants in '..\Common\bmConstants.pas';

/// Don't dare to call any function of this dll in a 9x machine
/// or you machine will painfully implode :-)

{$R *.res}
const
  SIZEENUM = 16384;

///****************************************************************************
/// non-exported functions
///****************************************************************************

/// This is NOT an exported function
/// THis enumerates the status of the services

function GetEnumServiceStatus(Scm: SC_HANDLE; ServiceType, ServiceState: DWORD;
  var Count: DWORD; var Status: PEnumServiceStatusW): boolean;
var
  ResumeHandle, Size: DWORD;
begin
  ResumeHandle := 0;
  Size := SIZEENUM + SizeOf(TEnumServiceStatusW);
  Status := AllocMem(Size);
  Result := EnumServicesStatusW(Scm, ServiceType, ServiceState, Status^, Size,
                                Size, Count, ResumeHandle);
  if (not Result) and (GetLastError = ERROR_MORE_DATA) then
  begin
    ReallocMem(Status, Size);
    Result := EnumServicesStatusW(Scm, ServiceType, ServiceState, Status^,
      Size, Size, Count, ResumeHandle);
  end;
  if not Result then
  begin
    FreeMem(Status);
    Status := nil;
  end;
end;



function GetServiceList(var List: WideString): boolean;
var
  Scm: SC_HANDLE;
  I, Count: DWORD;
  SvcList, SvcEntry: PEnumServiceStatusW;
  Sl: TTntStringList;
  Encoded: WideString;
  {*******subprocedure begin******}
  procedure ProcessService();
  var
    Service: SC_HANDLE;
    Sll: TTntStringList;
  begin
    Sll := TTntStringList.Create();
    try
      Sll.Add(WideString(SvcEntry.lpServiceName));
      Sll.Add(WideString(SvcEntry.lpDisplayName));
      case SvcEntry.ServiceStatus.dwCurrentState of
        SERVICE_STOPPED:
          Sll.Add(WS_STOPPED);
        SERVICE_START_PENDING:
          Sll.Add(WS_STARTPENDING);
        SERVICE_STOP_PENDING:
          Sll.Add(WS_STOPPENDING);
        SERVICE_RUNNING:
          Sll.Add(WS_RUNNING);
        SERVICE_CONTINUE_PENDING:
          Sll.Add(WS_CONNTINUE_PENDING);
        SERVICE_PAUSE_PENDING:
          Sll.Add(WS_PAUSE_PENDING);
        SERVICE_PAUSED:
          Sll.Add(WS_PAUSED);
      else
        Sll.Add(WS_UNKNOWN);
      end; //case

      // store the commatext on s now to further processing
      Encoded := Sll.CommaText;
    finally
      FreeAndNil(Sll);
    end;

    Service := OpenServiceW(Scm, SvcEntry.lpServiceName,
      SERVICE_QUERY_CONFIG);
    if Service <> 0 then
    begin
      CloseServiceHandle(Service);
    end;
  end;
  {*******subprocedure end********}
begin
  Result := true; //OK

  //Create and populate the stringlist
  Sl := TTntStringList.Create;
  try
    // Open the service manager
    Scm := OpenScManagerW(nil, nil, SC_MANAGER_ENUMERATE_SERVICE);
    if Scm <> 0 then
    begin
      if GetEnumServiceStatus(Scm, SERVICE_WIN32, SERVICE_STATE_ALL, Count,
        SvcList) then //Get the number of installed services
      begin
        SvcEntry := SvcList;
        for i := 0 to Count - 1 do // and iterate throu the services
        begin
          ProcessService();
          // ProcessService will place a comma separated string
          // on the variable s. This string will contain
          // ServiceName,ServiceDescryption,Status
          Sl.Add(Encoded);
          Inc(SvcEntry);
        end; //for
        //Return the COMMATEXT
        List := sl.CommaText;
        FreeMem(SvcList);
      end
      else
        //if get =false...
        Result := false;
      CloseServiceHandle(Scm);
    end; //if
  finally
    FreeAndNil(Sl);
  end;
end;


//*************************************************************************
//*************************************************************************

/// This function will return a comma separated string
/// with the list of the installed services (as the PWideChar parameter)
/// It wil return true (>0) if succeded
/// This IS an exported function

function GetServices(const ServiceL: PWideChar; var Size: longint): longint; stdcall;
var
  ServiceList: WideString;
begin
  {Get the list of the services first}
  Result := longint(GetServiceList(ServiceList));

  // this function works the API way
  // if called with the first parameter "nil" then
  // return only the size. The caller must then call the function
  // again with the allocated memory
  // return the string
  // Whe using this function, first call it with the first parameter NIL
  // Allocate the memory (including the size for
  // the #0 terminator and call it again to get the string

  if ServiceL = nil then
    Size := Length(ServiceList)
  else
    lstrcpynW(ServiceL, PWideChar(ServiceList), Size - 1); //-1 because of terminating #0

end;

function StartAService(const ServiceName, Parameters: PWideChar): cardinal; stdcall;
var
  ServiceManager, Service: SC_HANDLE;
  Par: PWideChar;
begin
  if (WideString(Parameters) = WS_NIL) then
    Par:= nil else
    Par:= Parameters;
  ServiceManager := OpenSCManagerW(nil, nil, SC_MANAGER_CONNECT);
  if ServiceManager <> 0 then
  begin
    Service := OpenServiceW(ServiceManager, ServiceName, SERVICE_ALL_ACCESS);
    if Service <> 0 then
    begin
      if StartServiceW(Service, DWORD(0), Par) = True then
        Result := INT_LIBOK else
        Result:= Windows.GetLastError();
      CloseServiceHandle(Service);
    end else
      Result:= Windows.GetLastError();
    CloseServiceHandle(ServiceManager);
  end else //servicemanager
    Result:= Windows.GetLastError();
end;

function StopAService(const ServiceName: PWideChar): cardinal; stdcall;
var
  ServiceManager, Service: SC_HANDLE;
  ServiceStatus: TServiceStatus;
begin
  ServiceManager := OpenSCManagerW(nil, nil, SC_MANAGER_CONNECT);
  if ServiceManager <> 0 then
  begin
    Service := OpenServiceW(ServiceManager, ServiceName , SERVICE_ALL_ACCESS);
    if Service <> 0 then
    begin
      QueryServiceStatus(Service, ServiceStatus);
      if ControlService(Service, SERVICE_CONTROL_STOP, ServiceStatus) then
        Result := INT_LIBOK else
        Result:= Windows.GetLastError();

      CloseServiceHandle(Service);
    end else //Service
      Result:= Windows.GetLastError();
    CloseServiceHandle(ServiceManager);
  end else //servicemanager
    Result:= Windows.GetLastError();
end;

function ServiceRunning(const ServiceName: PWideChar): cardinal; stdcall;
var
  ServiceManager, Service: SC_HANDLE;
  SS: TServiceStatus;
begin
  ServiceManager := OpenSCManagerW(nil, nil, SC_MANAGER_CONNECT);
  if ServiceManager <> 0 then
  begin
    Service := OpenServiceW(ServiceManager, ServiceName , SERVICE_INTERROGATE);
    if Service <> 0 then
    begin
      if ControlService(Service, SERVICE_CONTROL_INTERROGATE, SS) then
      begin
        if SS.dwCurrentState = SERVICE_RUNNING then
          Result:= INT_SERVICERUNNING else
          Result:= INT_LIBUNDEFINED;
      end else
        Result:= Windows.GetLastError();
      CloseServiceHandle(Service);
    end else //Service
      Result:= Windows.GetLastError();
    CloseServiceHandle(ServiceManager);
  end else //servicemanager
    Result:= Windows.GetLastError();
end;

function ServiceInstalled(const ServiceName: PWideChar): cardinal; stdcall;
var
  ServiceManager, Service: SC_HANDLE;
begin
  ServiceManager := OpenSCManagerW(nil, nil, SC_MANAGER_CONNECT);
  if ServiceManager <> 0 then
  begin
    Service := OpenServiceW(ServiceManager, ServiceName , SERVICE_QUERY_STATUS);
    if Service <> 0 then
    begin
      Result:= INT_SERVICEINSTALLED;
      CloseServiceHandle(Service);
    end else //Service
      Result:= Windows.GetLastError();
    CloseServiceHandle(ServiceManager);
  end else //servicemanager
    Result:= Windows.GetLastError();
end;

function UninstallService(const ServiceName: PWideChar): cardinal; stdcall;
var
  ServiceManager, Service: SC_HANDLE;
begin
  //Before you uninstall a service you must STOP it
  // if you don't it will be MARKED to be uninstalled
  ServiceManager := OpenSCManagerW(nil, nil, SC_MANAGER_CONNECT);
  if ServiceManager <> 0 then
  begin
    Service := OpenServiceW(ServiceManager, ServiceName , SERVICE_ALL_ACCESS);
    if Service <> 0 then
    begin
      if DeleteService(Service) then
        Result:= INT_SERVICEDELETED else
        Result:= Windows.GetLastError();
      CloseServiceHandle(Service);
    end else //Service
      Result:= Windows.GetLastError();
    CloseServiceHandle(ServiceManager);
  end else //servicemanager
    Result:= Windows.GetLastError();
end;

function InstallService(const ServiceName, DisplayName, Binary, ID, Password: PWideChar): cardinal; stdcall;
var
  ServiceManager, Service: SC_HANDLE;
begin
  Result := INT_LIBOTHERERROR;

  ServiceManager := OpenSCManagerW(nil, nil, SC_MANAGER_ALL_ACCESS);
  if ServiceManager <> 0 then
  begin
    Service:= CreateServiceW(ServiceManager, ServiceName, DisplayName,
                             SERVICE_ALL_ACCESS,SERVICE_WIN32_OWN_PROCESS,
                             SERVICE_AUTO_START, SERVICE_ERROR_IGNORE,
                             Binary, nil, nil, nil, ID, Password);
    if (Service <> 0) then
    begin
      Result:= INT_SERVICEINSTALLED;
      CloseServiceHandle(Service);
    end else
      Result:= GetLastError();
    
    CloseServiceHandle(ServiceManager);
  end; //servicemanager
end;

function AddLogonAsAService(const ID: PWideChar): cardinal; stdcall;
var
  FResult: NTSTATUS;
  //szSystemName: LPTSTR;
  FObjectAttributes: TLSAObjectAttributes;
  FPolicyHandle: LSA_HANDLE;
  Server, Privilege: TLSAUnicodeString;
  FSID: PSID;
  cbSid: DWORD;
  ReferencedDomain: PWideChar;
  cchReferencedDomain: DWORD;
  peUse: SID_NAME_USE;
  PrivilegeString: WideString;
  User: WideString;
begin
  try
    User:= WideString(ID);

    // LookupAccountNameW doesn't accept .\user for local accounts
    if (User <> WS_NIL) then
      if (User[1] = WC_DOT) then
        if (Length(User) > 2) then
          Delete(User, 1, 2);
    
    ZeroMemory(@FObjectAttributes, sizeof(FObjectAttributes));

    Server.Buffer := nil;
    Server.Length := 0;
    Server.MaximumLength := 256;

    PrivilegeString := WS_SERVICELOGON;
    Privilege.Buffer := PWideChar(PrivilegeString);
    Privilege.Length := Length(WS_SERVICELOGON) * SizeOf(WideChar);
    Privilege.MaximumLength := 256;

    FResult := LsaOpenPolicy(Server, //this machine
      FObjectAttributes,
      POLICY_ALL_ACCESS,
      FPolicyHandle);

    if FResult = STATUS_SUCCESS then
    begin
      cbSid := 128;
      cchReferencedDomain := 16;
      GetMem(FSID, cbSid);
      //FSID:=PSID(HeapAlloc(GetProcessHeap(), 0, cbSid));
      GetMem(ReferencedDomain, cchReferencedDomain);
      //ReferencedDomain := LPTSTR(HeapAlloc(GetProcessHeap(), 0, cchReferencedDomain * sizeof(ReferencedDomain^)));

      if LookupAccountNameW(nil, PWideChar(User), FSID, cbSid, ReferencedDomain,
        cchReferencedDomain, peUse) then
      begin
        FResult := LsaAddAccountRights(FPolicyHandle, FSID, @Privilege, 1);
        if (FResult = STATUS_SUCCESS) then
           Result := INT_PRIVILEGEASSIGNED else
           Result:= Windows.GetLastError();
      end else
        Result:= Windows.GetLastError();

      FreeMem(FSID, cbSid);
      FreeMem(ReferencedDomain, cchReferencedDomain);
    end else
      Result:= Windows.GetLastError();
  except
    Result :=INT_PRIVILEGEERROR;
  end;

end;

exports GetServices, StartAService, StopAService, ServiceInstalled,
       ServiceRunning, UninstallService, InstallService, AddLogonAsAService;

begin

end.
