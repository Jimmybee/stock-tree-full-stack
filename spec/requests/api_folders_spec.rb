require 'rails_helper'

RSpec.describe 'API v1 Folders', type: :request do
  let!(:user) { create(:user) }

  def token_for(u)
    Warden::JWTAuth::UserEncoder.new.call(u, :user, nil).first
  end

  def auth_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'lists folders scoped to user team' do
    my_team = create(:team)
    other_team = create(:team)
    TeamsUser.create!(team: my_team, user: user)
    create(:folder, team: my_team, name: 'Mine A')
    create(:folder, team: other_team, name: 'Other A')

    token = token_for(user)
    get '/api/v1/folders', params: { team_id: my_team.id }, headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    names = JSON.parse(response.body)['folders'].map { |f| f['name'] }
    expect(names).to include('Mine A')
    expect(names).not_to include('Other A')
  end

  it 'creates a folder in a team the user belongs to' do
    team = create(:team)
    TeamsUser.create!(team: team, user: user)
    token = token_for(user)

    post '/api/v1/folders', params: { folder: { team_id: team.id, name: 'New Folder' } }, headers: auth_header(token)

    expect(response).to have_http_status(:created)
    body = JSON.parse(response.body)
    expect(body.dig('folder', 'name')).to eq('New Folder')
  end

  it 'prevents creating a folder in a team the user is not part of' do
    team = create(:team)
    token = token_for(user)

    post '/api/v1/folders', params: { folder: { team_id: team.id, name: 'Bad' } }, headers: auth_header(token)

    expect(response).to have_http_status(:forbidden)
  end

  it 'shows subfolders in show response' do
    team = create(:team)
    TeamsUser.create!(team: team, user: user)
    parent = create(:folder, team: team, name: 'Parent')
    child = create(:folder, team: team, parent: parent, name: 'Child')

    token = token_for(user)
    get "/api/v1/folders/#{parent.id}", headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    subs = JSON.parse(response.body).dig('folder', 'sub_folders')
    expect(subs).to include(hash_including('id' => child.id, 'name' => 'Child'))
  end
end
