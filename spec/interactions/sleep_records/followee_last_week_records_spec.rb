require "rails_helper"

RSpec.describe SleepRecords::FolloweeLastWeekRecords do
  let(:user) { FactoryBot.create(:user) }
  let(:args) do
    {
      user: user
    }
  end
  let(:outcome) { described_class.run(args) }

  describe "#execute" do
    it "returns followee records" do
      record1 = FactoryBot.create(:sleep_record, sleep_at: Time.current.last_week.to_i)
      record2 = FactoryBot.create(:sleep_record, sleep_at: Time.current.last_week.to_i)
      record3 = FactoryBot.create(:sleep_record, sleep_at: Time.current.last_week.to_i)
      FactoryBot.create(:follow, user: user, followee: record1.user)
      FactoryBot.create(:follow, user: user, followee: record2.user)

      expect(outcome.result).to include(record1, record2)
    end

    it "returns last week records" do
      record1 = FactoryBot.create(:sleep_record, sleep_at: Time.current.last_week.to_i)
      record2 = FactoryBot.create(:sleep_record, sleep_at: Time.current.last_week.to_i)
      record3 = FactoryBot.create(:sleep_record)
      FactoryBot.create(:follow, user: user, followee: record1.user)
      FactoryBot.create(:follow, user: user, followee: record2.user)
      FactoryBot.create(:follow, user: user, followee: record3.user)

      expect(outcome.result).to include(record1, record2)
    end

    it "returns records order by duration" do
      sleep_at = Time.current.last_week.to_i
      record1 = FactoryBot.create(:sleep_record, sleep_at: sleep_at, wakeup_at: sleep_at + 8.hours.to_i)
      record2 = FactoryBot.create(:sleep_record, sleep_at: sleep_at, wakeup_at: sleep_at + 7.hours.to_i)
      FactoryBot.create(:follow, user: user, followee: record1.user)
      FactoryBot.create(:follow, user: user, followee: record2.user)

      expect(outcome.result).to eq([record2, record1])
    end
  end
end
