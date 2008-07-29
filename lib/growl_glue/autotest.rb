module GrowlGlue
  class Autotest
    [Util, Commands].each { |cls| extend cls }
    
    ERROR_PRI = 2
    
    def self.initialize
      @config = Config.new
      
      @config.sound :location => "/System/Library/Sounds/"
      @config.commands :safe_growlnotify => File.join(gem_home_dir, "lib", "bin", "growl_notify.sh")
      
      [:failure, :success, :pending].each do |status|
        @config.image status => File.join(gem_home_dir, "lib", "img", "#{status}.png")
      end
      
      @config.title :success => "Tests Passed"
      @config.title :pending => "Tests Passed, Some Pending"
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

    def self.say(msg, voice=nil)
      if msg
        voice = "-v #{voice}" if voice
        "say #{voice} '#{msg.gsub(/'/,"")}'"
      end
    end

    def self.sndplay(sound)
      location = @config.option :sound, :location
      if sound and location
        "sndplay #{location}/#{sound} > /dev/null 2>&1"
      end
    end

    def self.notify(status, title, msg, img=nil, pri=1)
      with_commands do |commands|
        commands << growl(title, msg, img, pri)
        commands << say(@config.option(:say, status), @config.option(:voice, status))
        commands << sndplay(@config.option(:sound, status))
      end
    end

    # handles rspec results
    def self.rspec_results(results)
      output = results.slice(/(\d+)\s+examples?,\s*(\d+)\s+failures?(,\s*(\d+)\s+pending)?/)  
      if output  
        successes, failures, pending = *([$~[1],$~[2],$~[4]].map { |x| x.to_i })
        if failures > 0  
          notify :failure, @config.option(:title, :failure), "#{output}", @config.option(:image, :failure), 2  
        elsif pending > 0
          notify :pending, @config.option(:title, :pending), "#{output}", @config.option(:image, :pending)
        else  
          notify :success, @config.option(:title, :success), "#{output}", @config.option(:image, :success)   
        end  
      end  
    end

    # handles test::unit results
    def self.test_results(results)
      output = results.slice(/(\d+)\s+tests?,\s*(\d+)\s+assertions?,\s*(\d+)\s+failures?,\s*(\d+)\s+errors?/)  
      if output  
        if (($~[3].to_i > 0) or ($~[4].to_i > 0))  
          notify :failure, @config.option(:title, :failure), "#{output}",  @config.option(:image, :failure), 2  
        else  
          notify :success, @config.option(:title, :success), "#{output}",  @config.option(:image, :success)   
        end  
      end  
    end

    def self.process_results(results)
      rspec_results(results)
      test_results(results)
    end
    
    
  end
end