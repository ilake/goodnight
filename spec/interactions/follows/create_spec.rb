# frozen_string_literal: true

require "rails_helper"

RSpec.describe Follows::Create do
  let(:user) { FactoryBot.create(:user) }
  let(:followee) { FactoryBot.create(:user) }
  let(:args) do
    {
      user: user,
      followee: followee
    }
  end
  let(:outcome) { described_class.run(args) }

  describe "#execute" do
    it "follows a user" do
      expect {
        outcome
      }.to change {
        Follow.where(user_id: user.id, followee_id: followee.id).count
      }.by(1)
    end

    context "when the followee was followed by user" do
      before do
        Follow.create(user: user, followee_id: followee.id)
      end

      it "does nothing" do
        expect {
          outcome
        }.not_to change {
          Follow.where(user_id: user.id, followee_id: followee.id).count
        }
      end
    end
  end
end
