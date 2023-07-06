class AddMonthlyUpdatesCountToStartTimePlans < ActiveRecord::Migration[7.0]
  def change
    add_column :start_time_plans, :monthly_updates_count, :integer, default: 0
  end
end
