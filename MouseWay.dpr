{******************************************************************}
{                                                                  }
{ 2003(fw) Ironsoft Lab, Perm, Russia                              }
{ http://ironsite.narod.ru                                         }
{ Written by Iron (Michael Galyuk), ironsoft@mail.ru               }
{                                                                  }
{ Код распространяется на правах лицензии GNU GPL                  }
{ При использовании кода ссылка на автора обязательна              }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied.                                                         }
{                                                                  }
{ КОД РАСПРОСТРАНЯЕТСЯ ПО ПРИНЦИПУ "КАК ЕСТЬ", НИКАКИХ             }
{ ГАРАНТИЙ НЕ ПРЕДУСМАТРИВАЕТСЯ, ВЫ ИСПОЛЬЗУЕТЕ ЕГО НА СВОЙ РИСК.  }
{ АВТОР НЕ НЕСЕТ ОТВЕТСТВЕННОСТИ ЗА ПРИЧИНЕННЫЙ УЩЕРБ СВЯЗАННЫЙ    }
{ С ЕГО ИСПОЛЬЗОВАНИЕМ (ПРАВИЛЬНЫМ ИЛИ НЕПРАВИЛЬНЫМ).              }
{                                                                  }
{******************************************************************}

program MouseWay;

uses
  Forms,
  Windows,
  Messages,
  SysUtils,
  SetupFrm in 'SetupFrm.pas' {SetupForm},
  WayFrm in 'WayFrm.pas' {WayForm};

{$R *.RES}

var
  hWnd: Integer;
  Stopping: Boolean;
begin
  Stopping := UpperCase(ParamStr(1))='STOP';
  hWnd := FindWindow('TSetupForm', 'MouseWay 1.2');
  if (hWnd = 0) and not Stopping then
  begin
    Application.Initialize;
    Application.Title := 'MouseWay 1.2';
  Application.CreateForm(TSetupForm, SetupForm);
    Application.ShowMainForm := False;
    Application.Run;
  end
  else
    if Stopping then
    begin
      PostMessage(hWnd, WM_QUIT, 0, 0);
      Sleep(700);
    end
    else
      PostMessage(hWnd, WM_TRAY, TrayIconId, WM_LBUTTONDBLCLK);
end.
