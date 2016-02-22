require 'rubycritic/generators/json/simple'

module Rubycritic
  module Generator
    class JsonReport
      def initialize(analysed_modules)
        @analysed_modules = analysed_modules
      end

      def generate_report
        report =  generator.render
        File.open(Config.root + '/report.json', 'w+') do |file|
          file.write(report)
        end
      end

      private

      def generator
        Json::Simple.new(@analysed_modules)
      end
    end
  end
end
