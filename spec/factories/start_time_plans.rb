# == Schema Information
#
# Table name: start_time_plans
#
#  id                    :bigint           not null, primary key
#  monthly_updates_count :integer          default(0)
#  start_time            :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :uuid             not null
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
    association :user
    start_time { Time.current.change(hour: 5, minute: 0, second: 0) }
  end
end
