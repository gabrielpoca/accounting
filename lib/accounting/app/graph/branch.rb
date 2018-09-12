require_relative "../filters"
require_relative "./leaf"

class Graph
  class Branch
    include Enumerable

    def initialize(nodes_by_value)
      @nodes_by_value = nodes_by_value
    end

    Filters.all.each do |filter|
      define_method("partition_by_#{filter}") do |query|
        @nodes_by_value.transform_values! do |node|
          if node.is_a?(Leaf)
            Branch.new(node.send("partition_by_#{filter}", query))
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

    def render(level: 1, details: false,pastel:)
      @nodes_by_value.map do |value, node|
        if node.is_a?(Leaf)
          node.render(label: value, details: details, pastel: pastel)
        else
          header = level > 2 ? value : pastel.bold(value)
          renders = node.render(level: level + 1, details: details, pastel: pastel)
          renders.map { |r| " " * level + r }.unshift(header + "\n")
        end
      end.flatten
    end
  end
end
