require 'rails_helper'

RSpec.describe Api::V1::CitizensController, type: :controller do
  let!(:citizen) { create :citizen }
  let!(:address) { create :address, citizen_id: citizen.id }
  let(:citizen_valid) { build :citizen }
  let(:citizen_invalid) { build :citizen, id: citizen.id, cns: '', birth_date: Date.current.to_s }
  let(:result) do
    {
      id: citizen.id,
      full_name: citizen.full_name,
      cpf: citizen.cpf,
      cns: citizen.cns,
      email: citizen.email,
      birth_date: citizen.birth_date.to_s,
      phone: citizen.phone,
      photo: { "url" => citizen.photo.url },
      status: citizen.status,
      address: {
        id: address.id,
        cep: address.cep,
        logradouro: address.logradouro,
        complement: address.complement,
        district: address.district,
        city: address.city,
        uf: address.uf,
        ibge_code: address.ibge_code
      }.stringify_keys
    }.stringify_keys
  end
  
  describe 'GET #index' do

    context 'when you search for all citizens' do
      before do
        get :index
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return all keys and values in json' do
        expect(json.first).to eq result
      end
    end

  end

  describe 'GET #show' do

    context 'when looking for a citizen by an existing id' do
      
      before do
        get :show, params: { id: citizen.id }
      end

      it 'returns status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'return all keys and values in json' do
        expect(json).to eq result
      end
    end

    context 'when looking for a non-existent id' do
      before do
        get :show, params: { id: 60 }
      end

      it 'returns status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns the json a valid json with the error key' do
        expect(json).not_to be_nil
        expect(json['error']).not_to be_nil
      end

      it 'returns error' do
        expect(json['error']).to eq "Cidadão não encontrado"
      end
    end

  end

  describe 'POST #create' do
    let(:valid_params) { citizen_valid.attributes }
    let(:invalid_params) { citizen_invalid.attributes }

    context 'when the citizen is valid' do
      before { post :create, params: valid_params }

      it 'returns the created citizin' do
        expect(json).not_to be_nil
        expect(json['errors']).to be_nil
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the citizen is invalid' do
      before { post :create, params: invalid_params }

      it 'returns errors on creation' do
        expect(json).not_to be_nil
        expect(json['errors']).not_to be_nil
      end

      it 'returns unprocessable status' do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when the mandatory address data is null' do
      let(:citizen2) { build :citizen }
      let(:address1) { build :address, cep: '' }
      let(:address_params) do
        {
          "address_attributes[id]" => address1.id,
          "address_attributes[cep]" => address1.cep,
          "address_attributes[logradouro]" => address1.logradouro,
          "address_attributes[complement]" => address1.complement,
          "address_attributes[district]" => address1.district,
          "address_attributes[city]" => address1.city,
          "address_attributes[uf]" => address1.uf,
          "address_attributes[ibge_code]" => address1.ibge_code
        }
      end

      before { post :create, params: { **citizen2.attributes, **address_params} }

      it 'returns errors on creation' do
        expect(json).not_to be_nil
        expect(json['errors']).not_to be_nil
      end

      it 'returns unprocessable status' do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'PUT #update' do
    let(:valid_params) { citizen.attributes }
    let(:invalid_params) { citizen_invalid.attributes }

    context 'when the citizen is valid' do
      before { put :update, params: valid_params }

      it 'returns the created citizin' do
        expect(json).not_to be_nil
        expect(json['errors']).to be_nil
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the citizen is invalid' do
      before { put :update, params: invalid_params }

      it 'returns errors on update' do
        expect(json).not_to be_nil
        expect(json['errors']).not_to be_nil
      end

      it 'returns unprocessable status' do
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

end
