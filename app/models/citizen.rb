class Citizen < ApplicationRecord
  has_one :address, dependent: :destroy, inverse_of: :citizen

  mount_uploader :photo, ImageUploader
  accepts_nested_attributes_for :address

  normalizes :cpf, :cns, with: ->(value) { value.strip }
  normalizes :email, with: ->(value) { value.strip.downcase }

  validates :full_name, :cpf, :cns, :email, :birth_date, :phone, presence: true
  validates :cpf, :cns, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
end
