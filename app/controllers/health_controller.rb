class HealthController < ActionController::API
  def show
    render json: { ok: true, time: Time.now.utc.iso8601 }
  end
end
