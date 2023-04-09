class CreateStartTimePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :start_time_plans, id: :uuid do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }, type: :uuid
      t.datetime :start_time, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end