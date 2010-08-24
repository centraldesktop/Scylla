# require 'cucumber/formatter/progress'

module Scylla #:nodoc:
  module Formatter #:nodoc:
    # Scylla formatter for cucumber.
    # Doesn't actually print anything to the screen, just collects information about the runs and 
    # saves it to produce one cohesive output after all the threads have finished.
    class Scylla
      # this is the callback structure for cucumber
      # we will implement each of these methods as they are needed
      # 
      # before_features
      #   before_feature
      #     before_tags
      #     after_tags
      #     feature_name
      #     before_feature_element
      #       before_tags
      #       after_tags
      #       scenario_name
      #       before_steps
      #         before_step
      #           before_step_result
      #             step_name
      #           after_step_result
      #         after_step
      #       after_steps
      #     after_feature_element
      #   after_feature
      # after_features
      
      def initialize(step_mother, io, options)
        @step_mother = step_mother
        @ios = File.new("/Users/sntjon/Desktop/scylla_#{Thread.current.object_id}.log", 'a+')
        @options = options
      end
      
      def before_feature(*args, &block)
        
        @ios.write %Q{
          Call to before_feature:
          
          #{args.inspect}
          
        }
        
      end
      
    end
  end
end
