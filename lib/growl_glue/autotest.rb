module GrowlGlue
  class Autotest
    [Util, Commands].each { |cls| extend cls }
    
    ERROR_PRI = 2
    
    def self.setup
      @config = Config.new
      
      @config.sound :location => "/System/Library/Sounds/"
      @config.commands :safe_growlnotify => File.join(gem_home_dir, "lib", "bin", "growl_notify.sh")
      
      @config.image :failure => File.join(gem_home_dir, "lib", "img", "fail.png")
      @config.image :success => File.join(gem_home_dir, "lib", "img", "ok.png")
      
      @config.title :success => "Tests Passed"
      @config.title :failure => "Tests Failed"
      
      yield @config if block_given?
      
      add_hook
    end
    
    private 
    
    def self.gem_home_dir
      File.join File.dirname(__FILE__), "..", ".."
    end

    def self.add_hook
      ::Autotest.add_hook :ran_command do |at|  
        with([at.results].flatten.join("\n")) do |results|
          process_results(results)
        end
      end  
    end

    def self.growl(title, msg, img=nil, pri=1, sticky="")
      command = []
      
      if @config.option(:notification, :use_network_notifications)
        command << @config.option(:commands, :safe_growlnotify)
      else
        command << "growlnotify"
      end
      command << "--image #{img}" if img
      command << "-n autotest"
      command << "-p #{pri}"
      command << "-m #{msg.inspect}"
      command << title
      command << sticky
      command.join(" ")
    end

    def self.say(msg)
      if msg
        "say '#{msg.gsub(/'/,"")}'"
      end
    end

    def self.sndplay(sound)
      location = @config.option :sound, :location
      if sound and location
        "sndplay #{location}/#{sound} > /dev/null 2>&1"
      end
    end

    def self.notify(title, msg, img=nil, pri=1)
      with_commands do |commands|
        commands << growl(title, msg, img, pri)

        if pri == ERROR_PRI
          commands << say(@config.option(:say, :failure))
          commands << sndplay(@config.option(:sound, :failure))
        else
          commands << say(@config.option(:say, :success))
          commands << sndplay(@config.option(:sound, :success))
        end
      end
    end

    # handles rspec results
    def self.rspec_results(results)
      output = results.slice(/(\d+)\s+examples?,\s*(\d+)\s+failures?(,\s*(\d+)\s+pending)?/)  
      if output  
        if $~[2].to_i > 0  
          notify @config.option(:title, :failure), "#{output}", @config.option(:image, :failure), 2  
        else  
          notify @config.option(:title, :success), "#{output}", @config.option(:image, :success)   
        end  
      end  
    end

    # handles test::unit results
    def self.test_results(results)
      output = results.slice(/(\d+)\s+tests?,\s*(\d+)\s+assertions?,\s*(\d+)\s+failures?,\s*(\d+)\s+errors?/)  
      if output  
        if (($~[3].to_i > 0) or ($~[4].to_i > 0))  
          notify @config.option(:title, :failure), "#{output}",  @config.option(:image, :failure), 2  
        else  
          notify @config.option(:title, :success), "#{output}",  @config.option(:image, :success)   
        end  
      end  
    end

    def self.process_results(results)
      rspec_results(results)
      test_results(results)
    end
    
    
  end
end