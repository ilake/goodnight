# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer :user_id, null: false
      t.integer :followee_id, null: false

      t.timestamps

      t.index [:user_id, :followee_id], unique: true
    end
  end
end
