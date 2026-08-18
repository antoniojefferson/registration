class CitizenBlueprint < Blueprinter::Base
  identifier :id

  fields :full_name, :cpf, :cns, :email, :birth_date, :phone, :status

  field :photo do |citizen|
    { url: citizen.photo.url }
  end

  association :address, blueprint: AddressBlueprint
end
