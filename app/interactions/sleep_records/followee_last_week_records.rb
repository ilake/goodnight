class SleepRecords::FolloweeLastWeekRecords < ActiveInteraction::Base
  object :user

  def execute
    last_week = Time.current.last_week
    followee_ids = user.follows.pluck(:followee_id)

    SleepRecord
      .where(user_id: followee_ids)
      .where(sleep_at: last_week.beginning_of_week..last_week.end_of_week)
      .order(:duration)
  end
end
