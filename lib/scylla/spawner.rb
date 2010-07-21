module Scylla
  class Spawner
    
    attr_accessor :threads, :files
    
    def initialize(files)
      self.threads = []
      self.files = files
    end
    
    def run!
      puts files.inspect
      files.each {|f| spawn(f) }
      threads
    end
    
    def spawn(path)
      
      t = Thread.new do
        config = YAML.load_file(path)
        Thread.current[:name] = name = File.basename(path, '.yml')
        
        log = File.new "/Users/sntjon/Desktop/#{name}.log", "a+"
        log.write "started at #{Time.now}"
        log.flush
        log.write `#{config["command"]}`
        log.write "Finished"
        
      end
      
      threads << t
    end
    
  end
end