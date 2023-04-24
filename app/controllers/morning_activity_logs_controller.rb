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

    @morning_activity_log = current_user.morning_activity_logs.new(start_time_plan_id: params[:start_time_plan_id], started_time: Time.current)
    @morning_activity_log.start_time_plan = current_user.start_time_plan

    if @morning_activity_log.save
      if @morning_activity_log.achieved?
        MorningActivityLog.current_monthly_achievement(current_user).increment_achieved_count
        redirect_to morning_activity_logs_path(achieved: 'true')
        flash[:success] = t('.success')
      else
        flash[:success] = t('.success')
        redirect_to morning_activity_logs_path(achieved: @morning_activity_log.achieved?)
      end
    else
      flash[:error] = t('.fail')
      redirect_to morning_activity_logs_path
    end
  end

  
end