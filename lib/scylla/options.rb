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
      options.output = STDOUT
      options.env_vars = {}
      options.paths = [Dir.pwd]

      opts = OptionParser.new do |opts|
        opts.on("-o OUTPUT_FILE","--output OUTPUT_FILE","Direct the output somewhere other than STDOUT") do |out|
          options.output = File.new(out, "a+")
        end
        opts.on_tail("-h", "--help", "You're looking at it.") do
          STDOUT.puts opts.help
          Kernel.exit(0)
        end
      end
      opts.parse!(args)
      extract_environment_variables
      options.paths = args #whatever is left
      options
    end
  
  private
  
    def extract_environment_variables
      args.delete_if do |arg|
        if arg =~ /^(\w+)=(.*)$/
          options.env_vars[$1] = $2
          true
        end
      end
    end
  
  end
end