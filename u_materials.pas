unit u_materials;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls, Buttons,
  u_Objects;

type
  Twnd_materials = class(TForm)
    lb_materials: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    inp_index: TEdit;
    inp_model: TEdit;
    cb_txd: TComboBox;
    cb_texture: TComboBox;
    inp_color: TEdit;
    btn_add: TButton;
    btn_delete: TButton;
    btn_apply: TButton;
    btn_close: TButton;
    procedure lb_materialsClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_applyClick(Sender: TObject);
    procedure btn_closeClick(Sender: TObject);
  private
    FInstance: TINST;
    procedure RefreshList;
    procedure LoadSelected;
    function ParseColor(const value: string; var color: longword): boolean;
  public
    function Execute(instance: TINST; txdnames, texturenames: TStrings): boolean;
  end;

var
  wnd_materials: Twnd_materials;

implementation

{$R *.dfm}

function Twnd_materials.ParseColor(const value: string; var color: longword): boolean;
var
  parsed: int64;
  text: string;
begin
  text := trim(value);
  if text = '' then
    text := '0';

  if lowercase(copy(text, 1, 2)) = '0x' then
    text := '$' + copy(text, 3, length(text) - 2);

  try
    parsed := StrToInt64(text);
    color := longword(parsed);
    Result := True;
  except
    Result := False;
  end;
end;

procedure Twnd_materials.RefreshList;
var
  i: integer;
begin
  lb_materials.Items.BeginUpdate;
  try
    lb_materials.Items.Clear;
    if FInstance <> nil then
      for i := 0 to high(FInstance.materials) do
        with FInstance.materials[i] do
          lb_materials.Items.Add(format('%d: %s/%s (model %d, color 0x%s)',
            [materialindex, txdname, texturename, modelid, IntToHex(materialcolor, 8)]));
  finally
    lb_materials.Items.EndUpdate;
  end;

  if lb_materials.Items.Count > 0 then
  begin
    lb_materials.ItemIndex := 0;
    LoadSelected;
  end;
end;

procedure Twnd_materials.LoadSelected;
var
  material: TObjectMaterial;
begin
  if (FInstance = nil) or (lb_materials.ItemIndex < 0) or
     (lb_materials.ItemIndex > high(FInstance.materials)) then
    exit;

  material := FInstance.materials[lb_materials.ItemIndex];
  inp_index.Text := IntToStr(material.materialindex);
  inp_model.Text := IntToStr(material.modelid);
  cb_txd.Text := material.txdname;
  cb_texture.Text := material.texturename;
  inp_color.Text := '0x' + IntToHex(material.materialcolor, 8);
end;

function Twnd_materials.Execute(instance: TINST; txdnames, texturenames: TStrings): boolean;
begin
  FInstance := instance;
  cb_txd.Items.Assign(txdnames);
  cb_texture.Items.Assign(texturenames);
  RefreshList;
  Result := ShowModal = mrOk;
end;

procedure Twnd_materials.lb_materialsClick(Sender: TObject);
begin
  LoadSelected;
end;

procedure Twnd_materials.btn_addClick(Sender: TObject);
var
  material: TObjectMaterial;
begin
  if FInstance = nil then
    exit;

  material := FInstance.AddMaterial;
  material.modelid := FInstance.id;
  material.materialindex := length(FInstance.materials) - 1;
  RefreshList;
  lb_materials.ItemIndex := high(FInstance.materials);
  LoadSelected;
end;

procedure Twnd_materials.btn_deleteClick(Sender: TObject);
begin
  if (FInstance = nil) or (lb_materials.ItemIndex < 0) then
    exit;

  FInstance.DeleteMaterial(lb_materials.ItemIndex);
  RefreshList;
end;

procedure Twnd_materials.btn_applyClick(Sender: TObject);
var
  material: TObjectMaterial;
  color: longword;
  index, modelid: integer;
  warning: string;
begin
  if (FInstance = nil) or (lb_materials.ItemIndex < 0) or
     (lb_materials.ItemIndex > high(FInstance.materials)) then
    exit;

  index := StrToIntDef(inp_index.Text, 0);
  modelid := StrToIntDef(inp_model.Text, FInstance.id);

  if not ParseColor(inp_color.Text, color) then
  begin
    MessageDlg('Material color must be a decimal value or ARGB value such as 0xFFAABBCC.', mtError, [mbOK], 0);
    exit;
  end;

  warning := '';
  if (index < 0) or (index > 15) then
    warning := warning + 'Material index is outside the usual 0..15 range.' + #13#10;
  if trim(cb_txd.Text) = '' then
    warning := warning + 'TXD name is empty.' + #13#10
  else if cb_txd.Items.IndexOf(cb_txd.Text) = -1 then
    warning := warning + 'TXD was not found in the loaded IMG archives.' + #13#10;
  if trim(cb_texture.Text) = '' then
    warning := warning + 'Texture name is empty.' + #13#10
  else if cb_texture.Items.IndexOf(cb_texture.Text) = -1 then
    warning := warning + 'Texture was not found in the currently loaded model TXD.' + #13#10;

  if (warning <> '') and
     (MessageDlg(warning + #13#10 + 'Apply anyway?', mtWarning, [mbYes, mbNo], 0) <> mrYes) then
    exit;

  material := FInstance.materials[lb_materials.ItemIndex];
  material.materialindex := index;
  material.modelid := modelid;
  material.txdname := trim(cb_txd.Text);
  material.texturename := trim(cb_texture.Text);
  material.materialcolor := color;
  RefreshList;
end;

procedure Twnd_materials.btn_closeClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
