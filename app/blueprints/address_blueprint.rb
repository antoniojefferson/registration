class AddressBlueprint < Blueprinter::Base
  identifier :id

  fields :cep, :logradouro, :complement, :district, :city, :uf, :ibge_code
end
