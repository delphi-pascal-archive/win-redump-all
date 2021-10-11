unit Unit_main_redump_all;

//Écrit par denis bertin - a file dump - 04.08.2009.
//Pour afficher le contenue mémoire d'un fichier en hexadécimal.
//Version_2 ajustement des ascenseurs.
//This pretty code for inspect even ascii or binary data file.
//Eventualy change a caractère in file an allow to save the file.
//modifié aussi pour cliquer aussi sur les caractères.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    ScrollBar1: TScrollBar;
    Label1: TLabel;
    BitBtn_save: TBitBtn;
    SaveDialog1: TSaveDialog;
    BitBtn_rechercher: TBitBtn;
    BitBtn_About: TBitBtn;
    BitBtn_suivant: TBitBtn;
    BitBtn_Ouvrir: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure BitBtn_saveClick(Sender: TObject);
    procedure BitBtn_rechercherClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure BitBtn_AboutClick(Sender: TObject);
    procedure BitBtn_suivantClick(Sender: TObject);
    procedure BitBtn_OuvrirClick(Sender: TObject);
  private
    { Déclarations privées }
    k_file_open:boolean;
    k_file_change:boolean;
    a_big_mem:pointer;
    size: Longint;
    pointer_occurence_suivante:pchar;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses math,Unit_change_a_caractere,Unit_find_a_string,Unit_about_help;

const ks_Redump_All = 'Win Redump All';

{lit le fichier dansd un tampon}
procedure TForm1.FormActivate(Sender: TObject);
begin
k_file_open:=false;
k_file_change:=false;
a_big_mem:=nil;
self.ScrollBar1.Visible:=false;
self.BitBtn_save.enabled:=false;
self.BitBtn_rechercher.enabled:=false;
self.pointer_occurence_suivante:=nil;
self.BitBtn_suivant.Enabled:=false;
end;

function Hexbyte(b:byte):string;
	const hexChars: array [0..$F] of Char='0123456789ABCDEF';
	begin
	hexbyte:=hexChars[(b shr 4) and $F]+hexChars[b and $F];
	end;

function  HexWord(w: Word):string;
	begin
	hexword:=hexbyte(hi(w))+hexbyte(lo(w));
	end;

function Hexlongint(long: longint):string;
	begin
	Hexlongint:=hexword(long shr 16)+hexword(long and $ffff)
	end;

procedure TForm1.FormPaint(Sender: TObject);
var i,posx,posxx,posy:integer;
    achar:char;
    p:pchar;
    s:string;
    depart:integer;
    count_line_show:integer;
begin
self.Canvas.Brush.Color:=rgb(255,255,255);
self.Canvas.rectangle(-1,-1,700,500);
if k_file_open then
  begin
  posx:=60;
  posxx:=500;
  posy:=0;
  p:=a_big_mem;
  depart:=(ScrollBar1.position div 16)*16;
  inc(p,depart);
  count_line_show:=0;
  for i:=depart to pred(size) do
    begin
    inc(count_line_show);
    if i mod 16 = 0 then
      begin {en-tête de ligne}
      s:=Hexlongint(i);
      self.Canvas.textout(0,posy,s);
      end;  {en-tête de ligne}
    achar:=char(p^);
    s:=Hexbyte(ord(achar));
    self.Canvas.textout(posx,posy,s);
    inc(posx,24);
    s:=char(p^);
    self.Canvas.textout(posxx,posy,s);
    inc(posxx,12);
    if succ(i) mod 16 = 0 then
      begin
      posx:=60;
      posxx:=500;
      inc(posy,20);
      end;
    inc(p);
    if count_line_show>=16*32 then
      exit;
    end;
  end;
end; {TForm1.FormPaint}

procedure TForm1.ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
invalidaterect(self.handle,nil,false);
end;

