class CommandProcessor
  def import(transactions)
    @summaries = {}
    transactions.each { |tr| parse(tr) }
    self
  end

  def summary_string
    summary_string = ""

    @summaries.sort.each do |summary|
      currency_symbol = summary[1].is_a?(String) ? "" : "$"
      summary_string += "#{summary[0]}: " + currency_symbol + "#{summary[1]}\n"
    end

    summary_string
  end

  private

  def parse(transaction)
    args = transaction.split(" ")
    action =  args[0].downcase
    options = {
        given_name: args[1],
    }
    if action == "add"
      options[:card_number] = args[2]
      options[:limit] = args[3].gsub!(/\W+/, "").to_i
      add_credit_card(options)
    elsif ["charge", "credit"].include?(action)
      options[:amount] = args[2].gsub!(/\W+/, "").to_i
      create_transaction(options, action)
    end
  end

  def update_summary(name, report="error")
    @summaries[name] = report
  end

  def add_credit_card(cc_params)
    credit_card = CreditCard.new(cc_params)
    report = credit_card.try(:save) ? credit_card.balance : "error"

    update_summary(credit_card.given_name, report)
  end

  def create_transaction(options, action)
    name, amount = options[:given_name], options[:amount]
    amount *= -1 if action == "credit"

    credit_card = CreditCard.find_by_given_name(name)
    line_item = LineItem.new({ amount: amount, credit_card: credit_card })

    update_summary(name, credit_card.balance) if line_item.try(:save)
  end
end