{
  $Project$
  $Workfile$
  $Revision$
  $DateUTC$
  $Id$

  This file is part of the Indy (Internet Direct) project, and is offered
  under the dual-licensing agreement described on the Indy website.
  (http://www.indyproject.org/)

  Copyright:
   (c) 1993-2005, Chad Z. Hower and the Indy Pit Crew. All rights reserved.
}
{
  $Log$
}

unit IdSysVCL;

interface

uses
  {$I IdCompilerDefines.inc}
  {$IFDEF DOTNET}
  System.IO,
  {$ENDIF}
  {$IFDEF MSWindows}
  Windows,
  {$ENDIF}
  {$IFDEF DELPHI5}
  FileCtrl,
  {$ENDIF}
  IdSysBase,
  SysUtils;

type
  TIdDateTimeBase = TDateTime;
  TAnsiCharSet = set of AnsiChar;
  TSysCharSet = SysUtils.TSysCharSet;
  TIdSysVCL = class(TIdSysBase)
  public
    class function StrToInt64(const S: string): Int64; overload;
    class function StrToInt64(const S: string; const Default : Int64): Int64; overload; 

    class function TwoDigitYearCenturyWindow : Word; 
    class function DayOfWeek(const ADateTime: TDateTime): Word;
    class function DateTimeToStr(const ADateTime: TDateTime): string;  
    class function StrToDateTime(const S: String): TDateTime;

    class function Now : TDateTime;  
    class function FormatDateTime(const Format: string; ADateTime: TDateTime): string; 
    class function Format(const Format: string; const Args: array of const): string;

    class function FileDateToDateTime(FileDate: Integer): TDateTime;
    class function CompareStr(const S1, S2: string): Integer;
    class function AddMSecToTime(const ADateTime : TDateTime; const AMSec : Integer):TDateTime;
    class function CompareDate(const D1, D2 : TDateTime) : Integer; 
    class function SameText(const S1, S2 : String) : Boolean;
    class procedure FreeAndNil(var Obj);  
    class function LeadBytes: TAnsiCharSet; 
    class function IntToHex(Value: Integer; Digits: Integer): string; overload;
    class function IntToHex(Value: Int64; Digits: Integer): string; overload;
    class function IntToStr(Value: Integer): string; overload; 
    class function IntToStr(Value: Int64): string; overload;
    class function IncludeTrailingPathDelimiter(const S: string): string;
    class function ExcludeTrailingPathDelimiter(const S: string): string;
    class function StrToInt(const S: string; Default: Integer): Integer; overload;
    class function StrToInt(const S: string): Integer; overload;
    class function LowerCase(const S: string): string;
    class function UpperCase(const S: string): string; overload;
    class procedure RaiseLastOSError;
    class function Trim(const S: string): string;
    class function TrimLeft(const S: string): string;
    class function TrimRight(const S: string): string;


    class procedure Abort;
    class function FileExists(const FileName: string): Boolean;
    class function LastDelimiter(const Delimiters, S: string): Integer;
    class function StringReplace(const S, OldPattern, NewPattern: string): string; overload;
    class function StringReplace(const S : String; const OldPattern, NewPattern: array of string): string; overload;

    class function ReplaceOnlyFirst(const S, OldPattern, NewPattern: string): string;
    class procedure DecodeTime(const ADateTime: TDateTime; var Hour, Min, Sec, MSec: Word);
    class procedure DecodeDate(const ADateTime: TDateTime; var Year, Month, Day: Word);
    class function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime;
    class function EncodeDate(Year, Month, Day: Word): TDateTime;
    class function FileAge(const FileName: string): TDateTime;
    class function DirectoryExists(const Directory: string): Boolean;
    class function DeleteFile(const FileName: string): Boolean;
    class function ExtractFilePath(const FileName: string): string;
    class function ExtractFileName(const FileName: string): string;
    class function ExtractFileExt(const FileName: string): string;
    class function ChangeFileExt(const FileName, Extension: string): string;
    class function IsLeapYear(Year: Word): Boolean;
    class function FloatToIntStr(const AFloat: Extended): String;
    class function DateTimeGMTToHttpStr(const GMTValue: TIdDateTimeBase) : String;
    class function DateTimeToInternetStr(const Value: TIdDateTimeBase; const AIsGMT : Boolean = False) : String;
    class function DateTimeToGmtOffSetStr(ADateTime: TIdDateTimeBase; SubGMT: Boolean): string;
    class function OffsetFromUTC: TIdDateTimeBase;
  end;

implementation

uses IdSys;

{$IFDEF VCL7ORABOVE}
//Delphi5 does not have TFormatSettings
//this should be changed to a singleton?
function GetEnglishSetting: TFormatSettings;
begin
  Result.CurrencyFormat := $00; // 0 = '$1'
  Result.NegCurrFormat := $00; //0 = '($1)'
  Result.CurrencyString := '$';
  Result.CurrencyDecimals := 2;

  Result.ThousandSeparator := ',';
  Result.DecimalSeparator := '.';

  Result.DateSeparator := '/';
  Result.ShortDateFormat := 'M/d/yyyy';
  Result.LongDateFormat := 'dddd, MMMM dd, yyyy';

  Result.TimeSeparator := ':';
  Result.TimeAMString := 'AM';
  Result.TimePMString := 'PM';
  Result.LongTimeFormat := 'h:mm:ss AMPM';
  Result.ShortTimeFormat := 'h:mm AMPM';

  Result.ShortMonthNames[1] := 'Jan';
  Result.ShortMonthNames[2] := 'Feb';
  Result.ShortMonthNames[3] := 'Mar';
  Result.ShortMonthNames[4] := 'Apr';
  Result.ShortMonthNames[5] := 'May';
  Result.ShortMonthNames[6] := 'Jun';
  Result.ShortMonthNames[7] := 'Jul';
  Result.ShortMonthNames[8] := 'Aug';
  Result.ShortMonthNames[9] := 'Sep';
  Result.ShortMonthNames[10] := 'Oct';
  Result.ShortMonthNames[11] := 'Nov';
  Result.ShortMonthNames[12] := 'Dec';

  Result.LongMonthNames[1] := 'January';
  Result.LongMonthNames[2] := 'February';
  Result.LongMonthNames[3] := 'March';
  Result.LongMonthNames[4] := 'April';
  Result.LongMonthNames[5] := 'May';
  Result.LongMonthNames[6] := 'June';
  Result.LongMonthNames[7] := 'July';
  Result.LongMonthNames[8] := 'August';
  Result.LongMonthNames[9] := 'September';
  Result.LongMonthNames[10] := 'October';
  Result.LongMonthNames[11] := 'November';
  Result.LongMonthNames[12] := 'December';

  Result.ShortDayNames[1] := 'Sun';
  Result.ShortDayNames[2] := 'Mon';
  Result.ShortDayNames[3] := 'Tue';
  Result.ShortDayNames[4] := 'Wed';
  Result.ShortDayNames[5] := 'Thu';
  Result.ShortDayNames[6] := 'Fri';
  Result.ShortDayNames[7] := 'Sat';

  Result.LongDayNames[1] := 'Sunday';
  Result.LongDayNames[2] := 'Monday';
  Result.LongDayNames[3] := 'Tuesday';
  Result.LongDayNames[4] := 'Wednesday';
  Result.LongDayNames[5] := 'Thursday';
  Result.LongDayNames[6] := 'Friday';
  Result.LongDayNames[7] := 'Saturday';

  Result.ListSeparator := ',';
end;
{$ENDIF}

class procedure TIdSysVCL.Abort;
begin
  SysUtils.Abort;
end;

class function TIdSysVCL.OffsetFromUTC: TIdDateTimeBase;
begin
  Result := 0;
end;

class function TIdSysVCL.FileExists(const FileName: string): Boolean;
begin
  Result := SysUtils.FileExists(FileName);
end;

class function TIdSysVCL.Format(const Format: string;
  const Args: array of const): string;
begin
  {$IFNDEF VCL7ORABOVE}
  //Is there a way to get delphi5 to use locale in format? something like:
  //  SetThreadLocale(TheNewLocaleId);
  //  GetFormatSettings;
  //  Application.UpdateFormatSettings := False; //needed?
  //  format()
  //  set locale back to prior
  Result := SysUtils.Format(Format,Args);
  {$ELSE}
  Result := SysUtils.Format(Format,Args,GetEnglishSetting);
  {$ENDIF}
end;

class procedure TIdSysVCL.FreeAndNil(var Obj);
begin
  SysUtils.FreeAndNil(Obj);
end;

class function TIdSysVCL.IncludeTrailingPathDelimiter(const S: string): string;
begin
  {$IFDEF DELPHI5}
  Result := SysUtils.IncludeTrailingBackslash(S);
  {$ELSE}
  Result := SysUtils.IncludeTrailingPathDelimiter(S);
  {$ENDIF}
end;

class function TIdSysVCL.ExcludeTrailingPathDelimiter(const S: string): string;
begin
  {$IFDEF DELPHI5}
  Result := SysUtils.ExcludeTrailingBackslash(S);
  {$ELSE}
  Result := SysUtils.ExcludeTrailingPathDelimiter(S);
  {$ENDIF}
end;

class function TIdSysVCL.IntToHex(Value: Int64; Digits: Integer): string;
begin
  Result := SysUtils.IntToHex(Value,Digits);
end;

class function TIdSysVCL.IntToHex(Value, Digits: Integer): string;
begin
  Result := SysUtils.IntToHex(Value,Digits);
end;

class function TIdSysVCL.IntToStr(Value: Int64): string;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TIdSysVCL.IntToStr(Value: Integer): string;
begin
  Result := SysUtils.IntToStr(Value);
end;

class function TIdSysVCL.LastDelimiter(const Delimiters,
  S: string): Integer;
begin
  Result := SysUtils.LastDelimiter(Delimiters, S);
end;

class function TIdSysVCL.LeadBytes: TAnsiCharSet;
begin
  Result := SysUtils.LeadBytes;
end;

class procedure TIdSysVCL.RaiseLastOSError;
begin
  {$IFDEF DELPHI5}
  SysUtils.RaiseLastWin32Error;
  {$ELSE}
  SysUtils.RaiseLastOSError;
  {$ENDIF}
end;

class function TIdSysVCL.StringReplace(const S: String; const OldPattern,
  NewPattern: array of string): string;
var
  i : Integer;
begin
  Result:=s;
  for i := Low(OldPattern) to High(OldPattern) do
  begin
    Result := SysUtils.StringReplace(Result,OldPattern[i],NewPattern[i],[rfReplaceAll]);
  end;
end;

class function TIdSysVCL.StringReplace(const S, OldPattern,
  NewPattern: string): string;
begin
   Result := SysUtils.StringReplace(s,OldPattern,NewPattern,[rfReplaceAll]);
end;

class function TIdSysVCL.ReplaceOnlyFirst(const S, OldPattern,
  NewPattern: string): string;
begin
   Result := SysUtils.StringReplace(s,OldPattern,NewPattern,[]);
end;

class function TIdSysVCL.StrToInt(const S: string): Integer;
begin
  Result := SysUtils.StrToInt(Trim(S));
end;

class function TIdSysVCL.StrToInt(const S: string;
  Default: Integer): Integer;
begin
  Result := SysUtils.StrToIntDef(Trim(S),Default);
end;

class function TIdSysVCL.Trim(const S: string): string;
begin
  Result := SysUtils.Trim(s);
end;

class function TIdSysVCL.UpperCase(const S: string): string;
begin
  Result := SysUtils.UpperCase(S);
end;

class function TIdSysVCL.DateTimeToStr(const ADateTime: TDateTime): string;
begin
  Result := SysUtils.DateTimeToStr(ADateTime);
end;

class function TIdSysVCL.StrToDateTime(const S: String): TDateTime;
begin
  Result := SysUtils.StrToDateTime(S);
end;

class function TIdSysVCL.Now: TDateTime;
begin
  Result := SysUtils.Now;
end;

class function TIdSysVCL.CompareDate(const D1, D2: TDateTime): Integer;
var LTM1, LTM2 : TTimeStamp;
begin
  LTM1 := DateTimeToTimeStamp(D1);
  LTM2 := DateTimeToTimeStamp(D2);
  if (LTM1.Date = LTM2.Date) then
  begin
    if (LTM1.Time < LTM2.Time) then
    begin
       Result := -1;
    end
    else
    begin
      if (LTM1.Time > LTM2.Time) then
      begin
        Result := 1;
      end
      else
      begin
        Result := 0;
      end;
    end;
  end
  else
  begin
    if LTM1.Date > LTM2.Date then
    begin
      Result := 1;
    end
    else
    begin
      Result := -1;
    end;
  end;
end;

class function TIdSysVCL.FormatDateTime(const Format: string;
  ADateTime: TDateTime): string;
begin
   Result := SysUtils.FormatDateTime(Format,ADateTime);
end;

class function TIdSysVCL.DayOfWeek(const ADateTime: TDateTime): Word;
begin
  Result := SysUtils.DayOfWeek(ADateTime);
end;

class procedure TIdSysVCL.DecodeDate(const ADateTime: TDateTime;
  var Year, Month, Day: Word);
begin
  SysUtils.DecodeDate(ADateTime,Year,Month,Day);
end;

class function TIdSysVCL.EncodeTime(Hour, Min, Sec,
  MSec: Word): TDateTime;
begin
  Result := SysUtils.EncodeTime(Hour,Min,Sec,MSec);
end;

class procedure TIdSysVCL.DecodeTime(const ADateTime: TDateTime;
  var Hour, Min, Sec, MSec: Word);
begin
  SysUtils.DecodeTime(ADateTime,Hour,Min,Sec,MSec);
end;

class function TIdSysVCL.EncodeDate(Year, Month, Day: Word): TDateTime;
begin
  Result := SysUtils.EncodeDate(Year,Month,Day);
end;

class function TIdSysVCL.TrimLeft(const S: string): string;
begin
  Result := SysUtils.TrimLeft(S);
end;

class function TIdSysVCL.TrimRight(const S: string): string;
begin
  Result := SysUtils.TrimRight(S);
end;

class function TIdSysVCL.ExtractFileName(const FileName: string): string;
begin
   Result := SysUtils.ExtractFileName(FileName);
end;

class function TIdSysVCL.FileAge(const FileName: string): TDateTime;
begin
  Result := SysUtils.FileDateToDateTime( SysUtils.FileAge(FileName));
end;

class function TIdSysVCL.DirectoryExists(const Directory: string): Boolean;
begin
  {$IFDEF DELPHI5}
  Result := FileCtrl.DirectoryExists(Directory);
  {$ELSE}
  Result := SysUtils.DirectoryExists(Directory);
  {$ENDIF}
end;

class function TIdSysVCL.DeleteFile(const FileName: string): Boolean;
begin
  Result := SysUtils.DeleteFile(FileName);
end;

class function TIdSysVCL.ExtractFileExt(const FileName: string): string;
begin
  Result := SysUtils.ExtractFileExt(FileName);
end;

class function TIdSysVCL.LowerCase(const S: string): string;
begin
  Result := SysUtils.LowerCase(S);
end;

class function TIdSysVCL.FloatToIntStr(const AFloat: Extended): String;
begin
  Result := SysUtils.FloatToStr(AFloat);
end;

class function TIdSysVCL.TwoDigitYearCenturyWindow: Word;
begin
  Result := SysUtils.TwoDigitYearCenturyWindow;
end;

class function TIdSysVCL.CompareStr(const S1, S2: string): Integer;
begin
  Result := SysUtils.CompareStr(S1,S2);
end;

class function TIdSysVCL.StrToInt64(const S: string; const Default: Int64): Int64;
begin
  Result := SysUtils.StrToInt64Def(Trim(S),Default);
end;

class function TIdSysVCL.StrToInt64(const S: string): Int64;
begin
  Result := SysUtils.StrToInt64(Trim(S));
end;

class function TIdSysVCL.SameText(const S1, S2: String): Boolean;
begin
  Result := SysUtils.SameText(S1,S2);
end;

class function TIdSysVCL.AddMSecToTime(const ADateTime: TDateTime;
  const AMSec: Integer): TDateTime;
var
  LTM : TTimeStamp;
begin
  LTM := DateTimeToTimeStamp(ADateTime);
  LTM.Time := LTM.Time + AMSec;
  Result :=  TimeStampToDateTime(LTM);
end;

class function TIdSysVCL.FileDateToDateTime(
  FileDate: Integer): TDateTime;
begin
  Result := SysUtils.FileDateToDateTime(FileDate);
end;

class function TIdSysVCL.ChangeFileExt(const FileName, Extension: string): string;
begin
  Result := SysUtils.ChangeFileExt(FileName,Extension);
end;

class function TIdSysVCL.IsLeapYear(Year: Word): Boolean;
begin
  Result := SysUtils.IsLeapYear(Year);
end;

const
  wdays: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'    {Do not Localize}
   , 'Sat'); {do not localize}
  monthnames: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May'    {Do not Localize}
   , 'Jun',  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'); {do not localize}