procedure TForm1.FormClick(Sender: TObject);
  var i,count_line_show,posx,posxx,posy:integer;
      p:pchar;
      depart:integer;
      apoint_souris:tpoint;
      arect_in_mouse:trect;
      s,ss:string;
      old_cursor:hcursor;
      bool_trouver:boolean;
      pc:array[0..100] of char;
  begin
  old_cursor:=setcursor(LoadCursor(hinstance,IDC_WAIT));
  Getcursorpos(apoint_souris);
  Windows.ScreenToClient(self.handle,apoint_souris);

  if k_file_open then
    begin
    posx:=60;
    posxx:=500;
    posy:=0;
    p:=a_big_mem;
    depart:=(ScrollBar1.position div 16)*16;
    inc(p,depart);
    count_line_show:=0;
    for i:=depart to pred(size) do
      begin
      inc(count_line_show);
      if i mod 16 = 0 then begin end;
                                                 
      s:=char(p^);
      self.Canvas.textout(posxx,posy,s);

      {initialisation du rectangle des hexadécimaux}
      with arect_in_mouse do
        begin
        left:=posx;
        right:=left+20;
        top:=posy;
        bottom:=top+20;
        end;

      bool_trouver:=false;

      {rechercher parmis les codes hexas}
      if ptinrect(arect_in_mouse,apoint_souris) then
        bool_trouver:=true;

      {initialisation du rectangle des caractères}
      with arect_in_mouse do
        begin
        left:=posxx;
        right:=left+12;
        top:=posy;
        bottom:=top+20;
        end;

      {rechercher parmis les caractères}
      if ptinrect(arect_in_mouse,apoint_souris) then
        bool_trouver:=true;

      {dans le cas des caractères ou des hexadécimaux}
      if bool_trouver then
        begin {car-hexa-found}
        //strpcopy(pc,s);
        //application.messagebox(pc,'0');
        Unit_change_a_caractere.Form_change_a_char.Edit_change.text:=s;
        if Unit_change_a_caractere.Form_change_a_char.ShowModal=id_ok then
          begin {OK}
          ss:=Unit_change_a_caractere.Form_change_a_char.Edit_change.text;
          p^:=ss[1];
          invalidaterect(self.handle,nil,false);
          k_file_change:=true;
          BitBtn_save.enabled:=true;
          end;  {OK}
        end; {car-hexa-found}

      inc(posx,24);
      inc(posxx,12);

      if succ(i) mod 16 = 0 then
        begin
        posx:=60;
        posxx:=500;
        inc(posy,20);
        end;
      if count_line_show>=16*32 then
        exit;
      inc(p);
      end; {for i}
    end {k_file_open}
  else
    messagebeep(0);
  setcursor(old_cursor);
  end;


{Cette méthode pour enregistrer un fichier une fois
qu'une modification au moins à été faite, s'active dans ce cas.}
procedure TForm1.BitBtn_saveClick(Sender: TObject);
var f: file of Byte;
    number_write:integer;
begin
if self.k_file_change then
  begin
  SaveDialog1.InitialDir:=OpenDialog1.InitialDir;
  SaveDialog1.filename:=OpenDialog1.filename;
  if SaveDialog1.Execute then
    begin
    AssignFile(f, SaveDialog1.FileName);
    Rewrite(f);
    try
      BlockWrite(F,a_big_mem^, size-1, number_write);
      if number_write=size-1 then
        application.MessageBox('Enregistrement ok','Redump All');
    finally
      CloseFile(f);
      end; {try}
    end;
  end
else
  messagebeep(0);
end;

procedure TForm1.BitBtn_rechercherClick(Sender: TObject);
var i:integer;
    chaine_a_rechercher:string;
    pc_en_cours,pc_chaine:pchar;
    c,d:char;
    ok_found_une_occurence,ok:boolean;
    offset:integer;
