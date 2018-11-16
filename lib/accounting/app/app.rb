require 'csv'
require 'pry'
require 'money'

require_relative './graph'
require_relative './expenses/expense'
require_relative './expenses/group'

Money.default_currency = Money::Currency.new("EUR")
I18n.enforce_available_locales = false

class CategoryValidtor
  @@valid_categories = [
    'ignore', 'groceries', 'other', 'game', 'vacations', 'home_expenses', 'out', 'fun',
    'rent', 'gym', 'farmacy', 'gas', 'tool', 'cleaning_lady', 'other_income', 'gift', 'conference', 'health'
  ]

  def self.valid?(category)
    @@valid_categories.include?(category)
  end
end

class ExpensesLoader
  def initialize(file:)
    @file = file
  end

  def call
    @expenses = CSV.read(@file, { headers: true, return_headers: false })
      .map do|row|
        category = row[3].strip!
        date = row[0]

        validate_category!(date, category)

        Expenses::Expense.new(
          date: date,
          description: row[1],
          amount: row[2],
          category: category
        )
      end
      .reject { |expense| expense.category == 'ignore' }
  end

  private

  def validate_category!(date, category)
    throw StandardError.new("Invalid category #{category} in #{date}")  if !CategoryValidtor.valid?(category)
  end
end

class App
  def self.explore(query, options = {})
    files = Dir.glob(options[:files_pattern] || "./spec/fixture/*.csv")

    expenses = files.each_with_object([]) do |file, expenses|
      expenses.concat ExpensesLoader.new(file: file).call
    end

    expenses_group = Expenses::Group.new
    expenses_group.add_many(expenses)

    graph = Graph.new(expenses_group)

    query.split(",").map do |filter|
      if filter.include?("=")
        parts = filter.split("=")
        graph.send("partition_by_#{parts.first}", parts.last)
      else
        graph.send("partition_by_#{filter}", nil)
      end
    end

    graph.render(options)
  end
end
