# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user, required: false
  validates :content, length: { maximum: 140 }, presence: true
end
