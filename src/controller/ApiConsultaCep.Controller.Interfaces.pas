unit ApiConsultaCep.Controller.Interfaces;

interface

uses
  Horse;
type
  iEntidadeApi = interface
    ['{6DBA789E-5763-4738-B3B7-1DF353E3208A}']
    function GetResponse: String;
    function GetErroRequest(Var AErro: String): iEntidadeApi;
    function Url(AValue: String): iEntidadeApi;
    function RequestApi: iEntidadeApi;
  end;

  iEntidadeConsultaCep = interface
    ['{D6324125-6B4A-4935-9BF0-39B8EACAFAC0}']
    function RegisterHorse: iEntidadeConsultaCep; overload;
  end;

implementation

end.
