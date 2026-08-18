# frozen_string_literal: true

require 'test_helper'

class CitizenBlueprintTest < ActiveSupport::TestCase
  test 'serializes every public citizen field' do
    result = CitizenBlueprint.render_as_json(citizens(:one))

    assert_equal %w[address birth_date cns cpf email full_name id phone photo status], result.keys.sort
    assert_equal addresses(:one).id, result.fetch('address').fetch('id')
    assert_equal({ 'url' => nil }, result.fetch('photo'))
  end
end
