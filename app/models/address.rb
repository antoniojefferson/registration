class Address < ApplicationRecord
  belongs_to :citizen, inverse_of: :address

  validates :cep, :logradouro, :complement, :district, :city, :uf, presence: true
end
