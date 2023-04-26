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
  # 以下は、達成回数に関する定数を設定しています。
  DEFAULT_ACHIEVED_COUNT = 0
  INCREMENT_VALUE = 1
  
  #新しい月の達成回数（achieved_count）は0で初期化される
  def self.initialize_new_month(user)
    user.monthly_achievements.create!(year: Time.current.year, month: Time.current.month, achieved_count: DEFAULT_ACHIEVED_COUNT)
  end

# achieved_count に nil が入らないように設定。値が無い場合、to_i メソッドで 0 を返す。加算時には +1 される。
def increment_achieved_count
    self.achieved_count = achieved_count.to_i + INCREMENT_VALUE
    save!
  end
end
