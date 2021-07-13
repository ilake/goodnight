# frozen_string_literal: true

class SleepRecords::Wakeup < ActiveInteraction::Base
  object :user

  def execute
    SleepRecord.transaction do
      record = user.sleep_records
        .where(wakeup_at: nil)
        .where("sleep_at < ?", Time.current.to_i)
        .order(sleep_at: :desc).first

      unless record
        errors.add(:user, :unfound_sleep_record)
        raise ActiveRecord::Rollback
      end

      wakeup_at = Time.current.to_i
      record.update(wakeup_at: wakeup_at, duration: wakeup_at - record.sleep_at)

      unless record.errors.empty?
        errors.merge!(record.errors)
      end

      record
    end
  end
end
