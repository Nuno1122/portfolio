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
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:created_user) { create(:user) }

  describe 'validation' do
    it '全ての項目が存在する場合、有効' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'nameがない場合、無効' do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to eq ['を入力してください']
    end

    it 'nameが20文字の場合、有効' do
      user = build(:user, name: 'a' * 20)
      expect(user).to be_valid
    end

    it 'nameが21文字以上の場合、無効' do
      user = build(:user, name: 'a' * 21)
      expect(user).to be_invalid
      expect(user.errors[:name]).to eq ['は20文字以内で入力してください']
    end

    it 'emailがない場合、無効' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to eq ['を入力してください']
    end

    it 'emailが重複する場合、無効' do
      user = build(:user, email: created_user.email)
      expect(user).to be_invalid
      expect(user.errors[:email]).to eq ['はすでに存在します']
    end

    it '別のemailの場合、有効' do
      user = build(:user)
      user_with_another_email = build(:user, email: 'another_email@example.com')
      expect(user_with_another_email).to be_valid
      expect(user_with_another_email.errors).to be_empty
    end

    it 'passwordがない場合、無効' do
      user = build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to eq ['は6文字以上で入力してください']
    end

    it 'passwordが6文字より少ない場合、無効' do
      user = build(:user, password: 'a' * 5)
      user.valid?
      expect(user.errors[:password]).to eq ['は6文字以上で入力してください']
    end

    it 'password_confirmationがない場合、無効' do
      user = build(:user, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password_confirmation]).to eq ['を入力してください']
    end

    it 'passwordとpassword_confirmationが一致していない場合、無効' do
      user = build(:user, password_confirmation: 'aaaaaaa')
      user.valid?
      expect(user.errors[:password_confirmation]).to eq ['とパスワードの入力が一致しません']
    end
  end
end
