module Api
  module V1
    class CitizensController < ApplicationController
      before_action :set_citizen, except: %i[ create index ]

      def index
        render json: CitizenBlueprint.render_as_json(Citizen.all), status: :ok
      end

      def show
        render json: CitizenBlueprint.render_as_json(@citizen), status: :ok
      end

      def create
        @citizen = Citizen.new(citizen_params)
        if @citizen.save
          render json: CitizenBlueprint.render_as_json(@citizen), status: :created
        else
          render json: { errors: @citizen.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def update
        if @citizen.update(citizen_params)
          render json: CitizenBlueprint.render_as_json(@citizen), status: :ok
        else
          render json: { errors: @citizen.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      private

      def set_citizen
        @citizen = Citizen.find_by(id: params[:id])
        render json: {error: I18n.t('activerecord.errors.models.citizen.not_found') } if @citizen.blank?
      end

      def citizen_params
        params.permit(
          :full_name, :cpf, :cns, :email, :birth_date, :phone, :photo, :status,
          address_attributes: [
            :id,
            :cep,
            :logradouro,
            :complement,
            :district,
            :city,
            :uf,
            :ibge_code
          ]
        )
      end
    end
  end
end
