require 'scylla/runner'
require 'cucumber/formatter/duration'
module Scylla
  class Spawner
    
    include Cucumber::Formatter::Duration
    
    attr_accessor :threads, :config, :result_string, :seconds
    
    def initialize(config)
      self.threads = []
      self.config  = config
      self.result_string = ""
      self.seconds = 0
    end
    
    def run!
      max_workers = config["workers"].to_i
      features    = config["features"]
      
      until features.empty? && active_threads.empty?
        # fill up the workers
        until active_threads.size == max_workers || features.empty?
          spawn(features.shift)
          sleep(3)
        end
        
        # wait while they work
        until active_threads.size < max_workers
          sleep(1)
        end
        
        
        # threads.select {|t| t.alive? }.first.join
        
        # we're done!
      end
      
      format_duration(self.seconds)
    end
    
    private
    
    def spawn(file)
      return if file.nil?
      t = Thread.new do
        self.seconds += Runner.new.run_feature!(file)
      end
      
      threads << t
    end
    
    def active_threads
      threads.map(&:alive?).delete_if {|t| !t }
    end
    
  end
end