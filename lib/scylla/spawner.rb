require 'scylla/runner'
require 'cucumber/formatter/duration'
require 'pp'
require 'fileutils'

module Scylla
  class Spawner
    
    include Cucumber::Formatter::Duration
    
    def initialize(config, options)
      @threads = []
      @config  = config
      @seconds = 0
      @options = options
    end
    
    def run!
      max_workers = @config["workers"].to_i
      features    = []
      
      @config["features"].each do |path|
        if File.directory?(path)
          features += Dir["#{path}/**/*.feature"]
        else
          features << path
        end
      end
      
      # divide the features up evenly between the workers
      features = features.chunk(max_workers)
      
      @config["export_path"] = @options.export_path || @config["export"] + "scylla_run_#{Time.now.to_i}/"
      FileUtils.mkdir_p(@config["export_path"])

      features.each {|f| spawn(f.join(" ")) }
      
      # # this is the main loop, picking off features and spawning new threads
      # until features.empty? && active_threads.empty?
      #   # fill up the workers
      #   until active_threads.size == max_workers || features.empty?
      #     spawn(features.shift)
      #     # puts @threads.inspect
      #   end
      #   
      #   # wait while they work
      #   until active_threads.size < max_workers
      #     sleep(1)
      #   end
      #   
      #   # we're done!
      # end
      
      # Generator.new(@options).generate!
      
      format_duration(@seconds)
    end
    
    private
    
    def spawn(file)
      return if file.nil?
      t = Thread.new do  
        secs = Runner.new.run_feature!(file, @config)
        @seconds += secs
      end
      
      @threads << t
    end
    
    def active_threads
      @threads.map(&:alive?).delete_if {|t| !t }
    end
    
  end
end