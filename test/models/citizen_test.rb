# frozen_string_literal: true

require 'test_helper'

class CitizenTest < ActiveSupport::TestCase
  test 'has one dependent address' do
    citizen = citizens(:one)
    address_id = citizen.address.id
    citizen.destroy!
    assert_not Address.exists?(address_id)
  end

  test 'requires all mandatory attributes' do
    citizen = Citizen.new
    assert_not citizen.valid?
    %i[full_name cpf cns email birth_date phone].each do |attribute|
      assert citizen.errors[attribute].present?, "expected an error on #{attribute}"
    end
  end

  test 'requires unique cpf, cns, and email' do
    existing = citizens(:one)
    duplicate = Citizen.new(valid_citizen_attributes(
                              cpf: existing.cpf, cns: existing.cns, email: existing.email.upcase
                            ))
    assert_not duplicate.valid?
    %i[cpf cns email].each { |attribute| assert duplicate.errors[attribute].present? }
  end

  test 'normalizes identifiers and email' do
    citizen = Citizen.new(valid_citizen_attributes(
                            cpf: ' 52998224726 ', cns: ' 898001160178220 ', email: ' MARIA.NOVA@EXAMPLE.COM '
                          ))
    assert_equal '52998224726', citizen.cpf
    assert_equal '898001160178220', citizen.cns
    assert_equal 'maria.nova@example.com', citizen.email
  end

  test 'rejects an invalid email' do
    citizen = Citizen.new(valid_citizen_attributes(email: 'email@.com'))
    assert_not citizen.valid?
    assert citizen.errors[:email].present?
  end

  test 'accepts nested address attributes' do
    citizen = Citizen.new(valid_citizen_attributes(
                            cpf: '52998224726', cns: '898001160178220', email: 'nova@example.com',
                            address_attributes: valid_address_attributes
                          ))
    assert citizen.valid?
    assert citizen.address.present?
  end
end
