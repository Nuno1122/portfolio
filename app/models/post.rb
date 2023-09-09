# == Schema Information
#
# Table name: posts
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  likes_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :content, presence: true  #空白はエラー
  MAX_CONTENT_LENGTH = 230  #文字数上限
  validate :content_length, unless: -> { content.nil? } #文字数制限 バリデーション

  def likes_count #いいね数
    likes.count #いいねの数
  end

  private

  def content_length #文字数制限
    count = content.chars.sum { |c| c.ascii_only? ? 1 : 2 } #半角文字は1文字、全角文字は2文字としてカウント
    return unless count > MAX_CONTENT_LENGTH #文字数が上限を超えていたらエラー

      errors.add(:content, "全角・半角文字数上限は#{MAX_CONTENT_LENGTH}半角文字分です。") #エラー
  end
end
