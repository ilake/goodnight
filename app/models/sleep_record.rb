class SleepRecord < ApplicationRecord
  validates :sleep_at, presence: true

  belongs_to :user
end
