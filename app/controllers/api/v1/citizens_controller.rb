module Api
  module V1
    class CitizensController < ApplicationController
      before_action :set_citizen, only: %i[show update]

      def index
        citizens = Citizen.includes(:address).order(:id)

        render json: CitizenBlueprint.render_as_json(citizens), status: :ok
      end

      def show
        render json: CitizenBlueprint.render_as_json(@citizen), status: :ok
      end

      def create
        @citizen = Citizen.new(citizen_params)
        return render_citizen(@citizen, :created) if @citizen.save

        render_validation_errors(@citizen)
      end

      def update
        return render_citizen(@citizen, :ok) if @citizen.update(citizen_params)

        render_validation_errors(@citizen)
      end

      private

      def set_citizen
        @citizen = Citizen.find(params.expect(:id))
      end

      def render_citizen(citizen, status)
        render json: CitizenBlueprint.render_as_json(citizen), status: status
      end

      def render_validation_errors(citizen)
        render json: { errors: citizen.errors.full_messages }, status: :unprocessable_content
      end

      def citizen_params
        params.permit(
          :full_name, :cpf, :cns, :email, :birth_date, :phone, :photo, :status,
          address_attributes: %i[id cep logradouro complement district city uf ibge_code]
        )
      end
    end
  end
end
