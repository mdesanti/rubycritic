require 'rubycritic'
require 'rubycritic/cli/options'
require 'rubycritic/command_factory'

module Rubycritic
  module Cli
    class Application
      STATUS_SUCCESS = 0
      STATUS_ERROR   = 1

      def initialize(argv)
        @options = Options.new(argv)
      end

      def execute
        parsed_options = @options.parse
        
        reporter = Rubycritic::CommandFactory.create(parsed_options.to_h).execute
        print(reporter.status_message)
        reporter.status
      rescue OptionParser::InvalidOption => error
        $stderr.puts "Error: #{error}"
        STATUS_ERROR
      end

      def print(message)
        $stdout.puts message
      end
    end
  end
end
