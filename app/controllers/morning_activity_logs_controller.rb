class MorningActivityLogsController < ApplicationController
  before_action :require_login
  DEFAULT_ACHIEVED_COUNT = 0

  def index
    @morning_activity_logs = current_user.morning_activity_logs.includes(:start_time_plan)
    @morning_activity_not_allowed = MorningActivityLog.is_morning_activity_not_allowed?(current_user)
    @previous_achieved_count = [(params[:previous_achieved_count] || MorningActivityLog.current_monthly_achievement(current_user).achieved_count || DEFAULT_ACHIEVED_COUNT).to_i,
                                DEFAULT_ACHIEVED_COUNT].max
    @achieved_count = [(params[:achieved_count] || MonthlyAchievement.achieved_count_or_default(current_user.id, Time.current.year, Time.current.month)).to_i, DEFAULT_ACHIEVED_COUNT].max
  end

  def create
    if MorningActivityLog.is_morning_activity_not_allowed?(current_user)
      flash[:error] = t('.is_morning_activity_not_allowed.fail')
      redirect_to morning_activity_logs_path
      return
    end

    success, redirect_params = MorningActivityLog.create_log_and_check_achievement(current_user, params[:start_time_plan_id])
    if success
      flash[:success] = t('.success')
      redirect_to morning_activity_logs_path(redirect_params)
    else
      flash[:error] = t('.fail')
      redirect_to morning_activity_logs_path
    end
  end
end
