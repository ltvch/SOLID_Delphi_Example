program SOLID_Example;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;
//http://blog.muradovm.com/2012/03/solid.html
type
(* Теперь, чтобы сменить способ логирования,
 нужно отправить нужный экземпляр типа ILog
  в конструктор EmailSender. *)

  ILog = interface
    procedure Write(str: String);
  end;

  TConsoleLog = class(TInterfacedObject, ILog)
    procedure Write(str: String);
  end;

  TEmail = class
    fTheme, fFrom, fTo: string;
  public
    property aTheme: string read fTheme write fTheme;
    property aFrom: string read fFrom write fFrom;
    property aTo: string read fTo write fTo;
  end;

  (*EmailSender при помощи метода Send, отправляет сообщения,
  еще и решает как будет вестись лог. В данном примере лог ведется через консоль.
Если случится так, что нам придется менять способ логирования, то мы будем вынуждены внести правки в класс EmailSender. Хотя, казалось бы, эти правки не касаются отправки сообщений. Очевидно, EmailSender выполняет несколько обязанностей и, чтобы класс не был привязан только к одному способу вести лог, нужно вынести выбор лога из этого класса.*)

  TEmailSender = class
  flog: ILog;
  public
    procedure Send(email: TEmail);
    constructor Create(log: ILog);
  end;

{ TEmailSender }

constructor TEmailSender.Create(log: ILog);
begin
  flog:= log;
end;

procedure TEmailSender.Send(email: TEmail);
begin
  flog.Write('Email from ' + email.fFrom + ' to ' + email.fTo + ' was send.');
end;

var
  e1, e2, e3, e4, e5: TEmail;
  es: TEmailSender;

{ TConsoleLog }

procedure TConsoleLog.Write(str: String);
begin
  WriteLn(str);
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    e1 := TEmail.Create;
    e1.fFrom := 'Me';
    e1.fTo := 'Vasya';
    e1.fTheme := 'Who are you?';

    e2 := TEmail.Create;
    e2.fFrom := 'Vasya';
    e2.fTo := 'Me';
    e2.fTheme := 'Buy vacuum cleaners!';

    e3 := TEmail.Create;
    e3.fFrom := 'Kolya';
    e3.fTo := 'Me';
    e3.fTheme := 'Buy coffe mashine!';

    e4 := TEmail.Create;
    e4.fFrom := 'Me';
    e4.fTo := 'Kolya';
    e4.fTheme := 'Yes, give me two!';

    e5 := TEmail.Create;
    e5.fFrom := 'Me';
    e5.fTo := 'Vasya';
    e5.fTheme := 'No, Thanks!';

    es := TEmailSender.Create(TConsoleLog.Create);
    es.Send(e1);
    es.Send(e2);
    es.Send(e3);
    es.Send(e4);
    es.Send(e5);

    WriteLn(#13#10+'Press any key to continue...');
    ReadLn;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;

end.
