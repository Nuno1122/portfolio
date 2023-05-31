# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :content, presence: true
  MAX_CONTENT_LENGTH = 230
  validate :content_length

  private

  def content_length
    count = content.chars.sum { |c| c.ascii_only? ? 1 : 2 }
    return unless count > MAX_CONTENT_LENGTH

      errors.add(:content, "全角・半角文字数上限は#{MAX_CONTENT_LENGTH}半角文字分です。")
  end
end
