# frozen_string_literal: true

class SleepRecordSerializer
  include JSONAPI::Serializer
  attribute :sleep_at, :wakeup_at, :duration
end
