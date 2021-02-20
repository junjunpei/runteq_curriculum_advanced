# == Schema Information
#
# Table name: sentences
#
#  id         :bigint           not null, primary key
#  body       :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :sentence do
    sequence(:body) { |n| "sequence_body_#{n}" }
  end
end
