unit uPosPrinter.Lib.Factory;

interface

uses
  uPosPrinter.Lib.Interfaces;

type
  TPosPrinterLibType = (ppltACBr, ppltOthers);
  TPosPrinterLibFactory = class
    class function Make(AType: TPosPrinterLibType = ppltACBr): IPosPrinterLib;
  end;

implementation

{ TPosPrinterLibFactory }

uses
  uPosPrinter.Lib.ACBr;

class function TPosPrinterLibFactory.Make(AType: TPosPrinterLibType): IPosPrinterLib;
begin
  case AType of
    ppltACBr:   Result := TPosPrinterLibACBr.Make;
    ppltOthers: ;//Result := TPosPrinterLibOther.Make;
  end;
end;

end.

