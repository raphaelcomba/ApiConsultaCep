program ApiConsultaCep;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.GBSwagger,
  ApiConsultaCep.Controller.Interfaces in 'src\controller\ApiConsultaCep.Controller.Interfaces.pas',
  ApiConsultaCep.Controller.ConsultaCep in 'src\controller\ApiConsultaCep.Controller.ConsultaCep.pas',
  ApiConsultaCep.Controller.RequestApi in 'src\controller\ApiConsultaCep.Controller.RequestApi.pas';

var
  FPort: Integer;

begin
  FPort := 9000;
{$IFDEF Debug}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  THorse
    .Use(Jhonson)
    .Use(HorseSwagger);

  Swagger
    .Host('localhost:9000')
    .Info
      .Title('API Consulta CEP')
      .Description('API para consulta de endereços a partir do CEP. Utiliza ViaCEP, ApiCEP e AwesomeAPI como fontes.')
      .Version('1.0.0')
    .&End
    .Path('/consultaCep/{cep}')
      .Tag('CEP')
      .GET('Consulta endereço pelo CEP', 'Retorna os dados de endereço correspondentes ao CEP informado.')
        .AddParamPath('cep', 'CEP a ser consultado (somente números, 8 digitos)')
          .Schema(SWAG_STRING)
        .&End
        .AddResponse(200, 'Endereço encontrado com sucesso')
        .&End
        .AddResponse(400, 'CEP inválido ou n�o encontrado')
        .&End
      .&End
    .&End;

  TApiConsultaCepControllerConsultaCep.New.RegisterHorse;

  THorse.Listen(FPort,
    procedure
    begin
      writeln(Format('Server started on port %d', [FPort]));
      writeln(Format('Swagger UI: http://localhost:%d/swagger/doc/html', [FPort]));
    end);

end.
