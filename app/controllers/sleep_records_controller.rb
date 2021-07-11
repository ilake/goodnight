class SleepRecordsController < ApplicationController
  def index
    sleep_records = current_user.sleep_records.order(:created_at)

    render json: SleepRecordSerializer.new(sleep_records)
  end

  def sleep
    outcome = SleepRecords::Sleep.run(user: current_user)

    if outcome.valid?
      render json: SleepRecordSerializer.new(outcome.result)
    else
      render json: { error_message: outcome.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def wakeup
    outcome = SleepRecords::Wakeup.run(user: current_user)

    if outcome.valid?
      render json: SleepRecordSerializer.new(outcome.result)
    else
      render json: { error_message: outcome.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def followee_last_week
    records = SleepRecords::FolloweeLastWeekRecords.run!(user: current_user)

    render json: SleepRecordSerializer.new(records)
  end
end
