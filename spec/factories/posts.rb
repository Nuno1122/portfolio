FactoryBot.define do
  factory :post do
		sequence(:content) { |n| "本文#{n}" }
    association :user
  end
end