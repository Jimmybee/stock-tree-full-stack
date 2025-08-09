class ApplicationController < ActionController::Base
	include Pundit::Authorization
	include Pagy::Backend
	protect_from_forgery with: :exception

	rescue_from Pundit::NotAuthorizedError do
		respond_to do |format|
			format.html { redirect_to root_path, alert: "Not authorized" }
			format.json { render json: { errors: [{ message: "Not authorized" }] }, status: :forbidden }
		end
	end
end
