# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all

    def valid_citizen_attributes(overrides = {})
      {
        full_name: 'Maria da Silva', cpf: '52998224725', cns: '898001160178219',
        email: 'maria@example.com', birth_date: Date.new(1990, 1, 1),
        phone: 85_999_999_999, status: true
      }.merge(overrides)
    end

    def valid_address_attributes(overrides = {})
      {
        cep: '60170120', logradouro: 'Avenida Beira Mar', complement: 'Apto 101',
        district: 'Meireles', city: 'Fortaleza', uf: 'CE', ibge_code: 2_304_400
      }.merge(overrides)
    end
  end
end
