# == Schema Information
#
# Table name: monthly_achievements
#
#  id             :bigint           not null, primary key
#  achieved_count :integer
#  month          :integer
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_monthly_achievements_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MonthlyAchievement < ApplicationRecord
  belongs_to :user
end
