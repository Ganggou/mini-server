class ApplicationController < ActionController::API
  include Renderer

  before_action :authenticate_user!, only: [:auth_ping]

  def ping
    render plain: 'pong'
  end

  def auth_ping
    render plain: 'pong'
  end

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end
end
