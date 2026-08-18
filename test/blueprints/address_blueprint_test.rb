# frozen_string_literal: true

require 'test_helper'

class AddressBlueprintTest < ActiveSupport::TestCase
  test 'serializes every public address field' do
    result = AddressBlueprint.render_as_json(addresses(:one))

    assert_equal %w[cep city complement district ibge_code id logradouro uf], result.keys.sort
  end
end
