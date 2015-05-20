class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Oniwa::Forbidden,  with: :render_forbidden
  rescue_from Oniwa::BadRequest, with: :render_badrequest
  rescue_from ActiveRecord::RecordNotFound, with: :render_notfound

  private

  def render_badrequest
    render 'errors/400', status: 400
  end

  def render_forbidden
    render 'errors/403', status: 403
  end

  def render_notfound
    render 'errors/404', status: 404
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def message_for(key, options = {})
    I18n.t("controllers.#{controller_name}.#{action_name}.#{key}", options)
  end

  def save_or_raise(model)
    unless model.save
      @errors = model.errors.full_messages
      raise Oniwa::InvalidRequest
    end
  end
end
