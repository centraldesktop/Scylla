require 'rubygems'
require 'cucumber'
require 'cucumber/formatter/duration'

module Scylla
  class Main
    include Cucumber::Formatter::Duration
    
    class << self
      def execute(args)
        new(args).execute!
      end
    end
    
    def initialize(args)
      @args    = args.dup
      @options = Options.parse!(@args)
    end
    
    def execute!
      start = Time.now
      results = Spawner.new(get_yml_config, @options).run!
      puts results + " testing time"
      puts format_duration(Time.now - start) + " actual time"
    end
    
  private
  
    def get_yml_config
      path = @options.config_file_path || "#{Dir.pwd}/config/scylla.yml"
      config = YAML.load_file(path)
    end
  
  end
end
