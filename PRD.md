# PRD — Registration API

## 1. Visão geral

O Registration API é um serviço para registrar e consultar cidadãos e seus endereços. O produto oferece uma interface HTTP versionada, com respostas JSON, para que sistemas clientes possam manter dados cadastrais básicos de forma centralizada.

## 2. Problema

Sistemas que dependem de dados de cidadãos precisam de uma fonte consistente para identificação, contato, situação cadastral, foto e endereço. Sem uma API central, essas informações tendem a ser duplicadas, validadas de formas diferentes e atualizadas de maneira manual.

## 3. Objetivo do produto

Disponibilizar uma API simples e confiável para:

- cadastrar cidadãos com seus respectivos endereços;
- consultar todos os cidadãos ou um registro específico;
- atualizar dados cadastrais e de endereço;
- impedir duplicidade de CPF, CNS e e-mail;
- fornecer respostas JSON previsíveis para integração com outros sistemas.

## 4. Público-alvo

- Equipes responsáveis por cadastros municipais ou administrativos.
- Aplicações web ou móveis que consumam dados cadastrais.
- Desenvolvedores que precisem integrar um fluxo de cadastro de cidadãos.

## 5. Escopo atual

### Incluído

- API REST versionada em `/api/v1`.
- Cadastro de cidadão e de um endereço aninhado.
- Listagem e consulta de cidadãos.
- Atualização de cidadão e endereço.
- Upload e armazenamento local de foto.
- Validação de dados obrigatórios, e-mail e unicidade.
- Serialização das respostas de cidadão e endereço.
- Mensagens de validação com suporte a localização.

### Fora do escopo

- Exclusão de cidadãos.
- Autenticação e autorização.
- Perfis de usuário ou níveis de acesso.
- Paginação, filtros e busca textual.
- Histórico ou auditoria de alterações.
- Integração automática com serviços de CEP, CPF, CNS ou IBGE.
- Interface gráfica para operação dos cadastros.
- Armazenamento de arquivos em nuvem.

## 6. Entidades e relacionamento

### Cidadão

Representa a pessoa cadastrada e contém nome completo, CPF, CNS, e-mail, data de nascimento, telefone, foto e status.

### Endereço

Representa o endereço associado ao cidadão e contém CEP, logradouro, complemento, bairro, cidade, UF e código IBGE.

- Um cidadão possui no máximo um endereço.
- Um endereço pertence obrigatoriamente a um cidadão.
- A remoção interna de um cidadão também remove seu endereço, embora a API pública não exponha exclusão.

## 7. Requisitos funcionais

| ID | Requisito |
| --- | --- |
| RF-01 | O sistema deve permitir cadastrar um cidadão. |
| RF-02 | O sistema deve aceitar os dados de endereço junto ao cadastro do cidadão. |
| RF-03 | O sistema deve listar os cidadãos cadastrados. |
| RF-04 | O sistema deve consultar um cidadão pelo identificador. |
| RF-05 | O sistema deve permitir atualizar os dados de um cidadão existente. |
| RF-06 | O sistema deve permitir atualizar o endereço associado. |
| RF-07 | O sistema deve aceitar uma foto no cadastro do cidadão. |
| RF-08 | O sistema deve retornar cidadão e endereço em uma resposta JSON única. |
| RF-09 | O sistema deve informar erros de validação ao cliente da API. |
| RF-10 | O sistema deve informar quando o cidadão solicitado não existir. |

## 8. Regras de negócio

| ID | Regra |
| --- | --- |
| RN-01 | Nome completo, CPF, CNS, data de nascimento e telefone são obrigatórios. |
| RN-02 | O e-mail é obrigatório e deve possuir formato válido. |
| RN-03 | CPF, CNS e e-mail não podem ser repetidos entre cidadãos. |
| RN-04 | CEP, logradouro, bairro, cidade e UF são obrigatórios para um endereço. |
| RN-05 | O banco atual também exige o preenchimento do complemento do endereço. |
| RN-06 | Cada endereço deve estar associado a um cidadão. |
| RN-07 | O status identifica a situação do cadastro e não pode ser nulo no banco. |
| RN-08 | A API não deve disponibilizar uma operação pública de exclusão. |

## 9. Contrato da API

| Operação | Método e rota | Resultado esperado |
| --- | --- | --- |
| Listar | `GET /api/v1/citizens` | Coleção JSON e status `200` |
| Consultar | `GET /api/v1/citizens/:id` | Objeto JSON e status `200` |
| Cadastrar | `POST /api/v1/citizens` | Objeto criado e status `201` |
| Atualizar | `PUT/PATCH /api/v1/citizens/:id` | Objeto atualizado e status `200` |

Dados inválidos devem produzir status `422` e uma resposta contendo a chave `errors`.

## 10. Requisitos não funcionais

- A API deve responder em JSON.
- As rotas devem manter versionamento explícito.
- O projeto deve executar com Ruby 3.3.5 e Rails 8.1.3.1.
- O carregamento de código deve permanecer compatível com o Zeitwerk.
- Mudanças devem manter a suíte automatizada sem falhas.
- Segredos, bancos locais e arquivos temporários não devem ser versionados.

## 11. Critérios de aceite

- Um payload válido cria um cidadão e retorna `201`.
- Um payload inválido não persiste o cadastro e retorna `422` com os erros.
- CPF, CNS ou e-mail já existentes impedem um novo cadastro.
- A listagem retorna os atributos do cidadão e seu endereço.
- A consulta de um identificador existente retorna o registro correspondente.
- A atualização válida persiste as alterações e retorna `200`.
- Os endpoints de exclusão não estão disponíveis.
- `bundle exec rspec` e `bin/rails zeitwerk:check` terminam sem falhas.

## 12. Indicadores de sucesso

Como o projeto ainda não possui telemetria, os indicadores iniciais propostos são:

- taxa de sucesso das operações de cadastro e atualização;
- quantidade de respostas `422` por campo ou regra violada;
- tempo de resposta dos endpoints de leitura e escrita;
- disponibilidade da API;
- percentual de execuções bem-sucedidas da suíte de testes no CI.

## 13. Riscos e limitações

- Não há autenticação; a API deve ser protegida antes de exposição pública.
- CPF, CNS e e-mail são validados por consultas na aplicação, sem índices únicos no schema atual, o que pode permitir condições de corrida.
- O telefone é armazenado como inteiro, podendo perder zeros à esquerda e impor limites de tamanho.
- O armazenamento local de fotos dificulta escalabilidade horizontal e persistência em ambientes efêmeros.
- A listagem não possui paginação e pode degradar à medida que o volume crescer.
- A consulta de registro inexistente atualmente retorna um corpo de erro sem um status HTTP específico de recurso não encontrado.

## 14. Evoluções recomendadas

Estas propostas não fazem parte do escopo implementado:

1. Adicionar autenticação e autorização.
2. Criar índices únicos no banco para CPF, CNS e e-mail.
3. Armazenar telefone como string.
4. Adicionar paginação, filtros e ordenação.
5. Padronizar respostas de erro e retornar `404` para registros inexistentes.
6. Migrar fotos para armazenamento de objetos.
7. Adicionar observabilidade, CI e documentação OpenAPI.
