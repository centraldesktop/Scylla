module Scylla
  class Main
    
    class << self
      def execute(args)
        new(args).execute!
      end
    end
    
    attr_accessor :args, :options
    
    def initialize(args)
      self.args    = args.dup
      self.options = Options.parse!(self.args)
    end
    
    def execute!
      results = Spawner.new(get_yml_config).run!
      puts results
    end
    
  private
  
    def get_yml_config
      path = self.options.config_file_path || "#{Dir.pwd}/config/scylla.yml"
      config = YAML.load_file(path)
    end
  
  end
end
