module GrowlGlue
  
  class Config
    attr_reader :options
    
    def initialize(options={})
      @options=options
    end

    # returns a nested option value
    def option(*keys)
      option = @options
      until keys.empty? or option.nil?
        option = option[keys.shift]
      end
      option
    end

    def method_missing(name, *args, &block)
      self.set_options(name, *args)
    end
    
    def set_options(key, opts)
      @options[key] ||= {}
      @options[key].merge!(opts)
    end
  end
  
end