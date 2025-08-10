require 'rails_helper'

RSpec.describe 'API v1 Products', type: :request do
  let!(:user) { create(:user) }

  def token_for(u)
    Warden::JWTAuth::UserEncoder.new.call(u, :user, nil).first
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'paginates index and filters by team and query' do
    team = create(:team)
    TeamsUser.create!(team: team, user: user)
    other_team = create(:team)
    3.times { |i| create(:product, team: team, name: "Widget #{i}") }
    create(:product, team: other_team, name: 'Gadget')

    token = token_for(user)
    get '/api/v1/products', params: { team_id: team.id, q: 'Widget' }, headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['products'].length).to be >= 1
    expect(body['products'].all? { |p| p['name'].include?('Widget') }).to be true
    expect(body['meta']).to be_present
  end

  it 'creates a product when authorized' do
    team = create(:team)
    TeamsUser.create!(team: team, user: user)

    token = token_for(user)
    post '/api/v1/products', params: { product: { team_id: team.id, name: 'New Product' } }, headers: auth_header(token)

    expect(response).to have_http_status(:created)
    expect(JSON.parse(response.body).dig('product', 'name')).to eq('New Product')
  end

  it 'rejects non-image upload' do
    team = create(:team)
    TeamsUser.create!(team: team, user: user)
    token = token_for(user)

    file = fixture_file_upload(Rails.root.join('spec/fixtures/files/text.txt'), 'text/plain')
    post '/api/v1/products', params: { product: { team_id: team.id, name: 'Bad' }, product_image: file }, headers: auth_header(token)

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)['errors'].map { |e| e['field'] }).to include('product_image')
  end
end
