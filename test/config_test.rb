require "test/unit"
require "growl_glue"

class ConfigTest < Test::Unit::TestCase
  
  def test_simple_retrieval
    config = GrowlGlue::Config.new(:color => :blue)
    assert_equal :blue, config.option(:color)
  end
  
  def test_fancy_setters
    config = GrowlGlue::Config.new
    config.likes :color => :blue
    assert_equal :blue, config.option(:likes, :color)
  end
  
  def test_returns_nil
    config = GrowlGlue::Config.new
    assert_nil config.option(:non_existent)
  end
  
  
end

