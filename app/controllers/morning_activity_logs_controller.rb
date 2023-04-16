class MorningActivityLogsController < ApplicationController
  before_action :require_login
  DISALLOWED_HOUR = 3

  def index
    @morning_activity_logs = current_user.morning_activity_logs.includes(:start_time_plan)
    @achieved_count = @morning_activity_logs.select(&:achieved?).count
    @morning_activity_not_allowed = is_morning_activity_not_allowed?
  end

  def create
    #フロントエンドの制御が機能しなかった場合に問題が発生する可能性があるため設置
    if is_morning_activity_not_allowed?
      flash[:error] = t('.is_morning_activity_not_allowed.fail')
      redirect_to morning_activity_logs_path
      return
    end

    @morning_activity_log = current_user.morning_activity_logs.new(started_time: Time.current)
    @morning_activity_log.start_time_plan = current_user.start_time_plan

    if @morning_activity_log.save
      flash[:success] = t('.success')
    else
      flash[:error] = t('.fail')
    end
    redirect_to morning_activity_logs_path
  end

  private

  def is_morning_activity_not_allowed?
     # 現在の時間が03:00:00よりも前であれば、朝活は許可されていないため、trueを返す
    return true if Time.current.hour < DISALLOWED_HOUR
     # 最後に記録された朝活ログを取得する（降順でソートし、最初の要素を取得）
    last_log = current_user.morning_activity_logs.order(started_time: :desc).first
    return false if last_log.nil?
     # 現在の日付と最後に記録された朝活ログの日付が同じであれば、朝活は許可されていないため、trueを返す
     # それ以外の場合（つまり、最後に記録された朝活ログが前の日である場合）は、朝活が許可されているため、falseを返す
    Time.current.to_date == last_log.started_time.to_date
  end
end