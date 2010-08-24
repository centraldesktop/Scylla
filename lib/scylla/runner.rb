require 'tempfile'
module Scylla
  
  class Runner
    
    # run all the scenarios in a cucumber feature file
    def run_feature!(file, config)
      start = Time.now
      cucumber = config["cucumber"] || "cucumber"
      export_path = config["export_path"]
      html = Tempfile.new "scylla_output_#{Thread.current.object_id}.html"
      `#{cucumber} --format html -o #{html.path} #{file}`
      puts "Finished running #{file}"
      
      feature = file.split("/").last.gsub("feature","html")
      puts "exporting to #{feature}"      
      File.open(export_path + feature, "w") {|f| f.write(File.read(html.path)) }
      results = get_stats(html.path, feature)
      return results, (Time.now - start)
      
    rescue => e
      puts e
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
