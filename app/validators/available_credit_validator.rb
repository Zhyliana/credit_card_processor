class AvailableCreditValidator < ActiveModel::Validator
  def validate(line_item)
    return unless line_item.errors[attribute].blank?
    credit_card = line_item.credit_card
    if line_item.amount > credit_card.available_credit
      line_item.errors[:amount] << "exceeds available credit"
    end
  end
end