class Book < ApplicationRecord
    validates :title,  presence: true, length: { maximum: 50 }
    validates :author,  presence: true, length: { maximum: 50 }
    validates :price,  presence: true
    validates :stock,  presence: true
    mount_uploader :picture, PictureUploader
end
