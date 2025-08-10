require 'rails_helper'

RSpec.describe 'Products index filters and pagination', type: :system do
  it 'filters by q, min_level, folder, and tags, and paginates within frame' do
    driven_by(:rack_test)

    user = create(:user, password: 'Password123!', password_confirmation: 'Password123!')
    team = create(:team)
    create(:teams_user, user: user, team: team)
    root = create(:folder, team: team, parent: nil, name: 'Root')
    sub  = create(:folder, team: team, parent: root, name: 'Sub')
    tag_a = create(:tag, team: team, name: 'Red')
    tag_b = create(:tag, team: team, name: 'Blue')

    # Products across folders with tags
    p1 = create(:product, team: team, folder: root, name: 'Hammer', qty: 5, min_level: 1)
    p1.tags << tag_a
    p2 = create(:product, team: team, folder: root, name: 'Screwdriver', qty: 2, min_level: 3)
    p2.tags << tag_b
    p3 = create(:product, team: team, folder: sub, name: 'Bolt', qty: 50, min_level: 10)
    p3.tags << tag_a

    # Add more to exercise pagy
    22.times { create(:product, team: team, folder: root, name: Faker::Commerce.product_name) }

    # Sign in
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'Password123!'
    click_button 'Sign in'

    # Visit products index with search param
    visit products_path(q: 'Bolt')
    within('turbo-frame#products_list') do
      expect(page).to have_content('Bolt')
    end

    # Min level filter via query param
    visit products_path(min_level: 5)
    within('turbo-frame#products_list') do
      expect(page).not_to have_content('Screwdriver') # min_level 3 filtered out
    end

    # Folder filter via link click
    click_link 'Sub'
    within('turbo-frame#products_list') do
      expect(page).to have_content('Bolt')
      expect(page).not_to have_content('Hammer')
    end

    # Tag filter: via query params
    visit products_path(tag_ids: [tag_a.id])
    within('turbo-frame#products_list') do
      expect(page).to have_content('Hammer')
      expect(page).to have_content('Bolt')
      expect(page).not_to have_content('Screwdriver')
    end

    # Pagination links stay in frame
    if page.has_link?('Next')
      first_html = page.find('turbo-frame#products_list').text
      click_link 'Next'
      within('turbo-frame#products_list') do
        expect(page.text).not_to eq(first_html)
      end
    end
  end
end
