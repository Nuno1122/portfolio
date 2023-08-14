class StartTimePlansController < ApplicationController
  def new # 月の開始時間を設定するページ
    @start_time_plan = current_user.create_start_time_plan # 月の開始時間を設定するフォームを表示するページ
  end

  def create  # 月の開始時間を設定するアクション  
    @start_time_plan = current_user.build_start_time_plan(start_time_plan_params)  # 月の開始時間を設定するフォームを送信したときの処理
    if @start_time_plan.save  # 月の開始時間を設定するフォームを送信したときの処理
      redirect_to morning_activity_logs_path, success: t('.success')  # 月の開始時間を設定するフォームを送信したときの処理
    else
      render :new # 月の開始時間を設定するフォームを送信したときの処理
    end
  end

  def edit
    @start_time_plan = current_user.start_time_plan # 月の開始時間を更新するフォームを表示するページ
  end

  def update
    @start_time_plan = current_user.start_time_plan # 月の開始時間を更新するフォームを送信したときの処理

    # この月の開始時間を既に3回更新したかどうかを確認
    if @start_time_plan.exceeded_monthly_updates? # 月の開始時間を更新するフォームを送信したときの処理
      flash[:error] = t('.update_limit')  # 月の開始時間を更新するフォームを送信したときの処理
      redirect_to morning_activity_logs_path # あるいは適切なパス
      return
    end

    if @start_time_plan.update(start_time_plan_params)  # 月の開始時間を更新するフォームを送信したときの処理
      # 月の更新回数を増やす
      @start_time_plan.increment!(:monthly_updates_count) # 月の開始時間を更新するフォームを送信したときの処理
      
      redirect_to morning_activity_logs_path,  success: t('.success') # 月の開始時間を更新するフォームを送信したときの処理
    else
      flash.now[:error] = t('.fail')  # 月の開始時間を更新するフォームを送信したときの処理
      render :edit, status: :unprocessable_entity # 月の開始時間を更新するフォームを送信したときの処理
    end
  end

  private

  def start_time_plan_params 
    params.require(:start_time_plan).permit(:start_time)  # 月の開始時間を設定するフォームを送信したときの処理
  end
end
