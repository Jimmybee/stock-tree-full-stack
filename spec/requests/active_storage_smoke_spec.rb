require 'rails_helper'

RSpec.describe 'ActiveStorage', type: :request do
  it 'can create and purge a blob' do
    # Create a blob and ensure it uploads to Disk service in test
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new('hello'),
      filename: 'hello.txt',
      content_type: 'text/plain'
    )

    expect(blob).to be_persisted
    expect(blob.byte_size).to eq(5)

    # Signed URL path generation should work
    url = Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
    expect(url).to include('/rails/active_storage')

    # Cleanup
    blob.purge
    expect { blob.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
