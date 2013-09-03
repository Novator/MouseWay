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

unit SetupFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ShellApi, Spin;

const
  WM_TRAY = WM_USER + 100;
  TrayIconId = 1;

type
  TSetupForm = class(TForm)
    SetupGroupBox: TGroupBox;
    XSizeEdit: TEdit;
    DiagLabel: TLabel;
    DelayLabel: TLabel;
    StatGroupBox: TGroupBox;
    PosNameLabel: TLabel;
    WayLabel: TLabel;
    PosLabel: TLabel;
    ResetBitBtn: TBitBtn;
    ApplyBitBtn: TBitBtn;
    ShowWayCheckBox: TCheckBox;
    ChekTimer: TTimer;
    YSizeEdit: TEdit;
    SepLabel: TLabel;
    DrafeLabel: TLabel;
    WayNamePanel: TPanel;
    DrafeEdit: TSpinEdit;
    DelayEdit: TSpinEdit;
    DateLabel: TLabel;
    FromDateLabel: TLabel;
    procedure ChekTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetBitBtnClick(Sender: TObject);
    procedure ApplyBitBtnClick(Sender: TObject);
    procedure WayNameLabelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure XSizeEditChange(Sender: TObject);
    procedure DelayEditKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDeactivate(Sender: TObject);
    procedure RebuildControls;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WayNamePanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WayNamePanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure WMTray(var Message: TMessage); message WM_TRAY;
    procedure WMCommand(var Message: TMessage); message WM_COMMAND;
    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  SetupForm: TSetupForm;

implementation

uses WayFrm;

{$R *.DFM}

var
  MeraIndex: Byte;
  XS, YS: Integer;
  V: Char = ' ';
  G: Byte = 0;
  Drafe: Byte = 3;
  Dpix: Double = 0.0;
  Dmm: Double = 0.0;
  Lang: Byte = 0;

const
  ID_ExitItem  = 101;
  ID_StateItem = 102;
  ID_AboutItem = 103;
  ID_LangItem  = 104;
  CopyrStr: array[0..108] of Char =
    #169' Ironsoft Lab, 2002'#0#10#174' Programmed by Michael Galyuk'#0
    +'Russia, Perm, ironsoft@mail.ru'#10'http://ironsite.narod.ru'#0;
  AboutCount: Byte = 0;

  MaxLang = 1;
  NumOfLangStr = 16;
  LangStrings: array[0..MaxLang, 0..NumOfLangStr] of PChar =
    (('&Свойства', '&English', '&О программе...', '&Выход',
      'Настройки', 'Статистика', '&Дисплей, мм', '&Задержка, мс',
      'Др&ейф, п', 'Путь', 'Позиция', '&Сброс', '&Применить',
      'По&казывать счетчик', 'м', 'п', 'От'),
     ('&Property', '&Russian', '&About...', '&Exit',
      'Setup', 'Statistics', 'Di&splay, mm', 'D&elay, ms',
      '&Drift, p', 'Way', 'Position', '&Reset', '&Apply',
      'Show &counter', 'm', 'p', 'From')
     );

procedure TSetupForm.RebuildControls;
begin
  SetupGroupBox.Caption   := LangStrings[Lang, 4];
  StatGroupBox.Caption    := LangStrings[Lang, 5];
  DiagLabel.Caption       := LangStrings[Lang, 6];
  DelayLabel.Caption      := LangStrings[Lang, 7];
  DrafeLabel.Caption      := LangStrings[Lang, 8];
  WayNamePanel.Caption    := LangStrings[Lang, 9];
  PosNameLabel.Caption    := LangStrings[Lang, 10];
  ResetBitBtn.Caption     := LangStrings[Lang, 11];
  ApplyBitBtn.Caption     := LangStrings[Lang, 12];
  ShowWayCheckBox.Caption := LangStrings[Lang, 13];
  FromDateLabel.Caption := LangStrings[Lang, 16];
  WayNameLabelClick(nil);
end;

