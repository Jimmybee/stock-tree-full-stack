require 'rails_helper'

RSpec.describe TeamPolicy do
  subject(:policy) { described_class }

  let(:user) { create(:user) }
  let(:team) { Team.create!(name: 'T') }

  it 'scopes to teams the user belongs to' do
    TeamsUser.create!(team: team, user: user)
    scope = Pundit.policy_scope(user, Team)
    expect(scope).to include(team)
  end

  it 'allows create' do
    expect(described_class.new(user, Team.new(name: 'X')).create?).to be(true)
  end
end
