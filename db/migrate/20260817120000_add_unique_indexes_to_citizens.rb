# frozen_string_literal: true

class AddUniqueIndexesToCitizens < ActiveRecord::Migration[8.1]
  def change
    add_index :citizens, :cpf, unique: true
    add_index :citizens, :cns, unique: true
    add_index :citizens, :email, unique: true
  end
end
