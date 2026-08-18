FactoryBot.define do
  factory :address do
    sequence(:cep) { |number| format('%08d', number) }
    sequence(:logradouro) { |number| "Rua #{number}" }
    complement { 'Teste' }
    district { 'Centro' }
    city { 'Fortaleza' }
    uf { 'CE' }
    ibge_code { 123 }
    citizen
  end
end
