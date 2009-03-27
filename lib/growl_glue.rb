%w(util commands config autotest).each do |file| 
  require File.join(File.dirname(__FILE__), "growl_glue/#{file}.rb")
end

module GrowlGlue
  VERSION = '1.0.7'  
end