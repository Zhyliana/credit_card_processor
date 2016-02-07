class Api::CreditCardsController < ActionController::Base

  def index
    @credit_cards = CreditCard.all
    render json: @credit_cards
  end

  def home
    render 'home'
  end

  def create
    @credit_card = CreditCard.new(credit_card_params)

    if @credit_card.save
      render json: @credit_card
    else
      render json: @credit_card.errors
    end
  end

  def show
    @credit_card = CreditCard.find(params[:id])
    render json: @credit_card
  end

  def update
    @credit_card = CreditCard.find(params[:id])

    if @credit_card.update(credit_card_params)
      render json: @credit_card
    else
      render json: @credit_card.errors
    end
  end

  private
  def credit_card_params
    params.require(:credit_card).permit(:given_name, :limit, :card_number)
  end
end
