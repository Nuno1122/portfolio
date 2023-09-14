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
# spec/models/start_time_plan_spec.rb
require 'rails_helper'

RSpec.describe StartTimePlan, type: :model do
  let(:user) { create(:user) }
  let(:valid_start_time) { Time.new(2023, 10, 1, 6, 0, 0) } # 6時を設定
  let(:invalid_start_time) { Time.new(2023, 10, 1, 2, 0, 0) } # 2時を設定

  describe 'アソシエーションのテスト' do
    it 'Userモデルと関連を持っている' do
      expect(StartTimePlan.reflect_on_association(:user).macro).to eq :belongs_to
    end
  end

  describe 'バリデーションのテスト' do
    context 'start_timeが存在する場合' do
      it '有効である' do
        start_time_plan = build(:start_time_plan, user:, start_time: valid_start_time)
        expect(start_time_plan).to be_valid
      end
    end

    context 'start_timeが存在しない場合' do
      it '無効である' do
        start_time_plan = build(:start_time_plan, user:, start_time: nil)
        expect(start_time_plan).not_to be_valid
      end
    end
  end

  describe 'カスタムバリデーションのテスト' do
    context 'start_timeが許容時間内の場合' do
      it '有効である' do
        start_time_plan = build(:start_time_plan, user:, start_time: valid_start_time)
        expect(start_time_plan).to be_valid
      end
    end

    context 'start_timeが許容時間外の場合' do
      it '無効である' do
        start_time_plan = build(:start_time_plan, user:, start_time: invalid_start_time)
        expect(start_time_plan).not_to be_valid
      end
    end
  end

  describe 'メソッドのテスト' do
    describe '#remaining_updates' do
      context '月の更新回数が0の場合' do
        it '残りの更新回数はMAX_UPDATES_PER_MONTHと同じである' do
          allow_any_instance_of(StartTimePlan).to receive(:monthly_updates_count).and_return(0)
          start_time_plan = build(:start_time_plan, user:)
          expect(start_time_plan.remaining_updates).to eq StartTimePlan::MAX_UPDATES_PER_MONTH
        end
      end

      context '月の更新回数が1の場合' do
        it '残りの更新回数はMAX_UPDATES_PER_MONTH - 1である' do
          allow_any_instance_of(StartTimePlan).to receive(:monthly_updates_count).and_return(1)
          start_time_plan = build(:start_time_plan, user:)
          expect(start_time_plan.remaining_updates).to eq(StartTimePlan::MAX_UPDATES_PER_MONTH - 1)
        end
      end

      context '月の更新回数がMAX_UPDATES_PER_MONTHと同じ場合' do
        it '残りの更新回数は0である' do
          allow_any_instance_of(StartTimePlan).to receive(:monthly_updates_count).and_return(StartTimePlan::MAX_UPDATES_PER_MONTH)
          start_time_plan = build(:start_time_plan, user:)
          expect(start_time_plan.remaining_updates).to eq(0)
        end
      end
    end
  end

  describe 'メソッドのテスト' do
    describe '#exceeded_monthly_updates?' do
      context '月の更新回数がMAX_UPDATES_PER_MONTH未満の場合' do
        it 'falseを返す' do
          allow_any_instance_of(StartTimePlan).to receive(:monthly_updates_count).and_return(StartTimePlan::MAX_UPDATES_PER_MONTH - 1)
          start_time_plan = build(:start_time_plan, user:)
          expect(start_time_plan.exceeded_monthly_updates?).to be_falsey
        end
      end

      context '月の更新回数がMAX_UPDATES_PER_MONTHと同じ場合' do
        it 'trueを返す' do
          allow_any_instance_of(StartTimePlan).to receive(:monthly_updates_count).and_return(StartTimePlan::MAX_UPDATES_PER_MONTH)
          start_time_plan = build(:start_time_plan, user:)
          expect(start_time_plan.exceeded_monthly_updates?).to be_truthy
        end
      end

      context '月の更新回数がMAX_UPDATES_PER_MONTHを超えている場合' do
        it 'trueを返す' do
          allow_any_instance_of(StartTimePlan).to receive(:monthly_updates_count).and_return(StartTimePlan::MAX_UPDATES_PER_MONTH + 1)
          start_time_plan = build(:start_time_plan, user:)
          expect(start_time_plan.exceeded_monthly_updates?).to be_truthy
        end
      end
    end
  end
end
