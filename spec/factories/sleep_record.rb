# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_record do
    association :user
    sleep_at { Time.current.advance(hours: -8).to_i }
    wakeup_at { sleep_at + 8.hours.to_i }
    duration { wakeup_at ? wakeup_at - sleep_at : nil }
  end
end
