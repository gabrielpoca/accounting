require 'monetize'

class Expenses
  class Expense
    attr_accessor :date, :description, :amount, :category

    def initialize(date:,description:,amount:,category:)
      @date = Date.strptime(date, '%d-%m-%Y')
      @description = description
      @amount = Monetize.parse(amount)
      @category = category
    end

    def month
      @date.strftime("%B")
    end

    def weekday
      @date.strftime('%A').downcase
    end
  end
end
