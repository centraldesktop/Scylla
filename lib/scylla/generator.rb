require 'ostruct'
require 'erb'

module Scylla
  class Generator
    
    def initialize(raw_results, options)
      @raw_results = raw_results
      @options     = options
      @template    = "views/scylla.html.erb"
      @results     = OpenStruct.new({
        :title             => "Run 1234",
        :total_scenarios   => 0,
        :total_steps       => 0,
        :sc_pass           => 0,
        :st_pass           => 0,
        :features          => [],
        :failing_scenarios => []
      })
    end
    
    def generate!
      @raw_results.each do |r|
        feature_name = r.keys.first.split("/").last.gsub(/\.feature/,'')
        @results.features << feature_name
        res = r.values.first

        @results.total_scenarios += res[:scenarios][:total].to_i
        @results.sc_pass         += res[:scenarios][:passed].to_i
        @results.total_steps     += res[:steps][:total].to_i
        @results.st_pass         += res[:steps][:passed].to_i

        @results.failing_scenarios << feature_name if res[:scenarios][:passed].to_i < res[:scenarios][:total].to_i
      end

      @results.sc_pass_rate = (@results.sc_pass * 100 / @results.total_scenarios )
      @results.st_pass_rate = (@results.st_pass * 100 / @results.total_steps )
      @results.overall_score = (@results.sc_pass_rate * @results.st_pass_rate) * 100 / 200
      
      @results.message, @results.css_class = *get_message
      
      generate_template
    end
    
    private
    
    def generate_template
      begin
        erb = ERB.new(IO.read(@file)).result(binding)
      rescue Exception => e
        raise "#{@file} was found, but could not be parsed with ERB. Got #{e}"
      end

      File.open('/Users/sntjon/Desktop/scylla/scylla.html', 'w') {|f| f.write(erb) }
    end
    
    def get_message
      total = (@results.sc_pass_rate + @results.st_pass_rate)
      case total.to_i
      when 0..190
        ["Failed","red"]
      when 190..199
        ["Almost!","yellow"]
      when 200
        ["All Good","green"]
      end
    end

    def get_stats(path, feature)
      results = {}
      doc     = Nokogiri::HTML(File.read(path))
      text    = doc.css("script").last.text
      md      = text.match(/^document.getElementById\('totals'\).innerHTML = "(.*)";$/)
      totals  = md.captures.shift.split("<br />")
      
      totals.each do |total|
        hash = {}
        res = total.split(/( \(|, )/).select {|t| t.to_i > 0 }
        res.each {|r| r.gsub!(/\)$/,'')}
        type = res.shift
        
        res.each {|r| hash[r.split.last.to_sym] = r.to_i }
        hash[:total] = type.to_i
        results[type.split.last.to_sym] = hash
      end
      
      {feature => results}
    end

  end
end
