# frozen_string_literal: true

require "rails_helper"

RSpec.describe SleepRecords::Wakeup do
  let(:user) { FactoryBot.create(:user) }
  let(:args) do
    {
      user: user
    }
  end
  let(:outcome) { described_class.run(args) }

  describe "#execute" do
    context "when there is a no wakeup sleep record" do
      it "updates wakeup information" do
        record1 = FactoryBot.create(:sleep_record, user: user, sleep_at: Time.current.advance(hours: -16), wakeup_at: nil)
        record2 = FactoryBot.create(:sleep_record, user: user, sleep_at: Time.current.advance(hours: -7), wakeup_at: nil)

        outcome

        record1.reload
        record2.reload

        expect(record1.wakeup_at).to be_nil
        expect(record2.wakeup_at).to be_present
        expect(record2.duration).to eq(record2.wakeup_at - record2.sleep_at)
      end
    end

    context "when there is no valid sleep record" do
      it "is invalid" do
        record = FactoryBot.create(:sleep_record, user: user)

        expect(outcome).to be_invalid
        expect(outcome.errors.details[:user]).to include(error: :unfound_sleep_record)
      end
    end
  end
end
