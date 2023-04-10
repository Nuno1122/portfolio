class StartTimePlansController < ApplicationController
  def new
    @start_time_plan = current_user.build_start_time_plan
  end

  def create
    @start_time_plan = current_user.build_start_time_plan(start_time_plan_params)
    if @start_time_plan.save
      redirect_to home_screens_path, success: t('.success')
    else
      render :new
    end
  end

  def edit
    @start_time_plan = current_user.start_time_plan
  end

  def update
    @start_time_plan = current_user.start_time_plan
    if @start_time_plan.update(start_time_plan_params)
      redirect_to home_screens_path, success: t('.success')
    else
      render :edit
    end
  end

  private

  def start_time_plan_params
    params.require(:start_time_plan).permit(:start_time)
  end
end
