# == Schema Information
#
# Table name: line_items
#
#  id             :integer          not null, primary key
#  credit_card_id :integer
#  amount         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class LineItem < ActiveRecord::Base
  validates :credit_card_id, presence: true, numericality: { only_integer: true }
  validates :amount,         presence: true, numericality: { only_integer: true }, exclusion: { in: [0], message: 'can\'t be 0' }
  validates_associated :credit_card

  belongs_to :credit_card
end
