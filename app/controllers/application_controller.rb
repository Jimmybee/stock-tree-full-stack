class ApplicationController < ActionController::Base
	include Pundit::Authorization
	include Pagy::Backend

	protect_from_forgery with: :exception

	before_action :configure_permitted_parameters, if: :devise_controller?

	rescue_from Pundit::NotAuthorizedError do
		respond_to do |format|
			format.html { redirect_to root_path, alert: 'Not authorized' }
			format.json { render json: { errors: [{ message: 'Not authorized' }] }, status: :forbidden }
		end
	end

	protected

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
		devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
	end
end
