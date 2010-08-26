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

      Time.now - start
    rescue => e
      puts e
    end  

  end  
end
