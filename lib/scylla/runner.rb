require 'rubygems'
require 'cucumber'
require 'cucumber/formatter/pretty'

module Scylla
  
  class Runner
    
    # run all the scenarios in a cucumber feature file
    def run_feature!(file)
      
      start = Time.now

      # files = [file]
      # dev_null = StringIO.new
      # scylla_response = StringIO.new
      # scylla_response = File.new("/Users/sntjon/Desktop/scylla_#{Thread.current.object_id}.log", 'a+')

      # @step_mother = Cucumber::StepMother.new
      # @cuke_configuration = Cucumber::Cli::Configuration.new(dev_null, dev_null)
      # @cuke_configuration.parse!(['features']+files)
      # 
      # @step_mother.options = @cuke_configuration.options
      # @step_mother.log = @cuke_configuration.log
      # @step_mother.load_code_files(@cuke_configuration.support_to_load)
      # @step_mother.after_configuration(@cuke_configuration)
      # @step_mother.load_code_files(@cuke_configuration.step_defs_to_load)
      # 
      # cuke_formatter = Cucumber::Formatter::Pretty.new(
      #   @step_mother, scylla_response, @cuke_configuration.options
      # )
      # 
      # cuke_runner ||= Cucumber::Ast::TreeWalker.new(
      #   @step_mother, [cuke_formatter], @cuke_configuration.options, dev_null
      # )
      # @step_mother.visitor = cuke_runner
      # 
      # features = @step_mother.load_plain_text_features(files)
      # tag_excess = tag_excess(features, @cuke_configuration.options[:tag_expression].limits)
      # @cuke_configuration.options[:tag_excess] = tag_excess
      # 
      # cuke_runner.visit_features(features)
      # 
      # scylla_response.rewind
      
      out = "/Users/sntjon/Desktop/scylla_#{Thread.current.object_id}.log"
      
      `cucumber -o #{out} #{file} `
      
      return Time.now - start
    end
    
    # Yanked a method from Cucumber
    def tag_excess(features, limits)
      limits.map do |tag_name, tag_limit|
        tag_locations = features.tag_locations(tag_name)
        if tag_limit && (tag_locations.length > tag_limit)
          [tag_name, tag_limit, tag_locations]
        else
          nil
        end
      end.compact
    end
    
  end
  
end
