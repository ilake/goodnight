# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    association :user
    followee { FactoryBot.create(:user) }
  end
end
