class HealthController < ApplicationController
  def show
    respond_to do |format|
      format.html { render inline: "<div class='container mx-auto mt-6 px-5'><h1 class='text-xl font-semibold'>Stock Tree</h1><p class='text-gray-600 mt-2'>Welcome.</p></div>", layout: true }
      format.json { render json: { ok: true, time: Time.now.utc.iso8601 } }
    end
  end
end
