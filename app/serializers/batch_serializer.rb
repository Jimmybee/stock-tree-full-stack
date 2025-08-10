# == Schema Information
#
# Table name: batches
#
#  id          :uuid             not null, primary key
#  product_id  :uuid             not null
#  folder_id   :uuid             not null
#  qty         :integer          default(0), not null
#  expiry_date :date
#  lot_code    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class BatchSerializer
  include JSONAPI::Serializer
  set_type :batch
  set_id :id
  attributes :product_id, :folder_id, :qty, :expiry_date, :lot_code
end
