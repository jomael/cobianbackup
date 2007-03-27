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

// This is the popup balloon that is shown in the tray. Used to show
// application messages to the user

unit interface_Balloon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, Menus,
  TntMenus;

type
  Tform_Balloon = class(TTntForm)
    timer_Hide: TTimer;
    p_Main: TTntPanel;
    pb_Main: TTntPaintBox;
    l_Message: TTntLabel;
    procedure TntFormCreate(Sender: TObject);
    procedure l_MessageClick(Sender: TObject);
    procedure timer_HideTimer(Sender: TObject);
    procedure TntFormClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
  private

  public
    { Public declarations }
    procedure ShowMsg(const Msg: WideString; const TimeMs: cardinal);
  end;

var
  form_Balloon: Tform_Balloon;

implementation

uses bmConstants, interface_Common;

{$R *.dfm}

procedure Tform_Balloon.l_MessageClick(Sender: TObject);
begin
  timer_Hide.Enabled:= false;
  Hide();
end;

procedure Tform_Balloon.ShowMsg(const Msg: WideString; const TimeMs: cardinal);
begin
  Hide();
  timer_Hide.Enabled:= false;
  l_Message.Caption:= Msg;
  Width:= l_Message.Width + 4 * INT_MSGMARGIN;
  Height:= INT_MSGHEIGHT;
  l_Message.Left:= INT_MSGMARGIN;
  l_Message.Top:= (p_Main.Height div 2) - (l_Message.Height div 2);
  Left:= Screen.WorkAreaWidth - (INT_MARGINSCREENW + Width);
  Top:= Screen.WorkAreaHeight - (INT_MARGINSCREENH + Height);
  timer_Hide.Interval:= TimeMs;
  Show();
  timer_Hide.Enabled:= true;
end;

procedure Tform_Balloon.timer_HideTimer(Sender: TObject);
begin
  timer_Hide.Enabled:= false;
  Hide();
end;

procedure Tform_Balloon.TntFormClick(Sender: TObject);
begin
  timer_Hide.Enabled:= false;
  Hide();
end;

procedure Tform_Balloon.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
  timer_Hide.Enabled:= false;
end;

procedure Tform_Balloon.TntFormCreate(Sender: TObject);
begin
  timer_Hide.Enabled:= false;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  Color:= RGB(INT_BALLONR,INT_BALLONG,INT_BALLONB);   
end;

end.
