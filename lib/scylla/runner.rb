module Scylla  
  class Runner
    
    # run all the scenarios in a cucumber feature file
    def run_feature!(file, config)
      start = Time.now
      cucumber = config["cucumber"] || "cucumber"
      export_path = config["export_path"]

      `#{cucumber} --format junit --out #{export_path} #{file}`

      Time.now - start
    rescue => e
      puts e
    end  

  end  
end
