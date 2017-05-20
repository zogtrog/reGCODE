unit recode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFreCODE }

  TFreCODE = class(TForm)
    lstToken: TListBox;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FreCODE: TFreCODE;

implementation

{$R *.lfm}

{ TFreCODE }

procedure TFreCODE.FormCreate(Sender: TObject);
begin

end;

procedure TFreCODE.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
      application.Terminate;
end;

end.

