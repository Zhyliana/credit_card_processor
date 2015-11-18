# == Schema Information
#
# Table name: credit_cards
#
#  id          :integer          not null, primary key
#  given_name  :string           not null
#  card_number :string(19)       not null
#  limit       :integer          not null
#  balance     :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

describe CreditCard do
  let(:credit_card) { FactoryGirl.create(:credit_card) }

  describe 'validations' do
    def must_be_present(field)
      credit_card[field] = nil

      expect(credit_card).to_not be_valid
      expect(credit_card.errors.messages[field]).to include('can\'t be blank')
    end

    def must_be_numeric(field)
      credit_card[field] = '5 0'

      expect(credit_card).not_to be_valid
      expect(credit_card.errors.messages[field]).to include('is not a number')
    end

    describe 'when all fields are valid' do
      it 'errors are empty' do
        expect(credit_card).to be_valid
        expect(credit_card.errors.messages).to be_empty
      end
    end

    describe 'on given_name' do
      it { must_be_present(:given_name) }
    end

    describe 'on card_number' do
      it { must_be_present(:card_number) }
      it { must_be_numeric(:card_number) }

      it 'must be unique' do
        copy_cat_cc = credit_card.dup
        copy_cat_cc.save

        expect(copy_cat_cc).to_not be_valid
        expect(copy_cat_cc.errors.messages[:card_number]).to include('has already been taken')
      end

      it 'cannot be longer than 19' do
        credit_card.card_number = '01234567890123456789'

        expect(credit_card).to_not be_valid
        expect(credit_card.errors.messages[:card_number]).to include('is too long (maximum is 19 characters)')
      end

      it 'must be Luhn10 valid' do
        credit_card.card_number = '1234567890123456'

        expect(credit_card).to_not be_valid
        expect(credit_card.errors.messages[:card_number]).to include('must be Luhn10 valid')
      end
    end

    describe 'on limit' do
      it { must_be_present(:limit) }
      it { must_be_numeric(:limit) }

      it 'cannot be negative' do
        credit_card.limit = '-1'

        expect(credit_card).not_to be_valid
        expect(credit_card.errors.messages[:limit]).to include('must be greater than or equal to 0')
      end
    end

    describe 'on balance' do
      it { must_be_present(:balance) }
      it { must_be_numeric(:balance) }

      context 'the limit does not exist' do
        it 'balance has no errors' do
          credit_card.limit = nil
          credit_card.balance = 1000000000

          expect(credit_card).not_to be_valid
          expect(credit_card.errors.messages[:balance]).to be_nil
        end
      end

      context 'the when limit exists' do
        it 'cannot be greater than the limit' do
          credit_card.balance = credit_card.limit + 1

          expect(credit_card).to_not be_valid
          expect(credit_card.errors.messages[:balance]).to include("must be less than or equal to #{credit_card.limit}")
        end
      end
    end
  end


  # describe '::create' do
  #   context 'with valid params' do
  #     let(:quickstarter_project) { FactoryGirl.create(:project_base, :draft) }
  #     let(:quickstarter_info) { FactoryGirl.create(:external_campaign_info_base,
  #                                                  igg_project_id: quickstarter_project.id) }
  #     it 'saves to the database' do
  #       expect { quickstarter_info }.to change { CreditCard.count }
  #     end
  #
  #     it 'has the correct attributes' do
  #       expect(quickstarter_info.created_at).to be_kind_of(Time)
  #       expect(quickstarter_info.updated_at).to be_kind_of(Time)
  #     end
  #   end
  # end
end
