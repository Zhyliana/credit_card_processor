# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  given_name  :string           not null
#  card_number :string(19)       not null
#  limit       :integer          not null
#  balance     :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null

class Luhn10Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless lunh_valid?(value)
      record.errors[attribute] << 'must be Luhn10 valid'
    end
  end

  private

  def digits_of(number)
    number.to_s.split('').map(&:to_i)
  end

  def luhn_checksum(card_number)
    digits = digits_of(card_number)
    checksum = 0

    digits.each_with_index do |digit, idx|
      if idx.even?
        checksum += digits_of(digit*2).inject(:+)
      elsif idx.odd?
        checksum += digit
      end
    end

    checksum % 10
  end

  def lunh_valid?(card_number)
    luhn_checksum(card_number) == 0
  end

  def calculate_luhn(partial_card_number)
    check_digit = luhn_checksum(partial_card_number * 10)
    if check_digit == 0
      check_digit
    else
      10 - check_digit
    end
  end
end

class CreditCard < ActiveRecord::Base
  validates :given_name,  presence: true
  validates :card_number, presence: true, numericality: { only_integer: true }, uniqueness: true, length: { in: 1..19 }, luhn_10: true
  validates :limit,       presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :balance,     presence: true, numericality: { only_integer: true, less_than_or_equal_to: :limit, if: -> (credit_card) { credit_card.limit.present? } }

  has_many :line_items
end
