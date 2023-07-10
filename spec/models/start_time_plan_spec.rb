# == Schema Information
#
# Table name: start_time_plans
#
#  id                    :bigint           not null, primary key
#  monthly_updates_count :integer          default(0)
#  start_time            :datetime         not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :uuid             not null
#
# Indexes
#
#  index_start_time_plans_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe StartTimePlan, type: :model do
  let(:user) { create(:user) } # テスト用のユーザーを作成
  subject { build(:start_time_plan, user: user, start_time: start_time) }

  # ...

  describe "メソッド" do
    let(:start_time) { Time.zone.parse("06:00") }

    before do
      # ユーザーの現在の月の開始時間計画
      create_list(:start_time_plan, StartTimePlan::MAX_UPDATES_PER_MONTH, user: user, start_time: start_time)
      user.reload
    end

    #describe "#remaining_updates" do
      #it "月の残りの更新回数を返す" do
        #expect(subject.remaining_updates).to eq(0)
      #end
    #end

    describe "#exceeded_monthly_updates?" do
    # context "月の更新が上限を超える場合" do
      #  it "真を返す" do
       #   expect(subject.exceeded_monthly_updates?).to eq(true)
      #  end
    #  end

      context "月の更新が上限内の場合" do
        before do
          user.start_time_plan.destroy
          user.reload
        end
      
        it "偽を返す" do
          expect(subject.exceeded_monthly_updates?).to eq(false)
        end
      end
      
    end
  end
end

