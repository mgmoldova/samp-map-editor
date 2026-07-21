unit u_advedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, SynEdit, SynMemo;

type
  Twnd_advinfo = class(TForm)
    Edit1: TEdit;
    list_dfftextures: TSynMemo;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    txdtextures: TSynMemo;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    Label6: TLabel;
    Edit4: TEdit;
    labelother: TLabel;
    ideflags: TCheckListBox;
    Label7: TLabel;
    extras: TSynMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure list_dfftexturesClick(Sender: TObject);
    procedure list_dfftexturesChange(Sender: TObject);
  private
    FMaterialsButton: TButton;
    procedure MaterialsClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  wnd_advinfo: Twnd_advinfo;

implementation

uses u_edit, u_materials, u_Objects;

{$R *.dfm}

constructor Twnd_advinfo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FMaterialsButton := TButton.Create(Self);
  FMaterialsButton.Parent := Self;
  FMaterialsButton.Caption := 'Materials...';
  FMaterialsButton.Left := 8;
  FMaterialsButton.Top := ClientHeight - 36;
  FMaterialsButton.Width := 96;
  FMaterialsButton.Height := 25;
  FMaterialsButton.Anchors := [akLeft, akBottom];
  FMaterialsButton.OnClick := MaterialsClick;
end;

procedure Twnd_advinfo.MaterialsClick(Sender: TObject);
var
  txdnames, texturenames: TStringList;
  imgidx, itemidx: integer;
begin
  if (selipl < 0) or (selipl > high(city.IPL)) or
     (selitem < 0) or (selitem > high(city.IPL[selipl].InstObjects)) then
    exit;

  txdnames := TStringList.Create;
  texturenames := TStringList.Create;
  try
    txdnames.Sorted := True;
    txdnames.Duplicates := dupIgnore;

    for imgidx := 0 to high(city.imglist) do
      if city.imglist[imgidx] <> nil then
        for itemidx := 0 to city.imglist[imgidx].Count - 1 do
          if SameText(ExtractFileExt(city.imglist[imgidx][itemidx]), '.txd') then
            txdnames.Add(ChangeFileExt(city.imglist[imgidx][itemidx], ''));

    texturenames.Assign(txdtextures.Lines);

    if wnd_materials = nil then
      wnd_materials := Twnd_materials.Create(Application);
    wnd_materials.Execute(city.IPL[selipl].InstObjects[selitem], txdnames, texturenames);
    gtaeditor.mapedited;
  finally
    texturenames.Free;
    txdnames.Free;
  end;
end;

procedure Twnd_advinfo.BitBtn1Click(Sender: TObject);
begin
hide;
end;

procedure Twnd_advinfo.list_dfftexturesClick(Sender: TObject);
var
	line: integer;
begin
	Line := Perform(EM_LINEFROMCHAR, 0, 0) ;
end;

procedure Twnd_advinfo.list_dfftexturesChange(Sender: TObject);
begin
//list_dfftextures.Lines[list_dfftextures.CaretY]
end;

end.
