unit ApiConsultaCep.Controller.RequestApi;

interface

uses
  ApiConsultaCep.Controller.Interfaces,
  System.SysUtils,
  System.Net.HttpClient;

type
  TApiConsultaCepControllerRequestApi = class(TInterfacedObject, iEntidadeApi)
  private
    FUrl: String;
    FResponse: String;
    FErro: String;
  public
    constructor Create; reintroduce;
    class function New: iEntidadeApi;

    function GetResponse: String;
    function GetErroRequest(Var AErro: String): iEntidadeApi;
    function Url(AValue: String): iEntidadeApi;
    function RequestApi: iEntidadeApi;
  end;

implementation

{ TApiConsultaCepControllerRequestApi }

constructor TApiConsultaCepControllerRequestApi.Create;
begin
  inherited;
end;

function TApiConsultaCepControllerRequestApi.GetErroRequest(
  var AErro: String): iEntidadeApi;
begin
  Result := Self;
  FErro := AErro;
end;

function TApiConsultaCepControllerRequestApi.GetResponse: String;
begin
  Result := FResponse;
end;

class function TApiConsultaCepControllerRequestApi.New: iEntidadeApi;
begin
  Result := Self.Create;
end;

function TApiConsultaCepControllerRequestApi.RequestApi: iEntidadeApi;
var
  LHttpClient: THTTPClient;
  LResponse: IHTTPResponse;
begin
  Result := Self;

  LHttpClient := THTTPClient.Create;
  try
    try
      LResponse := LHttpClient.Get(FUrl);
      FResponse := LResponse.ContentAsString(TEncoding.UTF8);
    except
      on E: Exception do
      begin
        FErro := E.Message;
        FResponse := '';
      end;
    end;
  finally
    LHttpClient.Free;
  end;
end;

function TApiConsultaCepControllerRequestApi.Url(AValue: String): iEntidadeApi;
begin
  Result := Self;
  FUrl := AValue;
end;

end.
