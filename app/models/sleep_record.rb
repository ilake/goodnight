# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  validates :sleep_at, presence: true
  validate :validate_wakeup_at

  belongs_to :user

  def validate_wakeup_at
    if wakeup_at && wakeup_at <= sleep_at
      errors.add(:wakeup_at, :invalid)
    end
  end
end
