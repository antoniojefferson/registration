# Registration API

API REST para cadastro e consulta de cidadãos e seus respectivos endereços. O projeto foi construído com Ruby on Rails em modo API e retorna dados em JSON.

## Objetivo

Centralizar o cadastro de cidadãos, seus dados de identificação, contato, foto e endereço em uma API simples. A descrição funcional completa está no [PRD](PRD.md).

## Funcionalidades

- Listagem de cidadãos cadastrados.
- Consulta de cidadão por identificador.
- Cadastro de cidadão com endereço aninhado.
- Atualização de cidadão e endereço.
- Upload de foto por meio do CarrierWave.
- Validação de campos obrigatórios.
- Validação de formato de e-mail.
- Validação de unicidade de CPF, CNS e e-mail.
- Respostas serializadas em JSON.

> A API não oferece exclusão de cidadãos no escopo atual.

## Tecnologias

- Ruby 3.3.5
- Rails 8.1.3.1
- SQLite 3
- Puma
- Blueprinter
- CarrierWave
- RSpec, FactoryBot e Shoulda Matchers

## Pré-requisitos

- Ruby 3.3.5 instalado, preferencialmente por `rbenv`, `asdf` ou `mise`.
- Bundler compatível com o `Gemfile.lock`.
- SQLite 3.
- Bibliotecas de compilação necessárias para gems nativas.

Confira as versões ativas:

```bash
ruby --version
bundle --version
sqlite3 --version
```

## Instalação

Clone o repositório, entre na pasta do projeto e execute:

```bash
bundle install
bin/rails db:prepare
```

O comando `db:prepare` cria o banco, carrega o schema e executa as migrações pendentes quando necessário.

## Execução

Inicie o servidor:

```bash
bin/rails server
```

A API ficará disponível em [http://localhost:3000](http://localhost:3000).

## Endpoints

Todos os endpoints usam o prefixo `/api/v1`.

| Método | Endpoint | Descrição | Sucesso |
| --- | --- | --- | --- |
| `GET` | `/api/v1/citizens` | Lista todos os cidadãos | `200 OK` |
| `GET` | `/api/v1/citizens/:id` | Consulta um cidadão | `200 OK` |
| `POST` | `/api/v1/citizens` | Cadastra um cidadão | `201 Created` |
| `PUT/PATCH` | `/api/v1/citizens/:id` | Atualiza um cidadão | `200 OK` |

### Exemplo de cadastro

```bash
curl --request POST http://localhost:3000/api/v1/citizens \
  --header 'Content-Type: application/json' \
  --data '{
    "full_name": "Maria da Silva",
    "cpf": "12345678901",
    "cns": "123456789012345",
    "email": "maria@example.com",
    "birth_date": "1990-05-20",
    "phone": 85999999999,
    "status": true,
    "address_attributes": {
      "cep": "60000000",
      "logradouro": "Rua Exemplo",
      "complement": "Apto 101",
      "district": "Centro",
      "city": "Fortaleza",
      "uf": "CE",
      "ibge_code": 2304400
    }
  }'
```

Para enviar `photo`, utilize uma requisição `multipart/form-data`. O endereço é recebido pela chave `address_attributes`.

### Campos do cidadão

| Campo | Tipo | Obrigatório | Regra |
| --- | --- | --- | --- |
| `full_name` | string | Sim | Nome completo |
| `cpf` | string | Sim | Único entre cidadãos |
| `cns` | string | Sim | Único entre cidadãos |
| `email` | string | Sim | Formato válido e valor único |
| `birth_date` | date | Sim | Formato recomendado: `YYYY-MM-DD` |
| `phone` | integer | Sim | Telefone de contato |
| `photo` | arquivo/string | Não | Gerenciado pelo CarrierWave |
| `status` | boolean | Sim no banco | Situação do cadastro |

### Campos do endereço

| Campo | Tipo | Obrigatório |
| --- | --- | --- |
| `cep` | string | Sim |
| `logradouro` | string | Sim |
| `complement` | string | Sim no banco atual |
| `district` | string | Sim |
| `city` | string | Sim |
| `uf` | string | Sim |
| `ibge_code` | integer | Não |

Erros de validação são retornados com status `422 Unprocessable Content` e a chave JSON `errors`.

## Testes e verificações

```bash
bundle exec rspec
bin/rails test
bin/rails zeitwerk:check
```

Pull requests também são validados automaticamente pelo workflow de CI do GitHub Actions, que prepara o banco, verifica o autoload e executa as duas suítes de testes.

Prepare separadamente o banco de testes, se necessário:

```bash
RAILS_ENV=test bin/rails db:prepare
```

## Estrutura principal

```text
app/controllers/api/v1/  Endpoints versionados
app/models/              Regras e validações de domínio
app/blueprints/          Formato das respostas JSON
app/uploaders/           Configuração de upload de fotos
config/routes.rb          Rotas da API
db/migrate/              Histórico do banco de dados
spec/                    Suíte RSpec
```

## Banco de dados

O projeto está configurado para usar SQLite nos ambientes de desenvolvimento, teste e produção. Os arquivos locais do banco não devem ser versionados.

```bash
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed
```

## Documentação do produto

Consulte o [PRD — Documento de Requisitos do Produto](PRD.md) para conhecer o problema, o escopo funcional, as regras de negócio e os critérios de aceite.
