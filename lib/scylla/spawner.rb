require 'scylla/runner'

module Scylla
  class Spawner
    
    attr_accessor :threads, :config, :result_string
    
    def initialize(config)
      self.threads = []
      self.config  = config
      self.result_string = ""
    end
    
    def run!
      
      puts config.inspect
      
      max_workers = config["workers"].to_i
      features    = config["features"]
      
      loop do
        # fill up the workers
        # puts "filling up workers"
        until active_threads.size == max_workers || features.empty?
          spawn(features.shift)
        end
        
        # wait while they work
        # puts threads.inspect
        loop do 
          break if active_threads.size < max_workers
        end
      
        # we're done!
        break if features.empty? && active_threads.empty?
        # sleep(10)
      end
      
      result_string
    end
    
    private
    
    def spawn(file)
      return if file.nil?
      t = Thread.new do
        result_string << Runner.new.run_feature!(file)
      end
      
      threads << t
    end
    
    def active_threads
      threads.map(&:alive?).delete_if {|t| !t }
    end
    
  end
end