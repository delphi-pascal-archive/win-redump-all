program Project_redump_all;

uses
  Forms,
  Unit_main_redump_all in 'Unit_main_redump_all.pas' {Form1},
  Unit_change_a_caractere in 'Unit_change_a_caractere.pas' {Form_change_a_char},
  Unit_find_a_string in 'Unit_find_a_string.pas' {Form_rechercher},
  Unit_about_help in 'Unit_about_help.pas' {Form_About_help};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm_change_a_char, Form_change_a_char);
  Application.CreateForm(TForm_rechercher, Form_rechercher);
  Application.CreateForm(TForm_About_help, Form_About_help);
  Application.Run;
end.
