require 'rubycritic/colorize'
require 'brakeman'
require 'brakeman/options'

module Rubycritic
  module Analyser
    class Brakeman
      include Colorize
      attr_writer :source_control_system

      def initialize(analysed_modules)
        @analysed_modules = analysed_modules
        @source_control_system = Config.source_control_system
      end

      def run
        json = brakeman_report['warnings'].group_by { |warning| warning['file'] }
        @analysed_modules.each do |analysed_module|
          path = analysed_module.path
          warnings = json[path]
          next if warnings.nil?
          warnings.each do |warning|
            analysed_module.security_issues << create_smell(analysed_module, warning)
          end
        end
      end

      def create_smell(analysed_module, warning)
        Smell.new(
          locations: Location.new(analysed_module.path, warning['line']),
          context: 'Security',
          message: warning['message'],
          score: 0,
          type: warning['warning_type'],
          cost: 0,
          analyser: 'brakeman'
        )
      end

      def to_s
        'brakeman'
      end

      private

      def brakeman_report
        report = ::Brakeman.run(brakeman_options)
        JSON.parse(report.report.format(:to_json))
      end

      def brakeman_options
        app_path = @analysed_modules.first.base.first
        options, _parser = ::Brakeman::Options.parse! []
        options.merge!(output_formats: :json, print_report: true, app_path: app_path)
      end
    end
  end
end
