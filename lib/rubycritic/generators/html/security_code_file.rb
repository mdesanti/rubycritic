module Rubycritic
  module Generator
    module Html
      class SecurityCodeFile < CodeFile
        def smells_at(location)
          @analysed_module.security_issues_at_location(location)
        end
      end
    end
  end
end
