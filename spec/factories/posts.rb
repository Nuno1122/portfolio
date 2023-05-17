# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  likes_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    sequence(:content) { |n| "本文#{n}" }
    association :user
  end
end
