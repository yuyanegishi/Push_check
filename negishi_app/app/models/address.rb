class Address < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :consignee,  presence: true, length: { maximum: 50 }
  validates :first_postal_code,  presence: true
  validates :last_postal_code,  presence: true
  validates :first_address,  presence: true
  validates :phone,  presence: true
end
