# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  given_name  :string           not null
#  card_number :string(19)       not null
#  limit       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :credit_card, class: CreditCard do
    given_name 'Buster'
    limit 100
    card_number '4111111111111111'
  end

  trait :luhn_10_invalid do
    card_number '1234567890123456'
  end
end
