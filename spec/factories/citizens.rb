FactoryBot.define do
  factory :citizen do
    sequence(:full_name) { |number| "Cidadão #{number}" }
    sequence(:cpf) { |number| format('%011d', number) }
    sequence(:cns) { |number| format('%015d', number) }
    sequence(:email) { |number| "cidadao#{number}@example.com" }
    birth_date { Date.current }
    sequence(:phone) { |number| 85_900_000_000 + number }
    status { false }
  end
end
