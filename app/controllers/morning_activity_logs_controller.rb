class MorningActivityLogsController < ApplicationController
  before_action :require_login
  

  def index
    @morning_activity_logs = current_user.morning_activity_logs.includes(:start_time_plan)
    @achieved_count = @morning_activity_logs.select(&:achieved?).count
    @morning_activity_not_allowed = MorningActivityLog.is_morning_activity_not_allowed?(current_user)
  end

  def create
    #フロントエンドの制御が機能しなかった場合に問題が発生する可能性があるため設置
    if MorningActivityLog.is_morning_activity_not_allowed?(current_user)
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

  
end