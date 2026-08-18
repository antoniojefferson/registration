class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render json: { error: I18n.t('activerecord.errors.models.citizen.not_found') }, status: :not_found
  end
end
