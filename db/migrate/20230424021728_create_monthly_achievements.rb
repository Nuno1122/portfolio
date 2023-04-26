class CreateMonthlyAchievements < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_achievements do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :year
      t.integer :month
      t.integer :achieved_count

      t.timestamps
    end
  end
end
