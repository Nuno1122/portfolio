class StartTimePlansController < ApplicationController
  def new
    @start_time_plan = current_user.create_start_time_plan
  end

  def create
    @start_time_plan = current_user.build_start_time_plan(start_time_plan_params)
    if @start_time_plan.save
      redirect_to morning_activity_logs_path, success: t('.success')
    else
      render :new
    end
  end

  def edit
    @start_time_plan = current_user.start_time_plan
  end

  def update
    @start_time_plan = current_user.start_time_plan

    # この月の開始時間を既に3回更新したかどうかを確認
    if @start_time_plan.exceeded_monthly_updates?
      flash[:error] = t('.update_limit')
      redirect_to morning_activity_logs_path # あるいは適切なパス
      return
    end

    if @start_time_plan.update(start_time_plan_params)
      # 月の更新回数を増やす
      @start_time_plan.increment!(:monthly_updates_count)
      
      redirect_to morning_activity_logs_path,  success: t('.success')
    else
      flash.now[:error] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def start_time_plan_params
    params.require(:start_time_plan).permit(:start_time)
  end
end
