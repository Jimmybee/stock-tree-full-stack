require 'rails_helper'

RSpec.describe 'API v1 Teams', type: :request do
  let!(:user) { create(:user) }

  def token_for(u)
    Warden::JWTAuth::UserEncoder.new.call(u, :user, nil).first
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists only teams current user belongs to' do
    my_team = Team.create!(name: 'Mine')
    other_team = Team.create!(name: 'Other')
    TeamsUser.create!(team: my_team, user: user)
    token = token_for(user)

    get '/api/v1/teams', headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    ids = JSON.parse(response.body)['teams'].map { |t| t['id'] }
    expect(ids).to include(my_team.id)
    expect(ids).not_to include(other_team.id)
  end

  it 'creates a team and adds current user as member and creates root folder' do
    token = token_for(user)

    post '/api/v1/teams', params: { team: { name: 'New Team' } }, headers: auth_header(token)
    expect(response).to have_http_status(:created)

    team_id = JSON.parse(response.body).dig('team', 'id')
    team = Team.find(team_id)

    expect(team.users).to include(user)
    root = team.folders.find_by(parent_id: nil, name: 'Root')
    expect(root).to be_present
  end
end
