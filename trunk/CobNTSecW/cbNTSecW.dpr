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


// Thios library implements security functions for NT

library cbNTSecW;

uses
  SysUtils,
  Classes,
  Windows,
  NTSecurityW,
  bmConstants in '..\Common\bmConstants.pas';

{$R *.res}

var
  AList: TAccessControlList;

procedure CreateNTSecW();stdcall;
begin
  AList:=TAccessControlList.Create();
end;

// destroy list
procedure DestroyNTSecW(); stdcall;
begin
  AList.Clear();
  FreeAndNil(AList);
end;

function GrantAccessToEveryoneW(const ObjectName: PWideChar): cardinal; stdcall;
var
  Obj : TNTFileObject;
  ACL : TAccessControlList;
begin
  Result:= INT_SECNOTERRORES;   // No errors
  try
    ACL:= nil;
    Obj:= TNTFileObject.Create(WideString(ObjectName));
    ACL:= TAccessControlList.Create();
    try
      Obj.GetDiscretionaryAccessList(ACL);
      ACL.Clear();
      ACL.AddElement(TAccessControlElement.Create(
                  'Everyone',aeAccessAllowed ,0, FILE_ALL_ACCESS));
      Obj.SetDiscretionaryAccessList(ACL);
    finally
      FreeAndNil(ACL);
      FreeAndNil(Obj);
    end;
  except
    Result:= Windows.GetLastError();
  end;
end;

// Copy the security attributes from file S to File D
function CopySecurityW(const ASource, ADestination: PWideChar): cardinal; stdcall;
var
  Source, Destination: WideString;
  fs, fd: TNTFileObject;
  Owner, Group: WideString;
  Use: cardinal;
begin
  Result:= INT_SECNOTERRORES; // no errors
  Source:= WideString(ASource);
  Destination:= WideString(ADestination);
  try
    fs:= TNTFileObject.Create(Source);
    fd:= TNTFileObject.Create(Destination);
    try
      AList.Clear();
      if fs.GetDiscretionaryAccessList(AList)  then
        fd.SetDiscretionaryAccessList(AList);
      if fs.GetOwner(Owner,Use) then
        fd.SetOwner(Owner);
      if fs.GetGroup(Group, Use) then
        fd.SetGroup(Group);
    finally
      FreeAndNil(fd);
      FreeAndNil(fs);
    end;
  except
    Result:= Windows.GetLastError();
  end;
end;

exports
  CopySecurityW, CreateNTSecW, DestroyNTSecW, GrantAccessToEveryoneW;

begin
end.
