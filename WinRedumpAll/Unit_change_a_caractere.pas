unit Unit_change_a_caractere;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm_change_a_char = class(TForm)
    Edit_change: TEdit;
    Button_change: TButton;
    procedure Edit_changeChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button_changeClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form_change_a_char: TForm_change_a_char;

implementation

{$R *.dfm}

procedure TForm_change_a_char.Edit_changeChange(Sender: TObject);
begin
Button_change.Enabled:=true;
end;

procedure TForm_change_a_char.FormActivate(Sender: TObject);
begin
Button_change.Enabled:=false;
end;

procedure TForm_change_a_char.Button_changeClick(Sender: TObject);
begin
postmessage(self.Handle,wm_command,id_ok,0);
end;

end.
