require_relative "transactions_controller"

module Transactions
  def print_transactions_table(id, date = DateTime.now)
    category = CategoriesController.category(@user[:token], id)
    table = Terminal::Table.new
    table.title = "#{category[:name]}\n#{date.strftime('%B %Y')}" # => Category/nNovember
    table.headings = %w[ID Date Amount Notes]
    rows = []
    category[:transactions].each do |transaction|
      if transaction[:date].match?(/^#{date.strftime("%Y-%m")}/) # => if "2020-12-10" matches /^2020-12/
        transaction_date = DateTime.new(*transaction[:date].split("-").map(&:to_i)) # => "2020-12-12" -> 2020,12,12 eg
        rows << [transaction[:id], transaction_date.strftime("%a, %b %d"), transaction[:amount], transaction[:notes]]
      end
    end
    table.rows = rows
    puts table
  end

  def execute_option(option, id = nil)
    case option
    when "add" then add_transaction
    when "update" then update_transaction id # may need to rescue for non-existing transaction id
    when "delete" then delete_transaction id # may need to rescue for non-existing transaction id
    when "next" then next_table
    when "prev" then prev_table
    end
  end

  def add_transaction
    transaction_info = transaction_form
    TransactionsController.create(@user, transaction_info)
  end

  def update_transaction(transaction_id)
    transaction_info = transaction_form(update_form: true)
    transaction_info[:transaction_id] = transaction_id
    TransactionsController.update(@user, transaction_info)
  end

  def delete_transaction(transaction_id)
    transaction_info = {
      transaction_id: transaction_id,
      category_id: @category_id
    }
    TransactionsController.destroy(user, transaction_info)
  end

  # requester

  def transaction_form(update_form: false)
    amount = update_form ? gets_string("Amount: ", required: false) : gets_string("Amount: ")
    # NEEDS validation for date
    date = update_form ? gets_string("Amount: ", required: false) : gets_string("Date: ")
    notes = gets_string("Notes: ", required: false)

    transaction_info = {}
    transaction_info[:amount] = amount unless notes.empty?
    transaction_info[:date] = date unless notes.empty?

    # transaction[:notes] are nil if notes is empty when form is update_form
    transaction_info[:notes] = notes unless update_form && notes.empty?
    # NEEDS to create @category_id somewhere
    transaction_info[:category_id] = @category_id

    transaction_info # returned
  end
end