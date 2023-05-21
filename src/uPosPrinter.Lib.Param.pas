unit uPosPrinter.Lib.Param;

interface

uses
  uPosPrinter.Lib.Types;

type
  // Parâmetros de Configuração da Impressora
  TPosPrinterLibParam = class
  private
    Fflg_translate_tags: Boolean;
    Fbuffer: SmallInt;
    Fflg_partial_paper_cut: Boolean;
    Fblank_lines_to_end: SmallInt;
    Fflg_paper_cut: Boolean;
    Fflg_ignore_tags: Boolean;
    Fmodel: TPosPrinterLibParamModel;
    Fcolumns: SmallInt;
    Fport: String;
    Fflg_send_cut_written_command: Boolean;
    Fspace_between_lines: SmallInt;
    Fpage_code: TPosPrinterLibParamPageCode;
    Ffont_size: SmallInt;
    Fflg_port_control: Boolean;
    Fis_open_cash_drawer: Boolean;
  public
    property model: TPosPrinterLibParamModel read Fmodel write Fmodel;
    property port: String read Fport write Fport;
    property columns: SmallInt read Fcolumns write Fcolumns;
    property space_between_lines: SmallInt read Fspace_between_lines write Fspace_between_lines;
    property buffer: SmallInt read Fbuffer write Fbuffer;
    property font_size: SmallInt read Ffont_size write Ffont_size;
    property blank_lines_to_end: SmallInt read Fblank_lines_to_end write Fblank_lines_to_end;
    property flg_port_control: Boolean read Fflg_port_control write Fflg_port_control;
    property flg_translate_tags: Boolean read Fflg_translate_tags write Fflg_translate_tags;
    property flg_ignore_tags: Boolean read Fflg_ignore_tags write Fflg_ignore_tags;
    property flg_paper_cut: Boolean read Fflg_paper_cut write Fflg_paper_cut;
    property flg_partial_paper_cut: Boolean read Fflg_partial_paper_cut write Fflg_partial_paper_cut;
    property flg_send_cut_written_command: Boolean read Fflg_send_cut_written_command write Fflg_send_cut_written_command;
    property is_open_cash_drawer: Boolean  read Fis_open_cash_drawer write Fis_open_cash_drawer;
    property page_code: TPosPrinterLibParamPageCode read Fpage_code write Fpage_code;
  end;

implementation

end.
