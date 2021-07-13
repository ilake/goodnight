# frozen_string_literal: true

class FollowSerializer
  include JSONAPI::Serializer
  attribute :user_id, :followee_id
end
