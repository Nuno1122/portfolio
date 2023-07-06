namespace :start_time_plan do
    FIRST_DAY_OF_MONTH = 1
  
    desc "Reset monthly_updates_count for all start_time_plan"
    task reset_monthly_updates_count: :environment do
      if Date.today.day == FIRST_DAY_OF_MONTH
        StartTimePlan.update_all(monthly_updates_count: 0)
      end
    end
  end
  