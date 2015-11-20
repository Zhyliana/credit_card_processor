# == Schema Information
#
# Table name: line_items
#
#  id             :integer          not null, primary key
#  credit_card_id :integer          not null
#  amount         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :line_item, class: LineItem do
    credit_card { FactoryGirl.create(:credit_card) }
    amount 10
  end
end
