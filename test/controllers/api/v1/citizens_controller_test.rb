# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class CitizensControllerTest < ActionDispatch::IntegrationTest
      test 'index returns all citizens in id order' do
        get api_v1_citizens_url
        assert_response :ok
        body = response.parsed_body
        assert_equal Citizen.count, body.size
        assert_equal Citizen.order(:id).pluck(:id), body.pluck('id')
        assert body.first.key?('address')
      end

      test 'show returns a citizen' do
        citizen = citizens(:one)
        get api_v1_citizen_url(citizen)
        assert_response :ok
        assert_equal citizen.id, response.parsed_body.fetch('id')
        assert_equal citizen.address.id, response.parsed_body.dig('address', 'id')
      end

      test 'show returns not found for an unknown citizen' do
        get api_v1_citizen_url(id: 0)
        assert_response :not_found
        assert_equal I18n.t('activerecord.errors.models.citizen.not_found'), response.parsed_body.fetch('error')
      end

      test 'create persists a valid citizen and nested address' do
        attributes = valid_citizen_attributes(
          cpf: '52998224726', cns: '898001160178220', email: 'nova@example.com',
          address_attributes: valid_address_attributes
        )
        assert_difference ['Citizen.count', 'Address.count'], 1 do
          post api_v1_citizens_url, params: attributes
        end
        assert_response :created
        assert_equal 'nova@example.com', response.parsed_body.fetch('email')
      end

      test 'create returns validation errors' do
        assert_no_difference 'Citizen.count' do
          post api_v1_citizens_url, params: valid_citizen_attributes(cns: '')
        end
        assert_response :unprocessable_content
        assert response.parsed_body.fetch('errors').present?
      end

      test 'create validates nested address' do
        attributes = valid_citizen_attributes(
          cpf: '52998224726', cns: '898001160178220', email: 'nova@example.com',
          address_attributes: valid_address_attributes(cep: '')
        )
        assert_no_difference ['Citizen.count', 'Address.count'] do
          post api_v1_citizens_url, params: attributes
        end
        assert_response :unprocessable_content
        assert response.parsed_body.fetch('errors').present?
      end

      test 'update changes a citizen' do
        citizen = citizens(:one)
        patch api_v1_citizen_url(citizen), params: { full_name: 'Maria Atualizada' }
        assert_response :ok
        assert_equal 'Maria Atualizada', citizen.reload.full_name
      end

      test 'update returns validation errors' do
        citizen = citizens(:one)
        patch api_v1_citizen_url(citizen), params: { cns: '' }
        assert_response :unprocessable_content
        assert response.parsed_body.fetch('errors').present?
        assert citizen.reload.cns.present?
      end
    end
  end
end
