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
class StartTimePlan < ApplicationRecord
  belongs_to :user
  validate :start_time_within_allowed_range
  validates :start_time, presence: true

  ALLOWED_START_HOUR = 4
  ALLOWED_END_HOUR = 10
  MAX_UPDATES_PER_MONTH = 3 # 1ヶ月に更新できる回数

  def remaining_updates #残り更新回数
    MAX_UPDATES_PER_MONTH - monthly_updates_count #目標開始時刻の月の上限更新回数-目標開始時刻の月の更新回数
  end

  def exceeded_monthly_updates? #目標開始時刻の月の上限更新回数を超えたか
    monthly_updates_count >= MAX_UPDATES_PER_MONTH #目標開始時刻の月の更新回数が目標開始時刻の月の上限更新回数以上か
  end

  private

  def start_time_within_allowed_range #目標開始時刻が許容範囲内か
    return if start_time.blank? #目標開始時刻が空白ならば

    allowed_start_time = ALLOWED_START_HOUR.hours #許容開始時刻
    allowed_end_time = ALLOWED_END_HOUR.hours #許容終了時刻

    return if start_time.seconds_since_midnight.between?(allowed_start_time, allowed_end_time) #目標開始時刻が許容開始時刻と許容終了時刻の間ならば

    errors.add(:start_time, :not_within_allowed_range) #目標開始時刻が許容範囲内でないとエラー
  end
end
