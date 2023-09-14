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
  let!(:monthly_achievement) { create(:monthly_achievement, user:, month: Time.current.month, year: Time.current.year) }
  let(:start_time_plan) { create(:start_time_plan, user:) }
  let(:morning_activity_log) { create(:morning_activity_log, user:, start_time_plan:) }

  describe '関連付け（アソシエーション）に関するテスト' do
    it { should belong_to(:user) }
    it { should belong_to(:start_time_plan) }
  end

  describe '定数' do
    it 'ALLOWED_START_HOURという名前の定数がMorningActivityLogモデルに定義されていて、その値が3であること' do
      expect(MorningActivityLog::ALLOWED_START_HOUR).to eq(3)
    end

    it 'ALLOWED_START_MINという名前の定数がMorningActivityLogモデルに定義されていて、その値が0であること' do
      expect(MorningActivityLog::ALLOWED_START_MIN).to eq(0)
    end

    it 'ALLOWED_START_SECという名前の定数がMorningActivityLogモデルに定義されていて、その値が0であること' do
      expect(MorningActivityLog::ALLOWED_START_SEC).to eq(0)
    end
  end

  describe '今月の達成状況を取得するメソッドのテスト(.current_monthly_achievement)' do
    it 'MorningActivityLog.current_monthly_achievement(user)メソッドが「指定されたユーザーに対して、現在の月の達成状況を返す」ことを検証' do
      monthly_achievement = MorningActivityLog.current_monthly_achievement(user)
      expect(monthly_achievement.month).to eq(Time.current.month)
      expect(monthly_achievement.year).to eq(Time.current.year)
    end
  end

  describe 'ユーザーの月間達成回数を増やすメソッド(.increment_achieved_count)に関するテスト' do
    it '「指定されたユーザーの現在の月における達成回数（achieved_count）が1増加する」ことを検証' do
      expect { MorningActivityLog.increment_achieved_count(user) }
        .to change { user.monthly_achievements.find_by(month: Time.current.month, year: Time.current.year).achieved_count }
        .by(1)
    end
  end

  describe '朝活を許可する時間帯かどうかを判断するメソッド(.is_morning_activity_not_allowed?)に関するテスト' do
    context '許可された開始時刻（ALLOWED_START_HOUR）より前の場合の挙動をテスト' do
      it '許可された開始時刻より前（例 2:59）に.is_morning_activity_not_allowed?を呼び出した場合、このメソッドがtrueを返すか検証(returns true)' do
        allow(Time).to receive(:current).and_return(Time.new(2021, 9, 1, 2, 30))
        expect(MorningActivityLog.is_morning_activity_not_allowed?(user)).to be_truthy
      end
    end

    context '許可された開始時刻（ALLOWED_START_HOUR）より後の場合の挙動をテスト' do
      it '許可された開始時刻より後（例 4:01）に.is_morning_activity_not_allowed?を呼び出した場合、このメソッドがfalseを返すか検証(returns false)' do
        allow(Time).to receive(:current).and_return(Time.new(2021, 9, 1, 4, 0o1))
        expect(MorningActivityLog.is_morning_activity_not_allowed?(user)).to be_falsy
      end
    end
  end

  describe '朝活ログを作成し、達成状況をチェックするメソッド(.create_log_and_check_achievement)に関するテスト' do
    context '「ログが正常に作成された場合」のテスト' do
      it 'ログが正常に作成された場合「メソッドが true と正確なリダイレクトパラメータを返すかどうか」をテスト' do
        result, redirect_params = MorningActivityLog.create_log_and_check_achievement(user, start_time_plan.id)
        expect(result).to eq(true)
        expect(redirect_params).to include(:achieved)
      end

      context 'ログが達成された場合' do
        before do
          allow_any_instance_of(MorningActivityLog).to receive(:achieved?).and_return(true)
        end

        it 'achieved_count（達成回数または達成カウント）を増加させる' do
          expect { MorningActivityLog.create_log_and_check_achievement(user, start_time_plan.id) }
            .to change { MorningActivityLog.current_monthly_achievement(user).achieved_count }.by(1)
        end
      end

      context 'ログが達成されていない場合' do
        before do
          allow_any_instance_of(MorningActivityLog).to receive(:achieved?).and_return(false)
        end

        it 'achieved_count（達成カウント）は増加しない' do
          expect { MorningActivityLog.create_log_and_check_achievement(user, start_time_plan.id) }.not_to(change { MorningActivityLog.current_monthly_achievement(user).achieved_count })
        end
      end
    end

    context 'ログの作成に失敗した場合' do
      before do
        allow_any_instance_of(MorningActivityLog).to receive(:save).and_return(false)
      end

      it 'falseとnilを返す' do
        result, redirect_params = MorningActivityLog.create_log_and_check_achievement(user, start_time_plan.id)
        expect(result).to eq(false)
        expect(redirect_params).to eq(nil)
      end
    end
  end

  describe '朝活が達成されたかどうかを判断するメソッド(achieved?)に関するテスト' do
    context 'ログが許可された時間内にある場合' do
      it '目標開始時刻 - 1分前に打刻した場合、trueを返す' do
        # 許可された時間範囲を設定
        allowed_time = start_time_plan.start_time - 1.minute
        morning_activity_log.started_time = allowed_time

        expect(morning_activity_log.achieved?).to eq(true)
      end

      it '目標開始時刻ピッタリに打刻した場合、trueを返す' do
        # 許可された時間範囲を設定
        allowed_time = start_time_plan.start_time
        morning_activity_log.started_time = allowed_time

        expect(morning_activity_log.achieved?).to eq(true)
      end
    end

    context 'ログが許可された時間外にある場合' do
      it '目標開始時刻 + 1分後に打刻した場合、falseを返す' do
        # 許可されていない時間範囲を設定
        not_allowed_time = start_time_plan.start_time + 1.minute
        morning_activity_log.started_time = not_allowed_time

        expect(morning_activity_log.achieved?).to eq(false)
      end
    end
  end
end
