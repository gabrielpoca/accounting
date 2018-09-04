require 'money'
require 'monetize'

require_relative './filters'

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

class ExpensesGroup
  include Enumerable

  attr_accessor :expenses

  def initialize()
    @expenses = []
  end

  def add(expense)
    @expenses.push(expense)
  end

  def add_many(expenses)
    @expenses.concat(expenses)
  end

  def total
    @expenses.inject(Money.new(0)) do |amount, expense|
      amount + expense.amount
    end
  end

  Filters.all.each do |filter|
    define_method("partition_by_#{filter}") do |query|
      by_filter = @expenses.inject({}) do |memo, expense|
        filter_value = expense.send(filter)
        memo[filter_value] ||= ExpensesGroup.new
        memo[filter_value].add(expense)
        memo
      end

      if query
        by_filter.select { |key, value| key == query }
      else
        by_filter
      end
    end
  end

  def each(&block)
    @expenses.each(&block)
  end
end
