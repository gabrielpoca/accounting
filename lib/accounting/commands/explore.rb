# frozen_string_literal: true

require_relative '../command'
require_relative "../app/app"

module Accounting
  module Commands
    class Explore < Accounting::Command
      def initialize(query, options)
        @query = query
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        output.puts App.explore(@query, @options)
      end
    end
  end
end
