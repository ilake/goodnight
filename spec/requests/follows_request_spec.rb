require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let!(:user_id) { user.id }
  let!(:followee_id) { FactoryBot.create(:user).id }

  context "POST /follows" do
    it "returns ok" do
      post follows_path(user_id: user_id), params: { followee_id: followee_id }

      result = JSON.parse(response.body)

      expect(response).to be_ok
      expect(result).to eq(
        {
          'data' => {
            "id" => Follow.where(user_id: user_id, followee_id: followee_id).take.id.to_s,
            "type" => "follow",
            "attributes" => {
              "user_id" => user_id,
              "followee_id" => followee_id
            }
          }
        }
      )
    end

    context "when the followee was followed by user" do
      before do
        Follow.create(user_id: user_id, followee_id: followee_id)
      end

      it "returns 422" do
        post follows_path(user_id: user_id), params: { followee_id: followee_id }

        result = JSON.parse(response.body)
        expect(result["error_message"]).to eq("Followee has already been taken")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "DELETE /follows/:id" do
    it "returns ok" do
      follow = Follow.create(user_id: user_id, followee_id: followee_id)

      expect {
        delete follow_path(user_id: user_id, id: follow.id)
      }.to change {
        Follow.where(user_id: user_id, followee_id: followee_id).count
      }.by(-1)

      expect(response).to be_ok
    end

    context "when deleting an unexisting record" do
      it "returns 404" do
        delete follow_path(user_id: user_id, id: 0)

        result = JSON.parse(response.body)
        expect(result["error_message"]).to eq("Record Not Found")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context "GET /follows/sleep_records" do
    it "returns ok" do
      sleep_at = Time.current.last_week.to_i
      record1 = FactoryBot.create(:sleep_record, sleep_at: sleep_at, wakeup_at: sleep_at + 8.hours.to_i)
      record2 = FactoryBot.create(:sleep_record, sleep_at: sleep_at, wakeup_at: sleep_at + 7.hours.to_i)
      FactoryBot.create(:follow, user: user, followee: record1.user)
      FactoryBot.create(:follow, user: user, followee: record2.user)

      get sleep_records_follows_path(user_id: user_id)

      result = JSON.parse(response.body)

      expect(response).to be_ok
      expect(result).to eq(
        {
          "data" => [record2, record1].map do |record|
            {
              "id" => record.id.to_s,
              "type" => "sleep_record",
              "attributes" => {
                "sleep_at" => record.sleep_at,
                "wakeup_at" => record.wakeup_at,
                "duration" => record.duration
              }
            }
          end
        }
      )
    end
  end
end
