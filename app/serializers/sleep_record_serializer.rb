class SleepRecordSerializer
  include JSONAPI::Serializer
  attribute :sleep_at, :wakeup_at, :duration
end
