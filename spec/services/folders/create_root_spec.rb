require 'rails_helper'

RSpec.describe Folders::CreateRoot do
  it 'creates a Root folder if missing and does not duplicate' do
    team = Team.create!(name: 'X')

    root1 = described_class.call(team)
    expect(root1).to be_persisted
    expect(root1.name).to eq('Root')
    expect(root1.parent_id).to be_nil

    root2 = described_class.call(team)
    expect(root2.id).to eq(root1.id)
    expect(team.folders.where(name: 'Root', parent_id: nil).count).to eq(1)
  end
end
