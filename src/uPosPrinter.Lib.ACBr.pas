unit uPosPrinter.Lib.ACBr;

interface

uses
  uPosPrinter.Lib.Interfaces,
  uPosPrinter.Lib.Param,
  uPosPrinter.Lib.Types,
  ACBrBase,
  ACBrPosPrinter,
  System.Classes;

type
  TPosPrinterLibACBr = class(TInterfacedObject, IPosPrinterLib)
  private
    FParam: TPosPrinterLibParam;
    FACBrPosPrinter: TACBrPosPrinter;
    FBuffer: TStringList;

    function ActivePosPrinter: IPosPrinterLib;
    function SetUpPosPrinter: IPosPrinterLib;
    function CleanBuffer: IPosPrinterLib;
    function AddTextHeaderInBuffer: IPosPrinterLib;
    function AddTextFooterInBuffer: IPosPrinterLib;
    function AddTextContentInBuffer(AContent: TStringList): IPosPrinterLib;
    function AddBlankLinesToEnd: IPosPrinterLib;
    function SetFontToBuffer: IPosPrinterLib;
    function CheckIfIgnoresTags: IPosPrinterLib;
    function GetPrinterIndexByName(AName: String; ASimilarName: Boolean = False): Integer;
    function GetPrinterNameBySimilarName(ASimilarName: String): String;

    constructor Create;
    destructor Destroy; override;
  public
    class function Make: IPosPrinterLib;

    function Param: TPosPrinterLibParam;
    function PrintContent(AContent: TStringList; ACopies: SmallInt): IPosPrinterLib;
    function LoadPorts(AStrings: TStrings): IPosPrinterLib;
  end;

implementation

uses
  System.SysUtils,
  Printers;

{ TPosPrinterLibACBr }

function TPosPrinterLibACBr.ActivePosPrinter: IPosPrinterLib;
begin
  Result := Self;

  if FACBrPosPrinter.Ativo then
    Exit;

  // Configurar componente e ativar
  SetUpPosPrinter;
  FACBrPosPrinter.Ativar;
end;

function TPosPrinterLibACBr.AddBlankLinesToEnd: IPosPrinterLib;
var
  lI: Integer;
begin
  Result := Self;

  // Pular Linhas (Finalização de Impressão)
  for lI := 0 to Pred(FParam.blank_lines_to_end) do
    FBuffer.Add(' ');
end;

function TPosPrinterLibACBr.AddTextContentInBuffer(AContent: TStringList): IPosPrinterLib;
begin
  Result := Self;
  FBuffer.Add(AContent.Text);
end;

function TPosPrinterLibACBr.AddTextFooterInBuffer: IPosPrinterLib;
begin
  Result := Self;
end;

function TPosPrinterLibACBr.AddTextHeaderInBuffer: IPosPrinterLib;
begin
  Result := Self;
end;

function TPosPrinterLibACBr.CheckIfIgnoresTags: IPosPrinterLib;
var
  lI: Integer;
begin
  Result := Self;

  // Ignorar Tags
  if FParam.flg_ignore_tags or (FParam.model in [ppmCanvas]) then
  begin
    for lI := 0 to Pred(FBuffer.Count) do
    Begin
      FBuffer[lI] := StringReplace(FBuffer[lI], '<c>',   '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</c>',  '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '<e>',   '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</e>',  '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '<n>',   '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</n>',  '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '<ae>',  '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</ae>', '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '<fa>',  '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</fa>', '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '<fn>',  '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</fn>', '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '<a>',   '', [rfReplaceAll]);
      FBuffer[lI] := StringReplace(FBuffer[lI], '</a>',  '', [rfReplaceAll]);
    End;
  end;
end;

function TPosPrinterLibACBr.CleanBuffer: IPosPrinterLib;
begin
  Result := Self;
  FBuffer.Clear;
end;

constructor TPosPrinterLibACBr.Create;
begin
  FParam                               := TPosPrinterLibParam.Create;
  FACBrPosPrinter                      := TACBrPosPrinter.Create(nil);
  FACBrPosPrinter.Device.NomeDocumento := 'PosPrinter';
  FBuffer                              := TStringList.Create;
end;

destructor TPosPrinterLibACBr.Destroy;
begin
  if Assigned(FParam)          then FParam.Free;
  if Assigned(FACBrPosPrinter) then FACBrPosPrinter.Free;
  if Assigned(FBuffer)         then FBuffer.Free;
  inherited;
end;

function TPosPrinterLibACBr.GetPrinterIndexByName(AName: String; ASimilarName: Boolean): Integer;
Var
  I: Integer;
  lPrinterFound: Boolean;
Begin
  Result := -1;
  Try
    for I := 0 to Pred(Printer.Printers.Count) do
    Begin
      case ASimilarName of
        True:  lPrinterFound := (Pos(AName.ToUpper, Printer.printers[i].ToUpper) > 0);
        False: lPrinterFound := UpperCase(Printer.printers[i]) = UpperCase(AName);
      end;

      if lPrinterFound then
      begin
        Result := I;
        Break;
      end;
    end;
  Except
  End;
End;

function TPosPrinterLibACBr.GetPrinterNameBySimilarName(ASimilarName: String): String;
Var
  lI: Integer;
  lPrinterFound: Boolean;
Begin
  Result := '';
  Try
    for lI := 0 to Pred(Printer.Printers.Count) do
    Begin
      lPrinterFound := (Pos(ASimilarName.ToUpper, Printer.printers[lI].ToUpper) > 0);
      if lPrinterFound then
      begin
        Result := Printer.Printers[lI];
        Break;
      end;
    end;
  Except
  End;
End;

function TPosPrinterLibACBr.LoadPorts(AStrings: TStrings): IPosPrinterLib;
var
  lI: Integer;
