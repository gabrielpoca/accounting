require 'money'
require 'pastel'

require_relative "./filters"

class LeafNode
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
        LeafNode.new(expenses_group)
      end
    end
  end

  def render(label:,details:, pastel: Pastel.new)
    res = ["#{pastel.bold(label)} => #{pastel.money(total.format)}"]

    if details
      res.concat(expenses.map do |expense|
        "\t#{expense.date} #{pastel.money(expense.amount.format)} => #{expense.description}"
      end)
    end

    res
  end
end

class BranchNode
  include Enumerable

  def initialize(nodes_by_value)
    @nodes_by_value = nodes_by_value
  end

  Filters.all.each do |filter|
    define_method("partition_by_#{filter}") do |query|
      @nodes_by_value.transform_values! do |node|
        if node.is_a?(LeafNode)
          BranchNode.new(node.send("partition_by_#{filter}", query))
        else
          node.send("partition_by_#{filter}", query)
          node
        end
      end
    end
  end

  def total
    @nodes_by_value.inject(Money.new(0)) do |amount, (value, node)|
      amount + node.total
    end
  end

  def render(level: 1, details: false, pastel: Pastel.new)
    @nodes_by_value.map do |value, node|
      if node.is_a?(LeafNode)
        node.render(label: value, details: details, pastel: pastel)
      else
        renders = node.render(level: level + 1, details: details)
        renders.map { |r| "\t" * level + r }.unshift("#{pastel.bold(value)} =>\n")
      end
    end.flatten
  end
end

class ExpensesGraph
  attr_accessor :root

  def initialize(expenses_group)
    @root = BranchNode.new({ "root" => LeafNode.new(expenses_group) })
    @pastel = Pastel.new

    @pastel.alias_color(:money, :yellow)
  end

  Filters.all.each do |filter|
    define_method("partition_by_#{filter}") do |query|
      @root.send("partition_by_#{filter}", query)
    end
  end

  def render(opts)
    @root.render(details: opts[:details], pastel: @pastel)
  end
end