procedure TSetupForm.WMCommand(var Message: TMessage);
begin
  case Message.WParamLo of
    ID_StateItem:
      begin
        SetForegroundWindow(Application.Handle);
        ShowWindow(Application.Handle, SW_SHOWNORMAL);
        {PostMessage(Handle, WM_SHOWWINDOW, SW_SHOWNORMAL, 0);}
        Show;
        ShowWindow(Handle, SW_SHOWNORMAL);
        UpdateWindow(Handle);
      end;
    ID_AboutItem:
       begin
         Inc(AboutCount);
         if AboutCount>3 then
         begin
           CopyrStr[20] := #13;
           AboutCount := 0;
         end
         else
           CopyrStr[20] := #0;
         ShellAbout(Handle, PChar(Application.Title), CopyrStr,
           Application.Icon.Handle);
       end;
    ID_LangItem:
      begin
        if Lang=0 then
          Lang := 1
        else
          Lang := 0;
        RebuildControls;
      end;
    ID_ExitItem:
      Application.Terminate;
  end;
  inherited;
end;

procedure TSetupForm.WMSysCommand(var Message: TMessage);
begin
  if Message.wParam = SC_CLOSE then
  begin
    ShowWindow(Handle, SW_MINIMIZE);
    ShowWindow(Handle, SW_HIDE);
    ShowWindow(Application.Handle, SW_HIDE);
    Message.Result := 0;
  end
  else
    inherited;
end;


var
  NeedUpdateHint: Boolean = False;

procedure TSetupForm.WMTray(var Message: TMessage);
const
  IconSize = 16;
var
  PopMenu: hMenu;
  P: TPoint;
begin
  if Message.WParam = TrayIconId then
  begin
    case Message.LParam of
      WM_MOUSEMOVE:
        NeedUpdateHint := True;
      WM_LBUTTONDBLCLK:
        SendMessage(Handle, WM_COMMAND, ID_StateItem, 0);
      WM_LBUTTONDOWN:
        FormDeactivate(nil);
      WM_RBUTTONDOWN:
        begin
          GetCursorPos(P);
          PopMenu := CreatePopupMenu;
          AppendMenu(PopMenu, MF_ENABLED or MF_STRING, ID_StateItem, LangStrings[Lang, 0]);
          AppendMenu(PopMenu, MF_ENABLED or MF_STRING, ID_LangItem, LangStrings[Lang, 1]);
          AppendMenu(PopMenu, MF_ENABLED or MF_STRING, ID_AboutItem, LangStrings[Lang, 2]);
          AppendMenu(PopMenu, MF_SEPARATOR, 0, nil);
          AppendMenu(PopMenu, MF_ENABLED or MF_STRING, ID_ExitItem, LangStrings[Lang, 3]);
          SetMenuDefaultItem(PopMenu, 0, 1);
          P.X := (P.X div IconSize +1) * IconSize;
          P.Y := (P.Y div IconSize) * IconSize;
          TrackPopupMenu(PopMenu, TPM_HORIZONTAL or TPM_LEFTALIGN, P.X, P.Y,
            0, Handle, nil);
          DestroyMenu(PopMenu);
        end;
    end;
  end;
  inherited;
end;

function TaskBarAddIcon(dwMessage: DWORD; ParentWnd: HWnd; IconId: Cardinal;
  Icon: HIcon; Msg: Cardinal; Tip: PChar): Boolean;
var
  Nid : TNotifyIconData;
