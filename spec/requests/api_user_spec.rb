require 'rails_helper'

RSpec.describe 'API v1 User', type: :request do
  let!(:user) { create(:user) }

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'returns current user' do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    get '/api/v1/user', headers: auth_header(token)
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).dig('user', 'email')).to eq(user.email)
  end

  it 'updates profile' do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    patch '/api/v1/user', params: { user: { first_name: 'Jane' } }, headers: auth_header(token)
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).dig('user', 'first_name')).to eq('Jane')
  end
end
