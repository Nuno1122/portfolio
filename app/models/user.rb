# == Schema Information
#
# Table name: users
#
#  id               :uuid             not null, primary key
#  crypted_password :string
#  email            :string
#  image_url        :string
#  introduction     :string
#  name             :string           not null
#  salt             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  twitter_id       :string
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
  has_many :monthly_achievements, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    name = auth[:info][:name]
    image_url = auth[:info][:image]
    introduction = auth[:info][:introduction]
  
    user = User.find_or_create_by!(email: "#{provider}-#{uid}@example.com") do |user|
      user.name = name
      user.image_url = image_url
      user.introduction = introduction
      user.password = SecureRandom.hex(10) # ダミーパスワードの設定
      user.password_confirmation = user.password
    end
    
    user.authentications.find_or_create_by!(provider: provider, uid: uid)
  
    user
  end

  def own?(object)
    id == object.user_id
  end

  def like(post)
    liked_posts << post
  end

  def unlike(post)
    liked_posts.destroy(post)
  end

  def like?(post)
    liked_posts.include?(post)
  end

  # ユーザーの前月の達成数を返すメソッド / もし前月の達成数が存在しない場合、0を返す
  def previous_achieved_count
    current_monthly_achievement.try(:achieved_count) || DEFAULT_ACHIEVED_COUNT
  end

  # ユーザーの現在の月の達成数を返すメソッド / もし現在の月の達成数が存在しない場合、0を返す
  def current_achieved_count
    current_monthly_achievement.try(:achieved_count) || DEFAULT_ACHIEVED_COUNT
  end

  def morning_activity_log_on(date)
    morning_activity_logs.find { |log| log.created_at.to_date == date }
  end
end
