require 'rails_helper'

RSpec.describe AddressBlueprint do
  subject(:serialized_address) { described_class.render_as_json(address) }

  let(:address) { create :address }
  let(:keys) do
    %w[id cep logradouro complement district city uf ibge_code]
  end

  it { is_expected.to include(*keys) }
  it { expect(serialized_address.size).to eq keys.size }
end
