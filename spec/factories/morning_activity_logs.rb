# == Schema Information
#
# Table name: morning_activity_logs
#
#  id                 :bigint           not null, primary key
#  started_time       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_time_plan_id :bigint           not null
#  user_id            :uuid             not null
#
# Indexes
#
#  index_morning_activity_logs_on_start_time_plan_id  (start_time_plan_id)
#  index_morning_activity_logs_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (start_time_plan_id => start_time_plans.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :morning_activity_log do
    association :user # userモデルとのアソシエーション
    association :start_time_plan # start_time_planモデルとのアソシエーション

    started_time { Time.current.change(hour: MorningActivityLog::ALLOWED_START_HOUR, min: MorningActivityLog::ALLOWED_START_MIN, sec: MorningActivityLog::ALLOWED_START_SEC) }
    # 任意の属性が必要な場合は、以下に追加
  end
end
