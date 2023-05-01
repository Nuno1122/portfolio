# == Schema Information
#
# Table name: users
#
#  id               :uuid             not null, primary key
#  crypted_password :string
#  email            :string           not null
#  name             :string           not null
#  salt             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!
  DEFAULT_ACHIEVED_COUNT = 0
  
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_many :posts, dependent: :destroy
  has_one :start_time_plan, dependent: :destroy
  has_many :morning_activity_logs, dependent: :destroy
  has_many :monthly_achievements

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true, length: { maximum: 15 }
  validates :email, presence: true, uniqueness: true

  def own?(object)
    id == object.user_id
  end

  # ユーザーの前月の達成数を返すメソッド / もし前月の達成数が存在しない場合、0を返す
  def previous_achieved_count
    current_monthly_achievement.try(:achieved_count) || DEFAULT_ACHIEVED_COUNT
  end

  # ユーザーの現在の月の達成数を返すメソッド / もし現在の月の達成数が存在しない場合、0を返す
  def current_achieved_count
    current_monthly_achievement.try(:achieved_count) || DEFAULT_ACHIEVED_COUNT
  end


end
