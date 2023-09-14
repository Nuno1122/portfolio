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
  authenticates_with_sorcery! # sorceryのメソッドを使えるようにする
  DEFAULT_ACHIEVED_COUNT = 0 # デフォルトの達成数

  has_many :authentications, dependent: :destroy # ユーザーが削除されたら、そのユーザーの認証情報も削除される
  accepts_nested_attributes_for :authentications # ユーザー登録時に認証情報も同時に登録できるようにする

  has_many :posts, dependent: :destroy # ユーザーが削除されたら、そのユーザーの投稿も削除される
  has_one :start_time_plan, dependent: :destroy # ユーザーが削除されたら、そのユーザーの開始時間も削除される
  has_many :morning_activity_logs, dependent: :destroy # ユーザーが削除されたら、そのユーザーの朝活のログも削除される
  has_many :monthly_achievements, dependent: :destroy # ユーザーが削除されたら、そのユーザーの月間達成数も削除される
  has_many :likes, dependent: :destroy # ユーザーが削除されたら、そのユーザーのいいねも削除される
  has_many :liked_posts, through: :likes, source: :post # ユーザーが削除されたら、そのユーザーのいいねした投稿も削除される
  has_many :comments, dependent: :destroy # ユーザーが削除されたら、そのユーザーのコメントも削除される

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] } # パスワードが6文字以上であること
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] } # パスワードと確認用パスワードが一致すること
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] } # 確認用パスワードが入力されていること

  validates :name, presence: true, length: { maximum: 20 } # ユーザー名が20文字以下であること
  validates :email, presence: true, uniqueness: true # メールアドレスが入力されていること

  # ユーザーが存在する場合はそのユーザーを返し、存在しない場合は新しくユーザーを作成するメソッド
  def self.find_or_create_from_auth(auth)
    provider = auth[:provider] # providerはSNSの種類を表す(今回はtwitter)
    uid = auth[:uid] # uidはSNSのユーザーを識別するID
    name = auth[:info][:name] # nameはSNSのユーザー名
    image_url = auth[:info][:image] # image_urlはSNSのユーザーのプロフィール画像のURL
    introduction = auth[:info][:introduction] # introductionはSNSのユーザーの自己紹介文
  

    # User.find_or_create_by!メソッドを使って、指定したemailが既に存在する場合はそのユーザーを取得し、存在しない場合は新たにユーザーを作成。
    user = User.find_or_create_by!(email: "#{provider}-#{uid}@example.com") do |user| # ここでのemailはprovider-uid@example.comの形式に設定。ブロック内で新たに作成するユーザーの属性を設定
      user.name = name # ユーザーの属性を設定
      user.image_url = image_url # ユーザーの属性を設定
      user.introduction = introduction # ユーザーの属性を設定
      user.password = SecureRandom.hex(10) # ダミーパスワードの設定
      user.password_confirmation = user.password # ダミーパスワードの設定
    end
    
    user.authentications.find_or_create_by!(provider: provider, uid: uid) # ユーザーの認証情報を作成する
  
    user # ユーザーを返す
  end

  # ユーザーが投稿やコメントの作成者であるかどうかを判定するメソッド
  def own?(object)
    id == object.user_id # ユーザーのidと投稿やコメントのuser_idが一致するかどうかを判定
  end

  # いいねするメソッド
  def like(post)
    liked_posts << post # いいねした投稿をliked_postsに追加
  end

  # いいねを解除するメソッド
  def unlike(post)
    liked_posts.destroy(post) # いいねした投稿をliked_postsから削除
  end

  # いいねしているかどうかを判定するメソッド
  def like?(post)
    liked_posts.include?(post) # いいねした投稿に引数で渡された投稿が含まれているかどうかを判定
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
