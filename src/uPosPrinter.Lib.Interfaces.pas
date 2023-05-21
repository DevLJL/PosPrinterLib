unit uPosPrinter.Lib.Interfaces;

interface

uses
  System.Classes,
  uPosPrinter.Lib.Param;

type
  IPosPrinterLib = Interface
    ['{DB65EC2F-6908-4DAA-93D0-443E6CACDA67}']

    function Param: TPosPrinterLibParam;
    function PrintText(AContent: TStringList; ACopies: SmallInt): IPosPrinterLib;
    function LoadPorts(AStrings: TStrings): IPosPrinterLib;
  end;

implementation

end.
