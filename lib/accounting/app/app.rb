require 'csv'
require 'pry'
require 'money'

require_relative './graph'
require_relative './expenses'

Money.default_currency = Money::Currency.new("EUR")
I18n.enforce_available_locales = false

class ExpensesParser
  def initialize(file:)
    @file = file
  end

  def call
    @expenses = CSV.read(@file, { headers: true, return_headers: false })
      .map do|row|
        Expense.new(
          date: row[0],
          description: row[1],
          amount: row[2],
          category: row[3]
        )
      end
      .reject { |expense| expense.category == 'IGNORE' }
  end
end

class App
  def self.explore(query)
    all_expenses = ExpensesParser.new(file: "./priv/agosto.csv").call
    all_expenses.concat ExpensesParser.new(file: "./priv/julho.csv").call
    all_expenses.concat ExpensesParser.new(file: "./priv/junho.csv").call

    expenses_group = ExpensesGroup.new
    expenses_group.add_many(all_expenses)

    graph = ExpensesGraph.new(expenses_group)

    query.split(",").map do |filter|
      if filter.include?("=")
        parts = filter.split("=")
        graph.send("partition_by_#{parts.first}", parts.last)
      else
        graph.send("partition_by_#{filter}", nil)
      end
    end

    graph.render
  end
end