begin
  FillChar(Nid, SizeOf(Nid), #0);
  with Nid do
  begin
    cbSize := SizeOf(TNotifyIconData);
    uID := IconId;
    Wnd := ParentWnd;
    if Icon<>0 then
    begin
      hIcon := Icon;
      uFlags := uFlags or NIF_ICON;
    end;
    if Msg<>0 then
    begin
      uCallbackMessage := Msg;
      uFlags := uFlags or NIF_MESSAGE;
    end;
    if Tip<>nil then
    begin
      StrLCopy(szTip, Tip, SizeOf(szTip)-1);
      uFlags := uFlags or NIF_TIP;
    end;
  end;
  Result := Shell_NotifyIcon(dwMessage, @Nid)
end;

procedure TSetupForm.ApplyBitBtnClick(Sender: TObject);
var
  Err: Boolean;
begin
  if Sender<>nil then
    ChekTimer.Enabled := False;
  Err := False;
  try
    XS := StrToInt(XSizeEdit.Text);
    YS := StrToInt(YSizeEdit.Text);
  except
    XS := 320;
    YS := 240;
    MessageBox(Handle, PChar('Размер экрана задан неверно'),
      PChar(Caption), MB_OK or MB_ICONERROR);
    Err := True;
  end;
  try
    ChekTimer.Interval := StrToInt(DelayEdit.Text);
  except
    ChekTimer.Interval := 100;
    MessageBox(Handle, PChar('Интервал задан неверно'),
      PChar(Caption), MB_OK+MB_ICONERROR);
    DelayEdit.Text := IntToStr(ChekTimer.Interval);
    Err := True;
  end;
  try
    Drafe := StrToInt(DrafeEdit.Text);
  except
    Drafe := 3;
    MessageBox(Handle, PChar('Дрейф задан неверно'),
      PChar(Caption), MB_OK+MB_ICONERROR);
    DrafeEdit.Text := IntToStr(Drafe);
    Err := True;
  end;
  if ShowWayCheckBox.Checked then
  begin
    if WayForm=nil then
    begin
      WayForm := TWayForm.Create(Self);
      WayForm.WayLabel.Hint := Caption;
      WayForm.WayLabel.ShowHint := True;
      ChekTimerTimer(nil);
    end;
    TaskBarAddIcon(NIM_MODIFY, Handle, TrayIconId, 0, 0, PChar(Caption))
  end
  else
    WayForm.Free;
  ApplyBitBtn.Enabled := Err;
  if Sender<>nil then
    ChekTimer.Enabled := not Err;
end;

var
  KX, KY: Double;

procedure TSetupForm.ResetBitBtnClick(Sender: TObject);
var
  DC: hDC;
  ATime: TSystemTime;
  I: Integer;
  Buf: array[0..31] of Char;
  S: string;
begin
  if Sender<>nil then
  begin
    Dpix := 0.0;
    Dmm := 0.0;
  end;
  if (Dpix = 0) and (Dmm = 0) then
  begin
    GetLocalTime(ATime);
    I := SizeOf(Buf);
    if GetDateFormat(LOCALE_SYSTEM_DEFAULT, DATE_SHORTDATE, @ATime,
      nil, Buf, I) <> 0
    then
      S := StrPas(Buf)
    else
      S := '';
    if GetTimeFormat(LOCALE_SYSTEM_DEFAULT,
      TIME_FORCE24HOURFORMAT or TIME_NOSECONDS, @ATime,
      nil, Buf, I) <> 0
    then
      S := S + '  ' + StrPas(Buf);
    DateLabel.Caption := S;
  end;
  DC := GetDC(0);
  try
    KX := XS/GetDeviceCaps(DC, HORZRES);
  except
    KX := 96.0;
    MessageBox(Handle, PChar('Ошибка разрешения по X'),
      PChar(Caption), MB_OK or MB_ICONERROR);
  end;
  try
    KY := YS/GetDeviceCaps(DC, VERTRES);
  except
    KY := 96.0;
    MessageBox(Handle, PChar('Ошибка разрешения по Y'),
      PChar(Caption), MB_OK or MB_ICONERROR);
  end;
  ChekTimerTimer(nil);
end;

function IniFileName: string;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

var
  P0: TPoint;

procedure TSetupForm.FormCreate(Sender: TObject);
var
  F: TextFile;
  I, Err: Integer;
  S: string;
begin
  ShowWindow(Application.Handle, SW_HIDE);
  {SetWindowLong(Application.Handle, GWL_EXSTYLE,
    GetWindowLong(Application.Handle, GWL_EXSTYLE) or
    WS_EX_TOOLWINDOW);}
  GetCursorPos(P0);
  MeraIndex := 1;

  AssignFile(F, IniFileName);
  {$I-} Reset(F); {$I+}
  I := IOResult;
  if I=0 then
  begin
    Err := 0;
    while not Eof(F) and (I<=8) do
    begin
      ReadLn(F, S);
      case I of
        0:
          XSizeEdit.Text := S;
        1:
          YSizeEdit.Text := S;
        2:
          DelayEdit.Text := S;
        3:
          DrafeEdit.Text := S;
        4:
          ShowWayCheckBox.Checked := S[1]='1';
        5:
          begin
            Val(S, Dpix, Err);
            if Err<>0 then
              Dpix := 0.0;
          end;
        6:
          if Err=0 then
          begin
            Val(S, Dmm, Err);
            if Err<>0 then
            begin
              Dpix := 0.0;
              Dmm := 0.0;
            end;
          end;
        7:
          begin
            Val(S, Lang, Err);
            if (Err<>0) or (Lang>MaxLang) then
              Lang := 0;
          end;
        8:
          DateLabel.Caption := S;
      end;
      Inc(I);
    end;
    CloseFile(F);
  end;
  ApplyBitBtnClick(nil);
  ResetBitBtnClick(nil);
  RebuildControls;
  ShowWindow(Application.Handle, SW_HIDE);

  Application.ProcessMessages;
  TaskBarAddIcon(NIM_ADD, Handle, TrayIconId,
    Application.Icon.Handle, WM_TRAY, PChar(Caption));
  ChekTimer.Enabled := True;
end;

var
  P: TPoint;
  S: string;
  R: Double;
  Calcing: Boolean = False;

procedure TSetupForm.ChekTimerTimer(Sender: TObject);
begin
  if not Calcing then
  begin
    Calcing := True;
    GetCursorPos(P);
    if (Abs(P.X-P0.X)>Drafe) or (Abs(P.Y-P0.Y)>Drafe) or (Sender=nil) then
    begin
      try
        R := Sqrt(Sqr(P.X-P0.X)+Sqr(P.Y-P0.Y));
      except
        R := 0;
      end;
      Dpix := Dpix + R;
      try
        R := Sqrt(Sqr((P.X-P0.X)*KX)+Sqr((P.Y-P0.Y)*KY))
      except
        R := 0;
      end;
      Dmm  := Dmm +  R;
      case MeraIndex of
        1:
          R := Dmm*0.001;
        2:
          R := Dmm/25.4;
        else
          R := Dpix;
      end;
      Str(R:0:G, S);
      S := S+' '+V;
      WayLabel.Caption := S;
      if WayForm=nil then
      begin
        if NeedUpdateHint then
        begin
          NeedUpdateHint := False;
          TaskBarAddIcon(NIM_MODIFY, Handle, TrayIconId, 0, 0, PChar(S))
        end;
      end
      else
        WayForm.WayLabel.Caption := S;
      PosLabel.Caption := IntToStr(P.X)+':'+IntToStr(P.Y);
      P0 := P;
    end;
    Calcing := False;
  end;
end;

procedure TSetupForm.WayNameLabelClick(Sender: TObject);
begin
  WayNamePanelMouseDown(Sender, mbLeft, [], 0, 0);
end;

procedure TSetupForm.FormDestroy(Sender: TObject);
var
  F: TextFile;
begin
  TaskBarAddIcon(NIM_DELETE, Handle, TrayIconId, 0, 0, nil);
  AssignFile(F, IniFileName);
  {$I-} Rewrite(F); {$I+}
  if IOResult=0 then
  begin
    WriteLn(F, IntToStr(XS));
    WriteLn(F, IntToStr(YS));
    WriteLn(F, IntToStr(ChekTimer.Interval));
    WriteLn(F, IntToStr(Drafe));
    if ShowWayCheckBox.Checked then
      WriteLn(F, '1')
    else
      WriteLn(F, '0');
    WriteLn(F, Dpix);
    WriteLn(F, Dmm);
    WriteLn(F, Lang);
    WriteLn(F, DateLabel.Caption);
    CloseFile(F);
  end;
end;

procedure TSetupForm.XSizeEditChange(Sender: TObject);
begin
  ApplyBitBtn.Enabled := (Length(XSizeEdit.Text)>0)
    and (Length(YSizeEdit.Text)>0);
end;

procedure TSetupForm.DelayEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not ((Key in ['0'..'9']) or (Key < #32)) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
end;

procedure TSetupForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_F1:
      SendMessage(Handle, WM_COMMAND, ID_AboutItem, 0);
    VK_F5:
      SendMessage(Handle, WM_COMMAND, ID_LangItem, 0);
    VK_F2:
      WayNameLabelClick(Sender);
    VK_ESCAPE:
      PostMessage(Handle, WM_SYSCOMMAND, SC_CLOSE, 0);
  end;
end;

procedure TSetupForm.FormDeactivate(Sender: TObject);
begin
  if WayForm<>nil then
    SetWindowPos(WayForm.Handle, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOSIZE + SWP_NOMOVE);
end;

procedure TSetupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSetupForm.WayNamePanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  WayNamePanel.BevelOuter := bvRaised
end;

procedure TSetupForm.WayNamePanelMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then
  begin
    if Sender<>nil then
    begin
      if Sender = WayNamePanel then
        WayNamePanel.BevelOuter := bvLowered;
      if MeraIndex<2 then
        Inc(MeraIndex)
      else
        MeraIndex := 0;
    end;
    case MeraIndex of
      1:
        begin
          V := LangStrings[Lang, 14]^;
          G := 3;
        end;
      2:
        begin
          V := '"';
          G := 2;
        end;
      else
        begin
          V := LangStrings[Lang, 15]^;
          G := 0;
        end;
    end;
    ChekTimerTimer(nil);
  end;
end;

end.
