require 'money'

require_relative "./filters"

class LeafNode
  include Enumerable
  extend Forwardable

  attr_reader :expenses_group
  def_delegators :@expenses_group, :total, :each

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

  def render
    total.format
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

  def render(level:)
    @nodes_by_value.map do |value, node|
      str = "#{value} => "

      if node.is_a?(LeafNode)
        str += node.render
      else
        renders = node.render(level: level + 1)
        renders.push("TOTAL => #{node.total}")
        indented_renders = renders.map { |r| "\t" * level + r }.join("\n")

        str += "\n"
        str +=  indented_renders
      end

      str
    end
  end
end

class ExpensesGraph
  attr_accessor :root

  def initialize(expenses_group)
    @root = BranchNode.new({ "root" => LeafNode.new(expenses_group) })
  end

  Filters.all.each do |filter|
    define_method("partition_by_#{filter}") do |query|
      @root.send("partition_by_#{filter}", query)
    end
  end

  def render
    @root.render(level: 1)
  end
end
