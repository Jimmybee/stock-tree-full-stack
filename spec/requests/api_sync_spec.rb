require 'rails_helper'

RSpec.describe 'API v1 Sync', type: :request do
  let!(:user) { create(:user) }

  def token_for(u)
    Warden::JWTAuth::UserEncoder.new.call(u, :user, nil).first
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'upserts and returns deltas' do
    team = create(:team)
    folder = create(:folder, team: team)
    TeamsUser.create!(team: team, user: user)
    token = token_for(user)

    last_sync = 1.hour.ago.utc.iso8601
    payload = {
      team_id: team.id,
      last_sync_time: last_sync,
      products: [ { name: 'Synced', folder_id: folder.id, qty: 2 } ]
    }

    post '/api/v1/sync', params: payload, headers: auth_header(token)
    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body['upserted_count']).to eq(1)
    expect(body['products'].any? { |p| p['name'] == 'Synced' }).to be true
  end
end
