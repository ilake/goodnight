require 'rails_helper'

RSpec.describe "SleepRecords", type: :request do
  let(:user) { FactoryBot.create(:user) }

  context "GET /sleep_records" do
    it "returns ok" do
      record1 = FactoryBot.create(:sleep_record, user: user)
      record2 = FactoryBot.create(:sleep_record, user: user)
      record3 = FactoryBot.create(:sleep_record, user: FactoryBot.create(:user))

      get sleep_records_path(user_id: user.id)

      result = JSON.parse(response.body)

      expect(response).to be_ok
      expect(result["data"].map {|h| h["id"]} ).not_to include(record3.id.to_s)
      expect(result).to eq(
        {
          "data" => [record1, record2].map do |record|
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

  context "POST /sleep_records/sleep" do
    it "returns ok" do
      post sleep_sleep_records_path(user_id: user.id)

      result = JSON.parse(response.body)

      expect(response).to be_ok
      record = user.sleep_records.last
      expect(result).to eq(
        {
          'data' => {
            "id" => record.id.to_s,
            "type" => "sleep_record",
            "attributes" => {
              "sleep_at" => record.sleep_at,
              "wakeup_at" => nil,
              "duration" => nil
            }
          }
        }
      )
    end
  end

  context "POST /sleep_records/wakeup" do
    context "when there is a valid sleep record(no wake up data)" do
      it "returns ok" do
        record = FactoryBot.create(:sleep_record, user: user, wakeup_at: nil)

        post wakeup_sleep_records_path(user_id: user.id)

        result = JSON.parse(response.body)

        record.reload
        expect(response).to be_ok
        expect(result).to eq(
          {
            'data' => {
              "id" => record.id.to_s,
              "type" => "sleep_record",
              "attributes" => {
                "sleep_at" => record.sleep_at,
                "wakeup_at" => record.wakeup_at,
                "duration" => record.duration
              }
            }
          }
        )
      end
    end

    context "when there is no valid sleep record" do
      it "returns 422" do
        record = FactoryBot.create(:sleep_record, user: user)

        post wakeup_sleep_records_path(user_id: user.id)

        result = JSON.parse(response.body)
        expect(result["error_message"]).to eq("User unable find valid sleep record")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
