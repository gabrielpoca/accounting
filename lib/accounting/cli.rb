# frozen_string_literal: true

require 'thor'

module Accounting
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'accounting version'
    def version
      require_relative 'version'
      puts "v#{Accounting::VERSION}"
    end
    map %w(--version -v) => :version

    desc 'explore [QUERY]', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def explore(query = "month")
      if options[:help]
        invoke :help, ['explore']
      else
        require_relative 'commands/explore'
        Accounting::Commands::Explore.new(query, options).execute
      end
    end
  end
end
