# frozen_string_literal: true

class Follow < ApplicationRecord
  validates :followee_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :followee, class_name: 'User'
end
