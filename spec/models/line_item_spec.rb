# == Schema Information
#
# Table name: line_items
#
#  id             :integer          not null, primary key
#  credit_card_id :integer          not null
#  amount         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

describe LineItem do
  let(:line_item) { FactoryGirl.create(:line_item) }

  describe 'associations' do
    it { expect(line_item).to belong_to(:credit_card) }
  end

  describe 'validations' do
    describe 'on credit_card_id' do
      it { expect(line_item).to validate_presence_of(:credit_card_id) }
    end

    describe 'on amount' do
      it { expect(line_item).to validate_presence_of(:amount) }
      it { expect(line_item).to allow_values(-1, 1).for(:amount) }
      it { expect(line_item).to_not allow_value(0).for(:amount) }

      context 'as related to credit card limit' do
        let(:available_credit) { line_item.credit_card.available_credit }

        it 'does not allow transactions that would raise the balance over the limit' do
          expect(line_item).to_not allow_value(available_credit + 1).for(:amount)
        end

        it 'allows transactions that would set balance equal to the limit' do
          expect(line_item).to allow_value(available_credit).for(:amount)
        end
      end
    end

    describe 'on associated credit card' do
      it 'is invalid with invalid credit card' do
        invalid_cc = CreditCard.new({ given_name: 'Buster', limit: 10, card_number: '133t' })
        line_item.credit_card = invalid_cc

        expect(line_item).not_to be_valid
        expect(line_item.errors[:credit_card]).to include('is invalid')
      end
    end
  end
end
