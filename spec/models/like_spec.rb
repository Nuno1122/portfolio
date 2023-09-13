# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Like, type: :model do
    let(:user) { create(:user) }
    let(:post) { create(:post) }
    let!(:like) { create(:like, user: user, post: post) }

  describe 'アソシエーションのテスト' do
    it 'Userモデルと関連を持っている' do
      expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it 'Postモデルと関連を持っている' do
      expect(Like.reflect_on_association(:post).macro).to eq :belongs_to
    end
  end

  describe 'バリデーションのテスト' do
    it 'user_idとpost_idの組み合わせは一意である' do
      duplicate_like = build(:like, user: user, post: post)
      expect(duplicate_like).not_to be_valid
    end
  end
end