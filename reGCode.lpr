program reGCode;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, recode, substitute,sysutils
  { you can add units after this };

{$R *.res}

var
  FRecode:TFRecode;

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  if ParamCount < 1 then
  begin
    FRecode:=TFRecode.Create(Application);
    FRecode.Show();

  end
  else
  begin
       If ParamCount>2 then
       begin
         try
         writeln('RUNNING ReGCODE post slicer processor');
         writeln('Input file: '+ ParamStr(1));
         writeln('Output file: '+Paramstr(2));
         writeln('Control Directory: '+Paramstr(3));
         subit(ParamStr(1),ParamStr(2),ParamStr(3));
         except
           On E:Exception do
           begin
                writeln('An error occured in the post slicing step '+E.Message);
           end;
         end;
         Application.Terminate;
       end;
  end;
  Application.Run;
end.