class function TIdSysVCL.DateTimeGMTToHttpStr(const GMTValue: TIdDateTimeBase) : String;
// should adhere to RFC 2616

var
  wDay,
  wMonth,
  wYear: Word;
begin
  DecodeDate(GMTValue, wYear, wMonth, wDay);
  Result := Format('%s, %.2d %s %.4d %s %s',    {do not localize}
                   [wdays[DayOfWeek(GMTValue)], wDay, monthnames[wMonth],
                    wYear, FormatDateTime('HH":"mm":"ss',GMTValue),'GMT']);  {do not localize}
end;

// Changed by Luis Cobian
// Fixes a bug with the creation date of the messages

{This should never be localized}
class function TIdSysVCL.DateTimeToInternetStr(const Value: TIdDateTimeBase; const AIsGMT : Boolean = False) : String;
var
  wDay,
  wMonth,
  wYear: Word;
begin
  DecodeDate(Value, wYear, wMonth, wDay);
  Result := Format('%s, %d %s %d %s %s',    {do not localize}
                   [ wdays[DayOfWeek(Value)], wDay, monthnames[wMonth],
                    wYear, FormatDateTime( 'HH":"mm":"ss', Value), {do not localize}
                    DateTimeToGmtOffSetStr(Sys.OffsetFromUTC, AIsGMT)]);
end;

class function TIdSysVCL.DateTimeToGmtOffSetStr(ADateTime: TIdDateTimeBase; SubGMT: Boolean): string;
var
  AHour, AMin, ASec, AMSec: Word;
begin
  if (ADateTime = 0.0) and SubGMT then
  begin
    Result := 'GMT'; {do not localize}
    Exit;
  end;
  DecodeTime(ADateTime, AHour, AMin, ASec, AMSec);
  Result := Format(' %0.2d%0.2d', [AHour, AMin]); {do not localize}
  if ADateTime < 0.0 then
  begin
    Result[1] := '-'; {do not localize}
  end
  else
  begin
    Result[1] := '+';  {do not localize}
  end;
end;

class function TIdSysVCL.ExtractFilePath(const FileName: string): string;
begin
  Result := SysUtils.ExtractFilePath(FileName);
end;

end.
