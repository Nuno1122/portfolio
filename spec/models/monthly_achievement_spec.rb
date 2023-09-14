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
require 'rails_helper'

RSpec.describe MonthlyAchievement, type: :model do
  let(:user) { create(:user) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let(:current_year) { Time.current.year }
  let(:current_month) { Time.current.month }
  let(:achieved_count) { 5 }
  let(:monthly_achievement) { create(:monthly_achievement) }

  describe '関連付け（アソシエーション）に関するテスト' do
    it { should belong_to(:user) }
  end

  describe '定数に関するテスト' do
    it 'デフォルトでの達成回数が0である' do
      expect(MonthlyAchievement::DEFAULT_ACHIEVED_COUNT).to eq(0)
    end

    it 'インクリメント値が1である' do
      expect(MonthlyAchievement::INCREMENT_VALUE).to eq(1)
    end
  end

  describe '新しい月の達成回数（achieved_count）が0で初期化されるか確認のテスト（.initialize_new_month)' do
    it '現在の月に対してユーザーの新しいMonthlyAchievementレコードを作成する' do
      expect do
        MonthlyAchievement.initialize_new_month(user)
      end.to change { MonthlyAchievement.count }.by(1)

      monthly_achievement = MonthlyAchievement.last
      expect(monthly_achievement.user).to eq(user)
      expect(monthly_achievement.year).to eq(current_year)
      expect(monthly_achievement.month).to eq(current_month)
      expect(monthly_achievement.achieved_count).to eq(MonthlyAchievement::DEFAULT_ACHIEVED_COUNT)
    end
  end

  context '該当するMonthlyAchievementレコードが存在する場合' do
    it 'achieved_countを返す' do
      create(:monthly_achievement, user:, year: current_year, month: current_month, achieved_count:)
      expect(MonthlyAchievement.achieved_count_or_default(user.id, current_year, current_month)).to eq(achieved_count)
    end
  end

  context '該当するMonthlyAchievementレコードが存在しない場合' do
    it 'DEFAULT_ACHIEVED_COUNTを返す' do
      expect(MonthlyAchievement.achieved_count_or_default(user.id, current_year, current_month)).to eq(MonthlyAchievement::DEFAULT_ACHIEVED_COUNT)
    end
  end

  describe 'achieved_count に nil が入らないようになっているか確認(.increment_achieved_count)メソッドのテスト' do
    context 'achieved_countがnilの場合' do
      it 'achieved_countが1になる' do
        monthly_achievement.achieved_count = nil
        monthly_achievement.increment_achieved_count
        expect(monthly_achievement.achieved_count).to eq(1)
      end
    end

  context 'achieved_countが数値の場合' do
    it 'achieved_countが1増加する' do
      initial_count = 5
      monthly_achievement.achieved_count = initial_count
      monthly_achievement.increment_achieved_count
      expect(monthly_achievement.achieved_count).to eq(initial_count + 1)
    end
  end
  end

describe 'ランキングに関するテスト' do
  before do
    create(:monthly_achievement, user: user1, achieved_count: 5)
    create(:monthly_achievement, user: user1, achieved_count: 10)

    create(:monthly_achievement, user: user2, achieved_count: 7)
    create(:monthly_achievement, user: user2, achieved_count: 8)

    create(:monthly_achievement, user: user3, achieved_count: 6)
    create(:monthly_achievement, user: user3, achieved_count: 10)
  end

  it '達成数（achieved_count）の合計に基づいて、降順でユーザーランキングを返す。か確認するテスト' do
    expect(MonthlyAchievement.ranking.sort).to eq([
      [user3.id, 16],
      [user1.id, 15],
      [user2.id, 15]
    ].sort)
  end
end

  describe '月間達成回数のランキングを取得するメソッドに関するテスト' do
    let!(:achievement1) { create(:monthly_achievement, user: user1, year: 2023, month: 4, achieved_count: 5) }
    let!(:achievement2) { create(:monthly_achievement, user: user1, year: 2023, month: 4, achieved_count: 10) }
    let!(:achievement3) { create(:monthly_achievement, user: user2, year: 2023, month: 4, achieved_count: 9) }
    let!(:achievement4) { create(:monthly_achievement, user: user3, year: 2023, month: 4, achieved_count: 16) }
    let!(:achievement5) { create(:monthly_achievement, user: user3, year: 2023, month: 5, achieved_count: 10) }

    it '指定された年と月に基づいて、achieved_counts（達成カウント）の合計に基づいたユーザーランキングを降順で返すか確認するテスト' do
      expect(MonthlyAchievement.achievements_ranking(2023, 4)).to eq(
        [
          [user3.id, 16],
          [user1.id, 15],
          [user2.id, 9]
        ]
      )
    end
  end
end