begin
if Unit_find_a_string.Form_rechercher.ShowModal=id_ok then
  begin {open_dial}
  offset:=0;
  chaine_a_rechercher:=Unit_find_a_string.Form_rechercher.Edit_chaine_a_rechercher.Text;
  pc_en_cours:=a_big_mem;
  ok_found_une_occurence:=false;
  while (pc_en_cours^<>#0) and not ok_found_une_occurence do
    begin
    inc(offset);
    ok:=true;
    pc_chaine:=pc_en_cours;
    {comparaison d'une chaine string avec un tampon}
    for i:=1 to length(chaine_a_rechercher) do
      begin
      if ok then
        begin
        c:=chaine_a_rechercher[i];
        d:=pc_chaine^;
        inc(pc_chaine);
        if c<>d then ok:=false;
        end;
      end; {for}
    if ok then
      begin
      ScrollBar1.Position:=offset;
      invalidaterect(self.Handle,nil,false);
      //application.messagebox('Chaine trouvée!','Redump all');
      ok_found_une_occurence:=true;
      pointer_occurence_suivante:=pc_en_cours;
      inc(pointer_occurence_suivante);
      self.BitBtn_suivant.Enabled:=True;
      end;
    inc(pc_en_cours);
    end; {while}
  end; {open_dial}
end;

procedure TForm1.BitBtn_AboutClick(Sender: TObject);
begin
Unit_about_help.Form_About_help.ShowModal;
end;

procedure TForm1.BitBtn_suivantClick(Sender: TObject);
  var i:integer;
      offset:integer;
      chaine_a_rechercher:string;
      pc_chaine,pc_en_cours,pc_fin_du_fichier:pchar;
      ok,ok_found_une_occurence:boolean;
      c,d:char;
  begin
  offset:=0;
  chaine_a_rechercher:=Unit_find_a_string.Form_rechercher.Edit_chaine_a_rechercher.Text;
  pc_en_cours:=a_big_mem;
  {while repartir du suivant}
  while (pc_en_cours^<>#0) and (pc_en_cours<>pointer_occurence_suivante) do
    begin {while repartir du suivant}
    inc(pc_en_cours);
    inc(offset);
    end; {while repartir du suivant}
  ok_found_une_occurence:=false;
  while (pc_en_cours^<>#0) and not ok_found_une_occurence do
    begin
    ok:=true;
    pc_chaine:=pc_en_cours;
    {comparaison d'une chaine string avec un tampon}
    for i:=1 to length(chaine_a_rechercher) do
      begin
      if ok then
        begin
        c:=chaine_a_rechercher[i];
        d:=pc_chaine^;
        inc(pc_chaine);
        if c<>d then ok:=false;
        end;
      end; {for}
    if ok then
      begin
      ScrollBar1.Position:=offset;
      invalidaterect(self.Handle,nil,false);
      //application.messagebox('Chaine trouvée!','Redump all');
      ok_found_une_occurence:=true;
      pointer_occurence_suivante:=pc_en_cours;
      inc(pointer_occurence_suivante);
      self.BitBtn_suivant.Enabled:=True;
      end;
    inc(pc_en_cours);
    inc(offset);
    end;
  {Est-ce qu'il faut repartir du début ?}
  pc_fin_du_fichier:=pc_en_cours;
  if pc_fin_du_fichier^=#0 then
    begin {repartir du début}
    pointer_occurence_suivante:=a_big_mem;
    self.BitBtn_suivantClick(sender);
    end;  {repartir du début}
  end;

procedure TForm1.BitBtn_OuvrirClick(Sender: TObject);
var un_file_stream:TFileStream;
    apc_filename:array[00..1024] of char;
    iFileHandle,iBytesRead: Integer;
    apc,bpc:array[00..1024] of char;
begin
if OpenDialog1.execute then
  begin
  k_file_open:=true;
  if fileexists(OpenDialog1.filename) then
    begin
    //obtenir la taille du fichier
    try
      iFileHandle := FileOpen(OpenDialog1.FileName, fmOpenRead or fmShareCompat);
      self.size := FileSeek(iFileHandle,0,2);
      getmem(a_big_mem,succ(self.size));
      FileClose(iFileHandle);
    except
      on EInOutError do
        begin
        application.MessageBox('Erreur de lecture',ks_Redump_All)
        end;
      on EFopenerror do
        begin
        application.MessageBox('Erreur de lecture',ks_Redump_All)
        end;
      on E: Exception do
        application.MessageBox(strpcopy(apc,E.Message), strpcopy(bpc,inttostr(E.HelpContext)));
      end;
    if iFileHandle<>-1 then
      begin //lire le fichier avec un TFileStream
      try
        un_file_stream:=TFileStream.Create(OpenDialog1.FileName, fmOpenRead or fmShareCompat);
        un_file_stream.ReadBuffer(a_big_mem^,self.size);
        ScrollBar1.Visible:=true;
        ScrollBar1.min:=0;
        ScrollBar1.position:=0;
        ScrollBar1.max:=size;
        ScrollBar1.SmallChange:=16;
        ScrollBar1.LargeChange:=16*20;
        self.BitBtn_rechercher.enabled:=true;
        SetWindowText(self.handle,StrPcopy(apc_filename,ks_Redump_All+':'+OpenDialog1.FileName));
        self.pointer_occurence_suivante:=nil;
        self.BitBtn_suivant.Enabled:=false;
      finally
        un_file_stream.free;
        end; {try}
      end {if iFileHandle<>-1} //lire le fichier avec un TFileStream
    else
      application.MessageBox(strpcopy(apc,'Erreur de lecture du fichier :"'
        +OpenDialog1.filename+'"'),ks_Redump_All);
    end; {file_exist}
  InvalidateRect(self.Handle,nil,false);
  end;
end; {TForm1.BitBtn_openfileClick}

end.
