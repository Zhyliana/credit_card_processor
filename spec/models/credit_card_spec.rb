# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  given_name  :string           not null
#  card_number :string(19)       not null
#  limit       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

describe CreditCard do
  let(:credit_card) { FactoryGirl.create(:credit_card) }

  describe "associations" do
    it { expect(credit_card).to have_many(:line_items) }
  end

  describe "validations" do
    describe "on given_name" do
      it { expect(credit_card).to validate_presence_of(:given_name) }
    end

    describe "on limit" do
      it { expect(credit_card).to validate_presence_of(:limit) }
      it { expect(credit_card).to validate_numericality_of(:limit).is_greater_than_or_equal_to(0) }
      it { expect(credit_card).to_not allow_value(-1).for(:limit) }
    end

    describe "on card_number" do
      it { expect(credit_card).to validate_presence_of(:card_number) }
      it { expect(credit_card).to validate_numericality_of(:card_number).only_integer }
      it { expect(credit_card).to validate_uniqueness_of(:card_number).case_insensitive }
      it { expect(credit_card).to validate_length_of(:card_number).is_at_least(1).is_at_most(19) }

      it "must be Luhn10 valid" do
        credit_card.card_number = "1234567890123456"

        expect(credit_card).to_not be_valid
        expect(credit_card.errors.messages[:card_number]).to include("must be Luhn10 valid")
      end
    end

    describe ".balance" do
      context "with line items" do
        it "returns sum of line item amounts" do
          LineItem.create(amount: 10, credit_card: credit_card)
          LineItem.create(amount: 5, credit_card: credit_card)
          LineItem.create(amount: -6, credit_card: credit_card)

          expect(credit_card.balance).to eq(9)
        end
      end

      context "without line items" do
        it "returns 0" do
          expect(credit_card.balance).to eq(0)
        end
      end
    end

    describe ".available_credit" do
      it "returns difference between limit and balance" do
        LineItem.create(amount: 5, credit_card: credit_card)
        LineItem.create(amount: -6, credit_card: credit_card)

        expect(credit_card.available_credit).to eq(101)
      end
    end
  end
end
