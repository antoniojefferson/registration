require 'rails_helper'

RSpec.describe CitizenBlueprint do
  subject(:serialized_citizen) { described_class.render_as_json(citizen) }

  let(:citizen) { create :citizen }
  let(:keys) do
    %w[id full_name cpf cns email birth_date phone photo status address]
  end

  it { is_expected.to include(*keys) }
  it { expect(serialized_citizen.size).to eq keys.size }
end
