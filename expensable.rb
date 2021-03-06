# Start here. Happy coding!
require_relative "requester"
require_relative "presenter"
require_relative "user_controller"
require_relative "user"
require_relative "session"
require_relative "categories"
require_relative "transactions"
require "pry"
require "terminal-table"
require "date"
class Expensable
  include Requester
  include Presenter
  include User
  include Session
  include Transactions
  include Categories

  def initialize
    # initialize
    @user = nil
    @categories = nil
    @incomes = false
    @date = DateTime.now
  end

  def start
    # start

    print_welcome
    action, = select_main_menu_action
    until action == "exit"
      begin
        case action
        when "login" then login
        when "create_user" then create_user
        end
      rescue Net::HTTPError => e
        puts "\n\n#{e}\n\n"
      end
      print_welcome
      action, = select_main_menu_action
    end
    print_exit
  end
end

expensable = Expensable.new
expensable.start
