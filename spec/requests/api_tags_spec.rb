require 'rails_helper'

RSpec.describe 'API v1 Tags', type: :request do
  let!(:user) { create(:user) }

  def token_for(u)
    Warden::JWTAuth::UserEncoder.new.call(u, :user, nil).first
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'CRUDs tags and filters products by tag_ids' do
    team = create(:team)
    TeamsUser.create!(team: team, user: user)
    token = token_for(user)

    post '/api/v1/tags', params: { tag: { team_id: team.id, name: 'Blue' } }, headers: auth_header(token)
    expect(response).to have_http_status(:created)
    tag_id = JSON.parse(response.body).dig('tag', 'id')

    p1 = create(:product, team: team, name: 'Box')
    p2 = create(:product, team: team, name: 'Bag')

    patch "/api/v1/products/#{p1.id}", params: { product: { tag_ids: [tag_id] } }, headers: auth_header(token)
    expect(response).to have_http_status(:ok)

    get '/api/v1/products', params: { team_id: team.id, tag_ids: [tag_id] }, headers: auth_header(token)
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    ids = body['products'].map { |p| p['id'] }
    expect(ids).to include(p1.id)
    expect(ids).not_to include(p2.id)
  end
end
