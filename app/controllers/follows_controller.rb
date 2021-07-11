class FollowsController < ApplicationController
  def create
    outcome = Follows::Create.run(
      user: current_user,
      followee: User.find(params[:followee_id])
    )

    if outcome.valid?
      render json: FollowSerializer.new(outcome.result)
    else
      render json: { error_message: outcome.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    follow = current_user.follows.find(params[:id])

    if follow.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def sleep_records
    records = SleepRecords::FolloweeLastWeekRecords.run!(user: current_user)

    render json: SleepRecordSerializer.new(records)
  end
end
