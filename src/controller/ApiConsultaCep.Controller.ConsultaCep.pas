unit ApiConsultaCep.Controller.ConsultaCep;

interface

uses
  ApiConsultaCep.Controller.Interfaces,
  ApiConsultaCep.Controller.RequestApi,
  System.SysUtils,
  Horse,
  System.JSON;

type
  TApiConsultaCepControllerConsultaCep = class(TInterfacedObject,
    iEntidadeConsultaCep)
  private
    FResponse: String;
    FErro: String;
    procedure ConsultaCep(ACep: String);
    procedure Response(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  public
    constructor Create; reintroduce;
    class function New: iEntidadeConsultaCep;

    function RegisterHorse: iEntidadeConsultaCep; overload;
  end;

const
  VIACEP = 'https://viacep.com.br/ws/%s/json/';
  APICEP = 'https://cdn.apicep.com/file/apicep/%s.json';
  AWESOME_API = 'https://cep.awesomeapi.com.br/json/%s';

implementation

{ TApiConsultaCepControllerConsultaCep }

procedure TApiConsultaCepControllerConsultaCep.ConsultaCep(ACep: String);
var
  LResponse: String;
begin
  LResponse := TApiConsultaCepControllerRequestApi.New.Url(Format(VIACEP,[ACep])).GetErroRequest(FErro).RequestApi.GetResponse;

  if LResponse = '' then
    LResponse := TApiConsultaCepControllerRequestApi.New.Url(Format(APICEP,[ACep])).GetErroRequest(FErro).RequestApi.GetResponse;

  if LResponse = '' then
    LResponse := TApiConsultaCepControllerRequestApi.New.Url(Format(AWESOME_API,[ACep])).GetErroRequest(FErro).RequestApi.GetResponse;

  if LResponse = '' then
  begin
    if FErro = '' then
      FErro := 'CEP n�o encontrado ou todas as APIs est�o indispon�veis.';
    LResponse := FErro;
  end;

  FResponse := LResponse;
end;

constructor TApiConsultaCepControllerConsultaCep.Create;
begin
  inherited;
end;

class function TApiConsultaCepControllerConsultaCep.New: iEntidadeConsultaCep;
begin
  Result := Self.Create;
end;

function TApiConsultaCepControllerConsultaCep.RegisterHorse
  : iEntidadeConsultaCep;
begin
  Result := Self;
  THorse.Get('/consultaCep/:cep', Response);
end;

procedure TApiConsultaCepControllerConsultaCep.Response(Req: THorseRequest;
  Res: THorseResponse; Next: TProc);
begin
  ConsultaCep(Req.Params['cep']);
  Res.Send(FResponse);
end;

end.
