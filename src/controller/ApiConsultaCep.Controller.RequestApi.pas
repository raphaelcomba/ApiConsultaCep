unit ApiConsultaCep.Controller.RequestApi;

interface

uses
  ApiConsultaCep.Controller.Interfaces,
  System.SysUtils,
  System.Net.HttpClient;

const
  REQUEST_TIMEOUT_MS = 5000;

type
  TApiConsultaCepControllerRequestApi = class(TInterfacedObject, iEntidadeApi)
  private
    FUrl: String;
    FResponse: String;
    FErroRef: PString;
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
  FErroRef := nil;
end;

function TApiConsultaCepControllerRequestApi.GetErroRequest(
  var AErro: String): iEntidadeApi;
begin
  Result := Self;
  FErroRef := @AErro;
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
    LHttpClient.ConnectionTimeout := REQUEST_TIMEOUT_MS;
    LHttpClient.ResponseTimeout   := REQUEST_TIMEOUT_MS;
    try
      LResponse := LHttpClient.Get(FUrl);
      FResponse := LResponse.ContentAsString(TEncoding.UTF8);
    except
      on E: Exception do
      begin
        if Assigned(FErroRef) then
          FErroRef^ := E.Message;
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
