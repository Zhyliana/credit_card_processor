class TransactionSerializer < ActiveModel::Serializer
  attributes :amount, :given_name, :credit_card_number, :created_at

  def given_name
    object.credit_card.given_name
  end

  def credit_card_number
    object.credit_card.card_number
  end
end
