require 'rails_helper'

RSpec.describe 'Devise flows', type: :system do
  it 'allows a user to sign up' do
    driven_by(:rack_test)

    visit new_user_registration_path
    fill_in 'First name', with: 'Jane'
    fill_in 'Last name', with: 'Doe'
    fill_in 'Email', with: 'jane@example.com'
    fill_in 'Password', with: 'Password123!'
    fill_in 'Password confirmation', with: 'Password123!'
    click_button 'Create account'

    expect(page).to have_current_path(root_path)
  end

  it 'allows a user to sign in' do
    driven_by(:rack_test)

    create(:user, email: 'john@example.com', password: 'Password123!', password_confirmation: 'Password123!')

    visit new_user_session_path
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'

    expect(page).to have_current_path(root_path)
  end

  it 'allows a user to sign out' do
    driven_by(:rack_test)

    user = create(:user, email: 'logout@example.com', password: 'Password123!', password_confirmation: 'Password123!')

    visit new_user_session_path
    fill_in 'Email', with: 'logout@example.com'
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'
    expect(page).to have_current_path(root_path)

    click_button 'Sign out'
    expect(page).to have_current_path(root_path)
  end
end
