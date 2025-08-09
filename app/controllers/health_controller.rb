class HealthController < ApplicationController
  def show
    respond_to do |format|
  format.html { render :show }
  format.json { render json: { ok: true, time: Time.now.utc.iso8601 } }
    end
  end
end
