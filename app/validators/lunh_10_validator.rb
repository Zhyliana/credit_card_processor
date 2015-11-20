class Luhn10Validator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless lunh_valid?(value)
      record.errors[attribute] << "must be Luhn10 valid"
    end
  end

  private

  def digits_of(number)
    number.to_s.split("").map(&:to_i)
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
end