# == Schema Information
#
# Table name: users
#
#  id               :uuid             not null, primary key
#  crypted_password :string
#  email            :string           not null
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
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
