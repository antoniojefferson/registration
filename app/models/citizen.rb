class Citizen < ApplicationRecord
    has_many :addresses
    mount_uploader :photo, ImageUploader
    accepts_nested_attributes_for :addresses, allow_destroy: true

    def json
      {
        id: self.id,
        full_name: self.full_name,
        cpf: self.cpf,
        cns: self.cns,
        email: self.email,
        birth_date: self.birth_date.strftime('%d/%m/%Y'),
        phone: self.phone,
        photo: self.photo,
        status: self.status,
        address: self.addresses,
        created_at: self.created_at,
        updated_at: self.updated_at,
      }
    end
end