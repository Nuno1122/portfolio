# == Schema Information
#
# Table name: morning_activity_logs
#
#  id                 :bigint           not null, primary key
#  started_time       :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_time_plan_id :bigint           not null
#  user_id            :uuid             not null
#
# Indexes
#
#  index_morning_activity_logs_on_start_time_plan_id  (start_time_plan_id)
#  index_morning_activity_logs_on_user_id             (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (start_time_plan_id => start_time_plans.id) ON DELETE => cascade
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe MorningActivityLog, type: :model do
  let(:user) { create(:user) }
  let(:start_time_plan) { create(:start_time_plan) }
  let(:morning_activity_log) { create(:morning_activity_log, user: user, start_time_plan: start_time_plan) }

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:start_time_plan) }
  end

  describe "定数" do
    it "ALLOWED_START_HOURという名前の定数がMorningActivityLogモデルに定義されていて、その値が3であること" do
      expect(MorningActivityLog::ALLOWED_START_HOUR).to eq(3)
    end

    it "ALLOWED_START_MINという名前の定数がMorningActivityLogモデルに定義されていて、その値が0であること" do
      expect(MorningActivityLog::ALLOWED_START_MIN).to eq(0)
    end

    it "ALLOWED_START_SECという名前の定数がMorningActivityLogモデルに定義されていて、その値が0であること" do
      expect(MorningActivityLog::ALLOWED_START_SEC).to eq(0)
    end
  end

  describe "今月の達成状況を取得するメソッドのテスト(.current_monthly_achievement)" do
    it "MorningActivityLog.current_monthly_achievement(user)メソッドが「指定されたユーザーに対して、現在の月の達成状況を返す」ことを検証" do
      monthly_achievement = MorningActivityLog.current_monthly_achievement(user)
      expect(monthly_achievement.month).to eq(Time.current.month)
      expect(monthly_achievement.year).to eq(Time.current.year)
    end
  end

  describe "ユーザーの月間達成回数を増やすメソッド(.increment_achieved_count)に関するテスト" do
    it "「指定されたユーザーの現在の月における達成回数（achieved_count）が1増加する」ことを検証" do
      expect { MorningActivityLog.increment_achieved_count(user) }
        .to change { user.monthly_achievements.find_by(month: Time.current.month, year: Time.current.year).achieved_count }
        .by(1)
    end
  end

  describe "朝活を許可する時間帯かどうかを判断するメソッド(.is_morning_activity_not_allowed?)" do
    context "許可された開始時刻（ALLOWED_START_HOUR）より前の場合の挙動をテスト" do
      it "許可された開始時刻より前（例：2:59）に.is_morning_activity_not_allowed?を呼び出した場合、このメソッドがtrueを返すか検証(returns true)" do
        allow(Time).to receive(:current).and_return(Time.new(2021, 9, 1, 2, 30))
        expect(MorningActivityLog.is_morning_activity_not_allowed?(user)).to be_truthy
      end
    end

    context "許可された開始時刻（ALLOWED_START_HOUR）より後の場合の挙動をテスト" do
      it "許可された開始時刻より後（例：4:01）に.is_morning_activity_not_allowed?を呼び出した場合、このメソッドがfalseを返すか検証(returns false)" do
        allow(Time).to receive(:current).and_return(Time.new(2021, 9, 1, 4, 01))
        expect(MorningActivityLog.is_morning_activity_not_allowed?(user)).to be_falsy
      end
    end
  end

  describe ".create_log_and_check_achievement" do
    # Add your test cases here
  end

  describe "#achieved?" do
    context "when the log is within the allowed time" do
      it "returns true" do
        # Your test logic here
      end
    end

    context "when the log is outside the allowed time" do
      it "returns false" do
        # Your test logic here
      end
    end
  end

  describe "#initialize_new_month_if_needed" do
    it "initializes a new month if needed" do
      # Your test logic here
    end
  end
end
