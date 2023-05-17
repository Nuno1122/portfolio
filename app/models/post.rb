# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
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
  belongs_to :morning_activity_log, optional: true # optional: trueを指定することで、PostモデルのレコードがMorningActivityLogモデルのレコードと関連付けられなくても、バリデーションエラーが発生しないようになります。
  has_many :likes, dependent: :destroy

  validates :content, presence: true
  MAX_CONTENT_LENGTH = 260
  validate :content_length

  private

  def content_length
    count = content.chars.sum { |c| c.ascii_only? ? 1 : 2 }
    return unless count > MAX_CONTENT_LENGTH

      errors.add(:content, "全角・半角文字数上限は#{MAX_CONTENT_LENGTH}半角文字分です。")
  end
end
