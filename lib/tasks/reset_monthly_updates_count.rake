namespace :start_time_plan do
    desc "Reset monthly_updates_count for all StartTimePlan records"
    task reset_monthly_updates_count: :environment do
      StartTimePlan.update_all(monthly_updates_count: 0)
    end
  end