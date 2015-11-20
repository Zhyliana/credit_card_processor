class AvailableCreditValidator < ActiveModel::Validator
  def validate(transaction)
    return unless transaction.errors[attribute].blank?
    credit_card = transaction.credit_card
    if transaction.amount > credit_card.available_credit
      transaction.errors[:amount] << "exceeds available credit"
    end
  end
end