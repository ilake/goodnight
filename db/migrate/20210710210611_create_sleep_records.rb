# frozen_string_literal: true

class CreateSleepRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :sleep_records do |t|
      t.integer :user_id, null: false
      t.integer :sleep_at, null: false
      t.integer :wakeup_at
      t.integer :duration
      t.timestamps

      t.index [:user_id, :sleep_at, :duration]
    end
  end
end
