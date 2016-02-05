class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
    render json: @transactions
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      render json: @transaction
    else
      render json: @transaction.errors
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
    render json: @transaction
  end

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update(credit_card_params)
      render json: @transaction
    else
      render json: @transaction.errors
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:credit_card_id, :amount)
  end
end
