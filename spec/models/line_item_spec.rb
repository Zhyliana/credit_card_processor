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

describe LineItem do
  let(:line_item) { FactoryGirl.create(:line_item) }

  describe 'validations' do
    def must_be_present(field)
      line_item[field] = nil

      expect(line_item).to_not be_valid
      expect(line_item.errors.messages[field]).to include('can\'t be blank')
    end

    def must_be_numeric(field)
      line_item[field] = '5 0'

      expect(line_item).not_to be_valid
      expect(line_item.errors.messages[field]).to include('is not a number')
    end

    describe 'on credit_card_id' do
      it { must_be_present(:credit_card_id) }
      it { must_be_numeric(:credit_card_id) }
    end

    describe 'on amount' do
      it { must_be_present(:amount) }
      it { must_be_numeric(:amount) }

      it 'can be greater than zero' do
        line_item.amount = '1'
        expect(line_item).to be_valid
      end

      it 'can be less than zero' do
        line_item.amount = '-1'
        expect(line_item).to be_valid
      end

      it 'cannot be zero' do
        line_item.amount = 0

        expect(line_item).not_to be_valid
        expect(line_item.errors.messages[:amount]).to include('can\'t be 0')
      end
    end

    describe 'on associated credit card' do
      # let(:invalid_cc) { FactoryGirl.create(:credit_card, :luhn_10_invalid) }

      it 'is invalid with invalid credit card' do
        invalid_cc = CreditCard.new({given_name: 'Buster', limit: 10, card_number: '133t'})
        line_item.credit_card = invalid_cc

        expect(line_item).not_to be_valid
        p line_item.errors
        expect(line_item.errors[:credit_card]).to include('is invalid')
      end
    end
  end
end
