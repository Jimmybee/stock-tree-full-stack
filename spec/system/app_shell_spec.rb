require 'rails_helper'

RSpec.describe 'App shell', type: :system do
  it 'renders header, sidebar, and content when signed in' do
    driven_by(:rack_test)

    create(:user, email: 'ui@example.com', password: 'Password123!', password_confirmation: 'Password123!')

    visit new_user_session_path
    fill_in 'Email', with: 'ui@example.com'
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'

    expect(page).to have_content('Stock Tree')
    expect(page).to have_content('Dashboard')
    expect(page).to have_content('Team switcher (placeholder)')
  end
end
