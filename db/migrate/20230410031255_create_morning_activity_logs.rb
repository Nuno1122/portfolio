class CreateMorningActivityLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :morning_activity_logs do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :start_time_plan, null: false, foreign_key: { on_delete: :cascade }, type: :uuid
      t.datetime :started_time

      t.timestamps
    end
  end
end

