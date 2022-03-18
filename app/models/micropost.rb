# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user, required: false, optional: true
  has_one_attached :image
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, length: { maximum: 140 }, presence: true
  # validates :image, content_type: { in: %w[image/jpeg image/gif image/png], message: 'must be a valid image format' },
  #                  size: { less_than: 5.megabytes, message: 'should be less than 5MB' }
  validates :image, blob: { content_type: %w[image/jpg image/jpeg image/png image/gif],
                            size_range: 1..3.megabytes }
end