begin
  Result := Self;

  if not Assigned(AStrings) then
    raise Exception.Create('AStrings is not assigned');

  AStrings.BeginUpdate;
  Try
    AStrings.Clear;
    FACBrPosPrinter.Device.AcharPortasSeriais(AStrings);
    For lI := 0 to Printer.Printers.Count-1 do
      AStrings.Add(Printer.Printers[lI]);
  Finally
    AStrings.EndUpdate;
  End;
end;

class function TPosPrinterLibACBr.Make: IPosPrinterLib;
begin
  Result := Self.Create;
end;

function TPosPrinterLibACBr.Param: TPosPrinterLibParam;
begin
  Result := FParam;
end;

function TPosPrinterLibACBr.PrintContent(AContent: TStringList; ACopies: SmallInt): IPosPrinterLib;
var
  lCanvasFile: TextFile;
  lI: Integer;
  ACopyNum: Integer;
begin
  Result := Self;

  // Ativar PosPrinter
  ActivePosPrinter;

  // Abrir Gaveta
  if FParam.is_open_cash_drawer then
    FACBrPosPrinter.Imprimir('</abre_gaveta>');

  for ACopyNum := 0 to Pred(ACopies) do
  begin
    // Preparar Buffer para Impressão
    CleanBuffer;
    AddTextHeaderInBuffer;
    AddTextContentInBuffer(AContent);
    AddTextFooterInBuffer;
    AddBlankLinesToEnd;
    SetFontToBuffer;
    CheckIfIgnoresTags;

    // Modo de Impressão em Cavas
    if (FParam.model = ppmCanvas) then
    Begin
      Try
        Printer.PrinterIndex     := GetPrinterIndexByName(FParam.port, true);
        Printer.Canvas.Font.Name := 'Lucida Console';
        Printer.Canvas.Font.Size := 8;
        AssignPrn(lCanvasFile);
        Rewrite(lCanvasFile);
        for lI := 0 to Pred(FBuffer.Count) do
          Writeln(lCanvasFile, FBuffer[lI]);
      Finally
        System.CloseFile(lCanvasFile);
      End;
    end;

    // Modo de Impressão comum
    if not (FParam.model in [ppmCanvas]) then
    begin
      // Conteúdo da impressão
      FACBrPosPrinter.Buffer.Text := FBuffer.Text;

      // Cortar papel por escrita
      if (FParam.flg_paper_cut and FParam.flg_send_cut_written_command) then
      begin
        case FParam.flg_partial_paper_cut of
          True:   FACBrPosPrinter.Buffer.Add('</corte_parcial>');
          False:  FACBrPosPrinter.Buffer.Add('</corte_total>');
        end;
      end;

      // Imprime e zerar caracteres especiais, evita erro
      FACBrPosPrinter.Zerar;

      // Sem necessidade por enquanto. Se tiver problemas de formatação na impressão ou impressora travando.
      // Ative a configuração controle porta
      // Desativar e Inicializar - Isso evita que algumas impressoras travem
      // FACBrPosPrinter.Desativar;
      // FACBrPosPrinter.Inicializar;

      // Cortar papel
      if (FParam.flg_paper_cut and (FParam.flg_send_cut_written_command = false)) then
        FACBrPosPrinter.CortarPapel(FParam.flg_partial_paper_cut);
    end;  
  end;
end;

function TPosPrinterLibACBr.SetFontToBuffer: IPosPrinterLib;
begin
  case FParam.font_size of
    0,1: FBuffer.Text := '</ae></fa></fn>'        + FBuffer.Text; // Normal
    2:   FBuffer.Text := '</ae></fa></fn><e>'     + FBuffer.Text; // Condensada
    3:   FBuffer.Text := '</ae></fa></fn></e><c>' + FBuffer.Text; // Condensada 2 Linhas
  end;
end;

function TPosPrinterLibACBr.SetUpPosPrinter: IPosPrinterLib;
begin
  Result := Self;

  // Configuração de ACBrPosPrinter
  FACBrPosPrinter.Modelo                     := TACBrPosPrinterModelo(Ord(FParam.model));
  FACBrPosPrinter.Porta                      := 'RAW:' +  GetPrinterNameBySimilarName(FParam.port);
  FACBrPosPrinter.LinhasBuffer               := FParam.buffer;
  FACBrPosPrinter.EspacoEntreLinhas          := FParam.space_between_lines;
  FACBrPosPrinter.ColunasFonteNormal         := FParam.columns;
  FACBrPosPrinter.ControlePorta              := FParam.flg_port_control;
  FACBrPosPrinter.CortaPapel                 := FParam.flg_paper_cut;
  FACBrPosPrinter.TraduzirTags               := FParam.flg_translate_tags;
  FACBrPosPrinter.IgnorarTags                := FParam.flg_ignore_tags;
  FACBrPosPrinter.PaginaDeCodigo             := TACBrPosPaginaCodigo(Ord(FParam.page_code));
  FACBrPosPrinter.ConfigBarras.MostrarCodigo := False;
  FACBrPosPrinter.ConfigBarras.LarguraLinha  := 1;
  FACBrPosPrinter.ConfigBarras.Altura        := 0;
  FACBrPosPrinter.ConfigQRCode.Tipo          := 2;
  FACBrPosPrinter.ConfigQRCode.LarguraModulo := 4;
  FACBrPosPrinter.ConfigQRCode.ErrorLevel    := 0;
  FACBrPosPrinter.ConfigLogo.KeyCode1        := 32;
  FACBrPosPrinter.ConfigLogo.KeyCode2        := 32;
  FACBrPosPrinter.ConfigLogo.FatorX          := 4;
  FACBrPosPrinter.ConfigLogo.FatorY          := 4;
end;

end.
