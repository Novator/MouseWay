{******************************************************************}
{                                                                  }
{ 2003(fw) Ironsoft Lab, Perm, Russia                              }
{ http://ironsite.narod.ru                                         }
{ Written by Iron (Michael Galyuk), ironsoft@mail.ru               }
{                                                                  }
{ Êîä ğàñïğîñòğàíÿåòñÿ íà ïğàâàõ ëèöåíçèè GNU GPL                  }
{ Ïğè èñïîëüçîâàíèè êîäà ññûëêà íà àâòîğà îáÿçàòåëüíà              }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied.                                                         }
{                                                                  }
{ ÊÎÄ ĞÀÑÏĞÎÑÒĞÀÍßÅÒÑß ÏÎ ÏĞÈÍÖÈÏÓ "ÊÀÊ ÅÑÒÜ", ÍÈÊÀÊÈÕ             }
{ ÃÀĞÀÍÒÈÉ ÍÅ ÏĞÅÄÓÑÌÀÒĞÈÂÀÅÒÑß, ÂÛ ÈÑÏÎËÜÇÓÅÒÅ ÅÃÎ ÍÀ ÑÂÎÉ ĞÈÑÊ.  }
{ ÀÂÒÎĞ ÍÅ ÍÅÑÅÒ ÎÒÂÅÒÑÒÂÅÍÍÎÑÒÈ ÇÀ ÏĞÈ×ÈÍÅÍÍÛÉ ÓÙÅĞÁ ÑÂßÇÀÍÍÛÉ    }
{ Ñ ÅÃÎ ÈÑÏÎËÜÇÎÂÀÍÈÅÌ (ÏĞÀÂÈËÜÍÛÌ ÈËÈ ÍÅÏĞÀÂÈËÜÍÛÌ).              }
{                                                                  }
{******************************************************************}

unit WayFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TWayForm = class(TForm)
    WayLabel: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure WayLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    {procedure WMNCHitTest(var Message : TWMNCHitTest); message WM_NCHITTEST;}
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  WayForm: TWayForm;

implementation

uses SetupFrm;

{$R *.DFM}

{procedure TWayForm.WMNCHitTest(var Message : TWMNCHitTest);
begin
  inherited;
  Message.Result  := htCaption;
end;}

procedure TWayForm.WMSysCommand(var Message: TMessage);
begin
  if Message.wParam = SC_CLOSE then
    Message.Result := 0
  else
    inherited;
end;

procedure TWayForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TWayForm.FormCreate(Sender: TObject);
begin
  {SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0,
    SWP_NOSIZE + SWP_NOMOVE);}
  SetWindowLong(Handle, GWL_EXSTYLE,
    GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW);
  SetBounds(GetDeviceCaps(GetDC(0), HORZRES)-165, 0, 85, Height);
  WayLabel.SetBounds(1, 1, Width-2, Height-2);
  {DeferWindowPos(BeginDeferWindowPos(1), Handle, HWND_TOPMOST, 0, 0, 90, Height, 0);}
  {SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 90, Height, 0);}
  {SetWindowLong(Handle, GWL_STYLE, 0);
    {GetWindowLong(Handle, GWL_STYLE) {or WS_DLGFRAME{WS_POPUP or WS_EX_TOPMOST);}
  {SetWindowLong(Handle, GWL_EXSTYLE,
    GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_TOPMOST);}
  {SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE);}
end;

procedure TWayForm.WayLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
const
  SC_DragMove = $F012;  { a magic number }
begin
  if Button=mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SysCommand, SC_DragMove, 0);
  end
  else
    SetupForm.WayNameLabelClick(Sender);
end;

procedure TWayForm.FormDestroy(Sender: TObject);
begin
  WayForm := nil;
end;

end.
