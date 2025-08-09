require 'rails_helper'

RSpec.describe 'API Auth', type: :request do
  describe 'POST /api/register' do
    it 'registers and returns token' do
      post '/api/register', params: { email: 'a@b.com', password: 'Password123!', password_confirmation: 'Password123!' }
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
      expect(json['user']['email']).to eq('a@b.com')
    end
  end

  describe 'POST /api/login' do
    let!(:user) { create(:user, email: 'x@y.com', password: 'Password123!') }

    it 'returns token on success' do
      post '/api/login', params: { email: 'x@y.com', password: 'Password123!' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).to be_present
    end

    it 'rejects invalid credentials' do
      post '/api/login', params: { email: 'x@y.com', password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
