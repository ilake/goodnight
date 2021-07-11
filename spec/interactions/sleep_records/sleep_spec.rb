require "rails_helper"

RSpec.describe SleepRecords::Sleep do
  let(:user) { FactoryBot.create(:user) }
  let(:args) do
    {
      user: user
    }
  end
  let(:outcome) { described_class.run(args) }

  describe "#execute" do
    it "creates a sleep record" do
      expect {
        outcome
      }.to change {
        user.sleep_records.count
      }.by(1)
    end
  end
end
