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
require 'lunh_10_validator'

class CreditCard < ActiveRecord::Base
  has_many :line_items,  dependent: :destroy

  validates :given_name,  presence: true

  validates :card_number, presence: true,
                          length: { in: 1..19 },
                          luhn_10: true,
                          numericality: { only_integer: true },
                          uniqueness: { case_sensitive: false }

  validates :limit,       presence: true,
                          numericality: { only_integer: true,
                                          greater_than_or_equal_to: 0 }

  def available_credit
    limit - balance
  end

  def balance
    return 0 if self.line_items.empty?
    self.line_items.sum(:amount)
  end
end
