# frozen_string_literal: true

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
end
