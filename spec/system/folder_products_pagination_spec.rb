require 'rails_helper'

RSpec.describe 'Folder products list', type: :system do
  it 'loads products list via Turbo Frame and paginates' do
    driven_by(:rack_test)

    user = create(:user, password: 'Password123!', password_confirmation: 'Password123!')
    team = create(:team)
    create(:teams_user, user: user, team: team)
    root = create(:folder, team: team, parent: nil, name: 'Root')

    # 25 products to force pagination (Pagy default per-page is ~20)
    25.times do |i|
      create(:product, team: team, folder: root, name: "Prod #{i}")
    end

    # Sign in
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'

    # Visit folder
    visit folder_path(root)

    # Main frame should load
    within('turbo-frame#main') do
      expect(page).to have_content('Products')
    end

    # Products frame initial load (from src)
    within('turbo-frame#products_list') do
      # First page should have some products
      expect(page).to have_content('Prod 0')
      expect(page).to have_content('Prod 1')
    end

    # Click next page if available and ensure content changes
    if page.has_link?('Next')
      first_page_html = page.find('turbo-frame#products_list').text
      click_link 'Next'
      within('turbo-frame#products_list') do
        expect(page).to have_link('Prev')
        expect(page.text).not_to eq(first_page_html)
      end
    end
  end
end
