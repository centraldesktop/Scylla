module Scylla
  class Options
    
    class << self
      def parse!(args)
        new(args).options
      end
    end
    
    attr_accessor :args, :options
    
    def initialize(args)
      args = args
      #define the default options
      options = OpenStruct.new
      options.env_vars = {}
      options.paths = [Dir.pwd]
      options.generate_only = false
      
      opts = OptionParser.new do |opts|
        opts.on("-o OUT_DIR","--output OUT_DIR","Tell Scylla where to put the results.") do |path|
          options.export_path = path
        end
        opts.on("-c CONFIG_PATH","--config CONFIG_PATH","Tell Scylla where the config file is.") do |path|
          options.config_file_path = path
        end
        opts.on("--generate-only","Dont run the tests, just generate the results page.") do
          options.generate_only = true
        end
        opts.on_tail("-h", "--help", "You're looking at it.") do
          STDOUT.puts opts.help
          Kernel.exit(0)
        end
      end
      opts.parse!(args)
      extract_environment_variables
      self.options = options
    end
  
  private
  
    def extract_environment_variables
      return if args.nil?
      args.delete_if do |arg|
        if arg =~ /^(\w+)=(.*)$/
          options.env_vars[$1] = $2
          true
        end
      end
    end
  
  end
end