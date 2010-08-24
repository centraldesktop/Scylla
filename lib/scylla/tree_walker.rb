module Scylla
  class TreeWalker
    
    def initialize(*args)
      @tree_walker = Cucumber::Ast::TreeWalker.new(*args)
    end
    
    # send everything to the tree_walker, but make sure it's threadsafe
    def method_missing(sym, *args, &block)
      puts "before Thread#{Thread.current.object_id} #{MUTEX.locked?.inspect}"
      
      if @current_thread == Thread.current.object_id
        @tree_walker.send(sym, *args, &block)
      else
        
        MUTEX.synchronize do
          puts "begin Thread#{Thread.current.object_id} #{MUTEX.locked?.inspect}"
        
          @current_thread = Thread.current.object_id
          @tree_walker.send(sym, *args, &block)
        end
      end
      
      puts "after Thread#{Thread.current.object_id} #{MUTEX.locked?.inspect}"
      
    end
    
  end
end