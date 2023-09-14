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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { build(:comment, user:, post:) }

  describe 'アソシエーションのテスト' do
    it 'Userモデルと関連を持っている' do
      expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'Postモデルと関連を持っている' do
      expect(Comment.reflect_on_association(:post).macro).to eq :belongs_to
    end
  end

  describe 'バリデーションのテスト' do
    context 'contentが存在する場合' do
      it '有効である' do
        comment.content = '有効なコメント'
        expect(comment).to be_valid
      end
    end

    context 'contentが存在しない場合' do
      it '無効である' do
        comment.content = nil
        expect(comment).not_to be_valid
      end
    end

    context 'contentの長さが230半角文字以内である場合' do
      it '有効である' do
        comment.content = 'a' * 230
        expect(comment).to be_valid
      end
    end

    context 'contentの長さが231半角文字以上である場合' do
      it '無効である' do
        comment.content = 'a' * 231
        expect(comment).not_to be_valid
      end
    end

    context 'contentの長さが230半角文字相当である場合（全角含む）' do
      it '有効である' do
        comment.content = 'あ' * 115
        expect(comment).to be_valid
      end
    end

    context 'contentの長さが231半角文字相当以上である場合（全角含む）' do
      it '無効である' do
        comment.content = 'あ' * 116
        expect(comment).not_to be_valid
      end
    end
  end
end
