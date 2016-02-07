class CreditCardSerializer < ActiveModel::Serializer
  attributes :id, :given_name, :card_number, :limit, :created_at

  has_many :transactions, serializer: TransactionSerializer
end
