# == Schema Information
#
# Table name: transactions
#
#  id             :integer          not null, primary key
#  credit_card_id :integer          not null
#  amount         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Transaction < ActiveRecord::Base
  belongs_to :credit_card

  validates :credit_card_id, presence: true, numericality: { only_integer: true }
  validates :amount,         presence: true, exclusion: { in: [0], message: 'can\'t be 0' },
                             numericality: { only_integer: true, less_than_or_equal_to: :maximum_amount, if: :validate_amount?}
  validates_associated :credit_card

  def validate_amount?
    self.credit_card.present?
  end

  def maximum_amount
    self.credit_card.available_credit
  end
end
