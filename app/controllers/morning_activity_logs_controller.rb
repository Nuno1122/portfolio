class MorningActivityLogsController < ApplicationController
    def index
        @morning_activity_logs = current_user.morning_activity_logs.includes(:start_time_plan)
    end

    def create
        @morning_activity_log = current_user.morning_activity_logs.new(started_time: Time.now)
        @morning_activity_log.start_time_plan = current_user.start_time_plan
     
       if @morning_activity_log.save
         flash[:success] = '朝活を開始しました'
       else
         flash[:error] = '朝活を開始できませんでした'
       end
       redirect_to morning_activity_logs_path
     end

end
