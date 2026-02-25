# API Consulta CEP

API REST desenvolvida em **Delphi** com o framework **Horse** para consulta de endereços a partir de um CEP brasileiro. Conta com sistema de **fallback automático** entre três provedores externos, garantindo alta disponibilidade na busca.

---

## Tecnologias

- [Delphi](https://www.embarcadero.com/products/delphi) — linguagem principal
- [Horse](https://github.com/hashload/horse) — framework HTTP REST
- [Jhonson](https://github.com/hashload/jhonson) — middleware JSON para Horse
- [GBSwagger](https://github.com/gabrielbaltazar/gbswagger) — documentação Swagger/OpenAPI
- [Boss](https://github.com/HashLoad/boss) — gerenciador de pacotes Delphi

---

## Como funciona

Ao receber um CEP, a API tenta buscar o endereço em até **três provedores externos**, em ordem de prioridade. Se um estiver indisponível ou não retornar dados, o próximo é consultado automaticamente.

```
Requisição
    │
    ▼
 ViaCEP ──(falha)──► ApiCEP ──(falha)──► AwesomeAPI
    │                   │                     │
    └───────────────────┴─────────────────────┘
                        │
                   Resposta JSON
```

Cada requisição aos provedores possui **timeout de 5 segundos** para evitar lentidão em cascata.

---

## Endpoint

### `GET /consultaCep/:cep`

Consulta o endereço correspondente ao CEP informado.

**Parâmetros**

| Nome | Tipo   | Local | Descrição                        |
|------|--------|-------|----------------------------------|
| cep  | string | path  | CEP a ser consultado (8 dígitos) |

**Exemplo de requisição**

```
GET http://localhost:9000/consultaCep/01310100
```

**Exemplo de resposta (200)**

```json
{
  "cep": "01310-100",
  "logradouro": "Avenida Paulista",
  "bairro": "Bela Vista",
  "localidade": "São Paulo",
  "uf": "SP"
}
```

**Resposta quando o CEP não é encontrado**

```
CEP não encontrado ou todas as APIs estão indisponíveis.
```

---

## Documentação Swagger

Após iniciar a aplicação, acesse:

| Recurso       | URL                                          |
|---------------|----------------------------------------------|
| Swagger UI    | http://localhost:9000/swagger/doc/html       |
| Swagger JSON  | http://localhost:9000/swagger/doc/json       |

---

## Como executar

### Pré-requisitos

- Delphi (XE8 ou superior)
- [Boss](https://github.com/HashLoad/boss) instalado

### Instalação das dependências

```bash
boss install
```

### Compilar e executar

1. Abra o projeto `ApiConsultaCep.dproj` no Delphi
2. Compile e execute (`F9`)
3. O servidor iniciará na porta **9000**

```
Server started on port 9000
Swagger UI: http://localhost:9000/swagger/doc/html
```

---

## Estrutura do projeto

```
ApiConsultaCep/
├── src/
│   └── controller/
│       ├── ApiConsultaCep.Controller.Interfaces.pas   # Interfaces do sistema
│       ├── ApiConsultaCep.Controller.ConsultaCep.pas  # Lógica de consulta e fallback
│       └── ApiConsultaCep.Controller.RequestApi.pas   # Cliente HTTP com timeout
├── ApiConsultaCep.dpr                                 # Programa principal e configuração
└── boss.json                                          # Dependências
```

---

## Provedores utilizados

| Provedor    | URL base                                  |
|-------------|-------------------------------------------|
| ViaCEP      | `https://viacep.com.br/ws/{cep}/json/`    |
| ApiCEP      | `https://cdn.apicep.com/file/apicep/{cep}.json` |
| AwesomeAPI  | `https://cep.awesomeapi.com.br/json/{cep}` |
