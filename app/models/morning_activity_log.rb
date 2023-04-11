# == Schema Information
#
# Table name: morning_activity_logs
#
#  id                 :bigint           not null, primary key
#  started_time       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_time_plan_id :bigint           not null
#  user_id            :bigint           not null
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
class MorningActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :start_time_plan

  ALLOWED_START_TIME = Time.zone.parse("03:00:00")
  ALLOWED_END_OFFSET = 59.seconds

  def achieved?
    return false if started_time.blank? || start_time_plan.blank?
  
    allowed_start_time = start_time_plan.start_time.change(hour: ALLOWED_START_TIME.hour, min: ALLOWED_START_TIME.min, sec: ALLOWED_START_TIME.sec)
    allowed_end_time = start_time_plan.start_time + ALLOWED_END_OFFSET
  
    (started_time >= allowed_start_time) && (started_time <= allowed_end_time)
  end
end
