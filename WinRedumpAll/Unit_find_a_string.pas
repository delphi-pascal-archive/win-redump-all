unit Unit_find_a_string;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm_rechercher = class(TForm)
    Edit_chaine_a_rechercher: TEdit;
    Label_chaine_a_rechercher: TLabel;
    BitBtn_chercher: TBitBtn;
    procedure Edit_chaine_a_rechercherChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn_chercherClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form_rechercher: TForm_rechercher;

implementation

{$R *.dfm}
procedure TForm_rechercher.FormCreate(Sender: TObject);
begin
BitBtn_chercher.enabled:=false;
end;

procedure TForm_rechercher.Edit_chaine_a_rechercherChange(Sender: TObject);
var s:string;
begin
s:=Edit_chaine_a_rechercher.text;
BitBtn_chercher.enabled:=length(s)<>0;
end;


procedure TForm_rechercher.BitBtn_chercherClick(Sender: TObject);
begin
postmessage(self.Handle,wm_command,id_ok,0);
end;

end.
