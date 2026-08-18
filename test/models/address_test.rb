# frozen_string_literal: true

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test 'belongs to a citizen' do
    assert_equal citizens(:one), addresses(:one).citizen
  end

  test 'requires citizen and address fields' do
    address = Address.new
    assert_not address.valid?
    %i[citizen cep logradouro complement district city uf].each do |attribute|
      assert address.errors[attribute].present?, "expected an error on #{attribute}"
    end
  end

  test 'is valid with all required attributes' do
    assert Address.new(valid_address_attributes.merge(citizen: citizens(:one))).valid?
  end
end
