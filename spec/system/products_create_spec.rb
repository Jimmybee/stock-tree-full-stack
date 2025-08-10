require 'rails_helper'

RSpec.describe 'Create product', type: :system do
  it 'creates a product with minimal fields' do
    driven_by(:rack_test)

    user = create(:user, password: 'Password123!', password_confirmation: 'Password123!')
  team = user.teams.first || create(:team).tap { |t| create(:teams_user, user: user, team: t) }
  # Use existing root folder for the team (created by after_create hook), or create if missing
  folder = team.folders.find_by(parent_id: nil) || create(:folder, team: team, parent: nil, name: 'Root')

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'

    visit new_product_path(team_id: team.id, folder_id: folder.id)
    select team.name, from: 'Team'
    select folder.name, from: 'Folder (optional)'
    fill_in 'Name', with: 'New Widget'
    fill_in 'Barcode', with: 'ABC123'
    fill_in 'Quantity', with: '5'
    click_button 'Create product'

    expect(page).to have_current_path(/\/products\//)
    expect(page).to have_content('New Widget')
  end
end
