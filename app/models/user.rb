# frozen_string_literal: true

class User < ApplicationRecord
  validates :name, presence: true

  has_many :sleep_records
  has_many :follows
end
