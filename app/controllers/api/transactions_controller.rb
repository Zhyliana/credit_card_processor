class Api::TransactionsController < ApplicationController

  skip_before_filter :verify_authenticity_token

  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'

      render :text => '', :content_type => 'text/plain'
    end
  end

  def index
    transactions = Transaction.all
    render json: transactions
  end

  def create
    transaction = Transaction.new(transaction_params)

    if transaction.save
      render json: transaction
    else
      render json: transaction.errors
    end
  end

  def show
    transaction = Transaction.find(params[:id])
    render json: transaction
  end

  def update
    transaction = Transaction.find(params[:id])

    if transaction.update(credit_card_params)
      render json: transaction
    else
      render json: transaction.errors
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit(:credit_card_id, :amount)
  end
end
