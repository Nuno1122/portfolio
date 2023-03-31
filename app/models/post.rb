class Post < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140*2, message: '全角文字数上限は140文字です。' }, length: { maximum: 280, message: '半角文字数上限は280文字です。' }
end