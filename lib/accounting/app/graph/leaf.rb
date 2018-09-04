require 'pastel'

require_relative "../filters"

class Graph
  class Leaf
    include Enumerable
    extend Forwardable

    attr_reader :expenses_group
    def_delegators :@expenses_group, :total, :each, :expenses

    def initialize(expenses_group)
      @expenses_group = expenses_group
    end

    Filters.all.each do |filter|
      define_method("partition_by_#{filter}") do |query|
        @expenses_group.send("partition_by_#{filter}", query).transform_values do |expenses_group|
          Leaf.new(expenses_group)
        end
      end
    end

    def render(label:,details:,pastel:)
      res = ["#{pastel.bold(label)} => #{pastel.money(total.format)}"]

      if details
        res.concat(expenses.map do |expense|
          "\t#{expense.date} #{pastel.money(expense.amount.format)} => #{expense.description}"
        end)
      end

      res
    end
  end
end
