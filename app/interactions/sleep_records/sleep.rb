class SleepRecords::Sleep < ActiveInteraction::Base
  object :user

  def execute
    SleepRecord.transaction do
      record = SleepRecord.create(
        user: user,
        sleep_at: Time.current.to_i
      )

      if record.invalid?
        errors.merge!(record.errors)
        raise ActiveRecord::Rollback
      end

      record
    end
  end
end
