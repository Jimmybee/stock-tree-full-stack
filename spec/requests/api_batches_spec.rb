require 'rails_helper'

RSpec.describe 'API v1 Batches', type: :request do
  let!(:user) { create(:user) }

  def token_for(u)
    Warden::JWTAuth::UserEncoder.new.call(u, :user, nil).first
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'creates and lists batches for product' do
    team = create(:team)
    folder = create(:folder, team: team)
    TeamsUser.create!(team: team, user: user)
    product = create(:product, team: team, folder: folder)
    token = token_for(user)

    post "/api/v1/products/#{product.id}/batches", params: { batch: { folder_id: folder.id, qty: 5, lot_code: 'A1' } }, headers: auth_header(token)
    expect(response).to have_http_status(:created)

    get "/api/v1/products/#{product.id}/batches", headers: auth_header(token)
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['batches'].first['qty']).to eq(5)
  end
end
