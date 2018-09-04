require 'money'
require 'pastel'

require_relative "./filters"
require_relative "./graph/branch"
require_relative "./graph/leaf"

class Graph
  attr_accessor :root

  def initialize(expenses_group)
    @root = Branch.new({ "root" => Leaf.new(expenses_group) })
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
