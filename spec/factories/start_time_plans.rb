# == Schema Information
#
# Table name: start_time_plans
#
#  id         :bigint           not null, primary key
#  start_time :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_start_time_plans_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :start_time_plan do
    user { nil }
    start_time { '2023-04-09 17:24:50' }
  end
end
