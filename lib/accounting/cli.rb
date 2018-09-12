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
    method_option :details, aliases: '-d', type: :boolean,
                         desc: 'Display more information about the expenses'
    method_option :files_pattern, aliases: '-f', type: :string,
                         desc: 'Regular expression to find CSV files. Defaults to "./priv/*.csv"'
    def explore(query = "month")
      if options[:help]
        invoke :help, ['explore']
      else
        require_relative 'commands/explore'
        app_options = Hash.new
        app_options[:details] = options[:details]
        app_options[:files_pattern] = options[:files_pattern] || "./priv/*.csv"
        Accounting::Commands::Explore.new(query, app_options).execute
      end
    end
  end
end
