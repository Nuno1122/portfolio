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
require 'rails_helper' # rails_helperを読み込む。ここには共通の設定やヘルパーメソッドが含まれている。

# Postモデルのテストを行う
RSpec.describe Post, type: :model do
  # アソシエーションに関するテスト
  describe '関連付け' do
    it { should belong_to(:user) } # userに対するbelongs_toの関連付けがあることをテスト
    it { should have_many(:likes).dependent(:destroy) } # likesに対するhas_manyの関連付けがあり、親オブジェクトが削除されたら子オブジェクトも削除されることをテスト
    it { should have_many(:comments).dependent(:destroy) } # commentsに対するhas_manyの関連付けがあり、親オブジェクトが削除されたら子オブジェクトも削除されることをテスト
  end

  # バリデーションに関するテスト
  describe 'バリデーション' do
    it { should validate_presence_of(:content) } # content属性が必須であることをテスト

    # contentの長さが長すぎる場合のテスト
    context 'contentが長すぎる場合' do
      let(:post) { build(:post, content: 'a' * 231) } # 231文字のcontentを持つpostを作成
      it '無効である' do
        expect(post).not_to be_valid # postが無効であることをテスト
      end
    end

    # contentの長さが適切な場合のテスト
    context 'contentの長さが適切な場合' do
      let(:post) { build(:post, content: 'a' * 230) } # 230文字のcontentを持つpostを作成
      it '有効である' do
        expect(post).to be_valid # postが有効であることをテスト
      end
    end
  end

  # likes_countメソッドに関するテスト
  describe '#likes_count' do
    let(:user) { create(:user) } # テスト用ユーザーを作成
    let(:post) { create(:post, user:) } # テスト用ユーザーが作成したpostを作成
    before do
      create_list(:like, 5, post:) # postに対する5つのlikeを作成
    end
    it 'いいねの数を返す' do
      expect(post.likes_count).to eq(5) # postのlikes_countが5であることをテスト
    end
  end
end
