module Scylla
  class Main
    
    class << self
      def execute(args)
        new(args).execute!
      end
    end
    
    attr_accessor :args, :options, :threads
    
    def initialize(args)
      self.args    = args.dup
      self.options = Options.parse!(self.args)
    end
    
    def execute!
      self.threads = Spawner.new(gather_files).run!
      threads.map(&:join)
      puts 'done'
    end    
    
  private
  
    def gather_files
      options.paths.inject([]) do |arr, p|
        path = File.expand_path(p)
        ymls = (Dir["#{path}/**/config/scylla/*.yml"].map {|p| File.expand_path(p)} ).uniq
        arr += ymls
      end
    end
  
  end
end