require 'ostruct'
require 'erb'
require 'hpricot'

module Scylla
  class Generator
    
    def initialize(results_path)
      @results_path = results_path
      @template     = "#{File.dirname(__FILE__)}/views/scylla.html.erb"
    end
    
    def generate!
      @runs = []
      
      Dir["#{@results_path}/*"].reverse.each do |run|
        ran_at = Time.at(run.match(/\d+/)[0].to_i)
        
        @results = OpenStruct.new({
          :total_scenarios   => 0,
          :sc_pass           => 0,
          :features          => [],
          :failing_scenarios => []
        })
        
        Dir["#{run}/TEST*"].each do |result_path| 
          
          result = get_stats(result_path)
          @results.failing_scenarios << result.name if result.failures.to_i > 0
          @results.total_scenarios += result.tests.to_i
          @results.sc_pass         += result.tests.to_i - (result.failures.to_i + result.errors.to_i)
        end
        
        @results.sc_pass_rate = (@results.sc_pass * 100 / @results.total_scenarios )
        @results.message, @results.css_class = *get_message(@results.sc_pass_rate)
        @runs << OpenStruct.new({:name => ran_at.strftime("%a %m.%d.%y at %I:%M %p"), :results => @results})
        
        break if @runs.size == 10
      end
      
      generate_template
    end
    
    private
    
    def generate_template
      erb = ERB.new(IO.read(@template)).result(binding)
      File.open('/Users/sntjon/Desktop/scylla/scylla.html', 'w') {|f| f.write(erb) }
    end
    
    def get_message(int)
      case int.to_i
      when 0..97
        ["Failed","red"]
      when 98, 99
        ["Almost!","yellow"]
      when 100
        ["All Good","green"]
      end
    end

    def get_stats(path) 
      doc     = open(path) {|f| Hpricot(f) }
      results = OpenStruct.new(doc.at("testsuite").attributes.to_hash)
    end

  end
end
