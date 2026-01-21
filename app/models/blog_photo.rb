class BlogPhoto < ApplicationRecord
  belongs_to :blog
  has_one_attached :photo

  # validates :alt_ar, :alt_en, presence: true
end
