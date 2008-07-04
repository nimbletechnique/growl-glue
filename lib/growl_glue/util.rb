module GrowlGlue
  module Util
    
    def with(obj)
      yield obj
      obj
    end
    
  end
end
