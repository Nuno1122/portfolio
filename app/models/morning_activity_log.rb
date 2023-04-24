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
class MorningActivityLog < ApplicationRecord
  # アソシエーションの設定
  belongs_to :user
  belongs_to :start_time_plan
  
  # 定数の設定
  ALLOWED_START_HOUR = 3
  ALLOWED_START_MIN = 0
  ALLOWED_START_SEC = 0
  ALLOWED_END_OFFSET = 59.seconds

  # 朝活を許可する時間帯かどうかを判断するメソッド
  def self.is_morning_activity_not_allowed?(user)
    return true if Time.current.hour < ALLOWED_START_HOUR
    last_log = user.morning_activity_logs.order(started_time: :desc).first
    return false if last_log.nil?
    Time.current.to_date == last_log.started_time.to_date
  end

  # 今月の達成状況を取得するメソッド
def self.current_monthly_achievement(user)
  user.monthly_achievements.find_or_initialize_by(month: Time.current.month, year: Time.current.year)
end


  # 達成したかどうかを判断するメソッド
  def achieved?
    # started_time または start_time_plan が空の場合、達成していないと判断
    return false if started_time.blank? || start_time_plan.blank?

    # 現在の日時を取得
    current_time = Time.current
    # started_time の日付と時刻を現在の日付と時刻に調整
    adjusted_started_time = started_time.change(year: current_time.year, month: current_time.month, day: current_time.day, hour: current_time.hour, min: current_time.min, sec: current_time.sec)
    # 許可された開始時刻を設定
    allowed_start_time = start_time_plan.start_time.change(day: current_time.day, hour: ALLOWED_START_HOUR, min: ALLOWED_START_MIN, sec: ALLOWED_START_SEC)
    # 許可された終了時刻を設定
    allowed_end_time = start_time_plan.start_time.change(day: current_time.day) + ALLOWED_END_OFFSET

    # adjusted_started_time が allowed_start_time と allowed_end_time の間にある場合、達成と判断
    adjusted_started_time.between?(allowed_start_time, allowed_end_time)
  end
end