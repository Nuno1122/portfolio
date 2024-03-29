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
  ALLOWED_START_HOUR = 3 # 許容開始時刻
  ALLOWED_START_MIN = 0 # 許容開始分
  ALLOWED_START_SEC = 0 # 許容開始秒
  ALLOWED_END_OFFSET = 59.seconds # 許容終了時刻のオフセット

  # 以下は、達成回数に関する定数を設定。
  DEFAULT_ACHIEVED_COUNT = 0 # デフォルトの達成回数
  DECREMENT_COUNT = 1 # 達成回数を減らす数

  # 新しい月の初期化が必要かどうかを確認し、必要であれば実行するためのコールバックメソッドを設定。
  after_create :initialize_new_month_if_needed # 朝活ログが作成された後に実行される。

  # 今月の達成状況を取得するメソッド。(クラスメソッド)
  def self.current_monthly_achievement(user)
    user.monthly_achievements.find_or_initialize_by(month: Time.current.month, year: Time.current.year)
  end

  # ユーザーの月間達成回数を増やすメソッドです。
  def self.increment_achieved_count(user)
    current_month = Time.current.month # 現在の月を取得
    # 現在の月に対応する月間達成情報を取得し、なければ作成します。
    current_monthly_achievement = user.monthly_achievements.find_or_create_by(month: current_month) do |achievement| # 月間達成情報がなければ作成
      achievement.year = Time.current.year # 月間達成情報の年を設定
      achievement.achieved_count = DEFAULT_ACHIEVED_COUNT # 月間達成情報の達成回数を設定
    end
    current_monthly_achievement.increment!(:achieved_count) # 達成回数を1増やします。
  end

  # 朝活を許可する時間帯かどうかを判断するメソッド
  def self.is_morning_activity_not_allowed?(user)
    return true if Time.current.hour < ALLOWED_START_HOUR

    last_log = user.morning_activity_logs.order(started_time: :desc).first
    return false if last_log.nil?

    Time.current.to_date == last_log.started_time.to_date
  end

  # 朝活ログを作成し、達成状況をチェックするメソッドです。
  def self.create_log_and_check_achievement(user, start_time_plan_id)
    # 朝活ログの新しいインスタンスを作成し、属性を設定します。
    morning_activity_log = user.morning_activity_logs.new(start_time_plan_id:, started_time: Time.current)
    morning_activity_log.start_time_plan = user.start_time_plan

      # 朝活ログを保存します。
      return [false, nil] unless morning_activity_log.save

        if morning_activity_log.achieved? # 達成された場合
          current_monthly_achievement(user).increment_achieved_count
          achieved_count = current_monthly_achievement(user).achieved_count
          redirect_params = { achieved: 'true', previous_achieved_count: achieved_count - DECREMENT_COUNT, achieved_count: } # previous_achieved_count:には前回までの達成回数を、achieved_count:には今回の達成回数を設定します。
        else
          redirect_params = { achieved: morning_activity_log.achieved? }
        end
        [true, redirect_params] # 成功とリダイレクトパラメータを返します。

    # 失敗とnilを返します。
  end

  # 朝活が達成されたかどうかを判断するメソッドです。(インスタンスメソッド)
  def achieved?
    # started_time または start_time_plan が空の場合、達成していないと判断。
    return false if started_time.blank? || start_time_plan.blank?

    # 許可された開始時刻と終了時刻を取得します。
    allowed_start_time = start_time_plan.start_time
    allowed_end_time = start_time_plan.start_time + ALLOWED_END_OFFSET

    # 今日の日付を取得します。
    today = Time.zone.now.to_date

    # 許可された開始時刻と終了時刻を今日の日付に設定します。
    allowed_start_time = start_time_plan.start_time.change(day: today.day, hour: ALLOWED_START_HOUR, min: ALLOWED_START_MIN, sec: ALLOWED_START_SEC)
    allowed_end_time = allowed_end_time.change(year: today.year, month: today.month, day: today.day)

    # started_time が allowed_start_time と allowed_end_time の間にある場合、達成と判断。
    started_time.between?(allowed_start_time, allowed_end_time)
  end

  def start_time
    started_time
  end

  private

  # 新しい月を初期化する必要がある場合、その処理を行うメソッドです。
  def initialize_new_month_if_needed
    return unless user.monthly_achievements.find_by(year: Time.current.year, month: Time.current.month).nil?

      MonthlyAchievement.initialize_new_month(user)
  end
end
