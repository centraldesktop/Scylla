require 'scylla/runner'
require 'cucumber/formatter/duration'
require 'pp'
require 'fileutils'

module Scylla
  class Spawner
    
    include Cucumber::Formatter::Duration
    
    attr_accessor :threads, :config, :results, :seconds
    
    def initialize(config)
      self.threads = []
      self.config  = config
      self.results = []
      self.seconds = 0
    end
    
    def run!
      max_workers = config["workers"].to_i
      features    = []
      
      config["features"].each do |path|
        if File.directory?(path)
          features += Dir["#{path}/**/*.feature"]
        else
          features << path
        end
      end
      
      config["export_path"] = config["export"] + "scylla_run_#{Time.now.to_i}/"
      FileUtils.mkdir_p(config["export_path"])
      
      # this is the main loop, picking off features and spawning new threads
      until features.empty? && active_threads.empty?
        # fill up the workers
        until active_threads.size == max_workers || features.empty?
          spawn(features.shift)
          puts threads.inspect
        end
        
        # wait while they work
        until active_threads.size < max_workers
          sleep(1)
        end
        
        # we're done!
      end
      
      pp self.results
      
      format_duration(self.seconds)
    end
    
    private
    
    def spawn(file)
      return if file.nil?
      t = Thread.new do  
        res, secs = Runner.new.run_feature!(file, config)
        self.seconds += secs
        self.results << res
      end
      
      threads << t
    end
    
    def active_threads
      threads.map(&:alive?).delete_if {|t| !t }
    end
    
  end
end