# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  name             :string(255)      not null
#  crypted_password :string(255)
#  role             :integer          default("writer")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_name        (name)
#

FactoryBot.define do
  factory :user do
    sequence(:name, "user_1")
    password { 'password' }
    password_confirmation { 'password' }
    role { :admin }
  end
end
