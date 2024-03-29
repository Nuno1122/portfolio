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

  # 新しい月の達成回数（achieved_count）は0で初期化される
  def self.initialize_new_month(user)
    user.monthly_achievements.create!(year: Time.current.year, month: Time.current.month, achieved_count: DEFAULT_ACHIEVED_COUNT)
  end

  # 翌月の朝活達成カウント(achieved_count)の値がnil?を返さないようにするために、nilだった場合、デフォルト値０を設定するメソッド
  def self.achieved_count_or_default(user_id, year, month)
    monthly_achievement = find_by(user_id: user_id, year: year, month: month)
    monthly_achievement&.achieved_count || DEFAULT_ACHIEVED_COUNT
  end

  # achieved_count に nil が入らないように設定。値が無い場合、to_i メソッドで 0 を返す。加算時には +1 される。
  def increment_achieved_count
    self.achieved_count = achieved_count.to_i + INCREMENT_VALUE
      save!
  end

  # achieved_count に nil が入らないように設定。値が無い場合、to_i メソッドで 0 を返す。減算時には -1 される。
  def self.ranking
    group(:user_id).sum(:achieved_count).sort_by { |_, achieved_count| achieved_count }.reverse
  end

  # 月間達成回数のランキングを取得するメソッド
  def self.achievements_ranking(year, month)
    where(year: year, month: month)
      .group(:user_id)
      .sum(:achieved_count)
      .sort_by { |_, count| -count }
  end

end
