# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user, required: false, optional: true
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, length: { maximum: 140 }, presence: true
end
