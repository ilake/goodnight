FactoryBot.define do
  factory :follow do
    association :user
    followee { FactoryBot.create(:user) }
  end
end
